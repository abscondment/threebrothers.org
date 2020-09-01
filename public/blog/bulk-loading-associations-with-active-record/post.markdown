Here's a fairly common problem I've encountered. Say you have two
classes; for example, a Restaurant and a Cuisine. They exist in a
many-to-many relationship, and have associations defined like so:

<noscript>
  <pre>
    <code>
    class Restaurant < ActiveRecord::Base
      has_many :restaurant_cuisines, :dependent => :delete_all
      has_many :cuisines, :through => :restaurant_cuisines
    end
    
    class Cuisine < ActiveRecord::Base
      has_many :restaurant_cuisines, :dependent => :delete_all
      has_many :restaurants, :through => :restaurant_cuisines
    end
    
    class RestaurantCuisine < ActiveRecord::Base
      belongs_to :restaurant
      belongs_to :cuisine  
    end
    </code>
  </pre>
</noscript>
<script src="//gist.github.com/578503.js" type="text/javascript"></script>    

This is basically the model we use at Urbanspoon. 

Now, there are two interesting aspects to the data we have in this
relationship. First, Urbanspoon know about approximately 40x more 
Restaurants than Cuisines. Second, Cuisine popularity follows
a Zipf distribution. That is, the vast majority of Cuisines are
associated with very few Restaurants. However, the converse is not
true: we enforce that there be ~3 cuisines associated with every
Restaurant in the system.

![Restaurant counts by Cuisine](http://threebrothers.org/brendan/blog/bulk-loading-associations-with-active-record/zipf-cuisines.png)

So, it turns out that the top 1000 Restaurants in Seattle comprise
about 70 distinct cuisines. That fits well with our graph from above,
and provides a good premise for this issue. Let's say we load these
1000 Restaurants and we'd like to display the Cuisines associated with
all of them. What's the best way to do this?

## Na&iuml;ve Attempt

<noscript>
  <pre>
    <code>
    10.times do
      r = Restaurant.find(:all, :conditions => ['id IN (?)', ids])
      r.map(&:cuisines).flatten.map(&:id)
    end
    
    # benchmarked 10 times
         user     system      total        real
    10.170000   0.470000  10.640000 ( 11.809886)
     9.630000   0.410000  10.040000 ( 11.076710)
    11.220000   0.520000  11.740000 ( 12.819519)
    11.140000   0.530000  11.670000 ( 12.702499)
    10.040000   0.520000  10.560000 ( 11.654553)
    10.680000   0.470000  11.150000 ( 12.250775)
    10.050000   0.700000  10.750000 ( 11.763682)
    11.020000   0.480000  11.500000 ( 12.893516)
    10.410000   0.590000  11.000000 ( 12.181406)
    11.460000   0.740000  12.200000 ( 13.326383)
    
    # memory diff from baseline IRB for each run [1]
    8712, 15000, 15092, 15204, 15260, 15324, 15360, 15392, 15424, 15428
    </code>
  </pre>
</noscript>
<script src="//gist.github.com/578505.js" type="text/javascript"></script>

This takes an average of ~12.25 seconds to complete <em>with a hot query
cache</em>. True to intuition, na&iuml;ve loading of associations
is dog slow in this scenario. We're duplicating work left and right,
both in database loading and in ActiveRecord instantiation. If one
Cuisine is referenced by N Restaurants, we pull it from the database N
times and create N objects with identical information.

## Improved Attempt

<noscript>
  <pre>
    <code>
    10.times do
      r = Restaurant.find(:all, :include => [:cuisines], :conditions => ['id IN (?)', ids])
      r.map(&:cuisines).flatten.map(&:id)
    end

    # benchmarked 10 times
        user     system      total        real
    5.540000   0.010000   5.550000 (  5.553716)
    5.560000   0.000000   5.560000 (  5.566566)
    5.670000   0.010000   5.680000 (  5.687871)
    5.670000   0.000000   5.670000 (  5.674870)
    5.580000   0.000000   5.580000 (  5.581576)
    5.670000   0.000000   5.670000 (  5.678692)
    5.570000   0.000000   5.570000 (  5.578353)
    5.630000   0.000000   5.630000 (  5.629657)
    5.740000   0.000000   5.740000 (  5.745029)
    5.560000   0.000000   5.560000 (  5.568952)
    
    # memory diff from baseline IRB for each run [1]
    8896, 14608, 14800, 14932, 15024, 15152, 15248, 15300, 15300, 15300
    </code>
  </pre>
</noscript>
<script src="//gist.github.com/578508.js" type="text/javascript"></script>

Great! We achieved an average speed of almost exactly twice as fast
(~5.63 seconds) by using ActiveRecord's built-in association
loading. But there are two problems with this approach. Firstly, it's
not very flexible or composable. That is, you can't build a handful
of specialized Restaurant-finding functions that are agnostic about
the decision to load Cuisines or not. You can't cache a list of
Restaurants and load the Cuisines later. Basically, if you want to be
efficient, you have to do the Cuisine loading at query time.

The second issue is *still* one of performance. Even though we only
load 73 Cuisine rows from the database, ActiveRecord still allocates
over 2000 unique Cuisine objects. See?

<noscript>
  <pre>
    <code>
    r.map(&:cuisines).flatten.map(&:object_id).uniq.length
     => 2001
    r.map(&:cuisines).flatten.map(&:id).uniq.length
     => 73
    </code>
  </pre>
</noscript>
<script src="//gist.github.com/578511.js" type="text/javascript"></script>

Oy. That means we're consuming roughly 27.4 times the memory and clock
cycles required to instantiate and retain Cuisines. So, what's the
*really* right way to do this?

## Bulk Loading, For Real

The pattern I've used is pretty simple. You query the two associations
separately, and then use an id-to-record map to squash them back
together in code. I did this in a few places in the iLike codebase,
and I found this example waiting for me at Urbanspoon. This final
version combines and improves on my previous attempts, and I have a
few comments to share about it later. But first, the code!

<noscript>
  <pre>
    <code>
    def Restaurant.add_cuisines(restaurants)
      return [] if restaurants.empty?
      
      ids = []
      id_map = {}
      restaurants.each do |r|
        id_map[r[:id]] = r
        ids << r[:id]
        # make sure ActiveRecord won't try to load cuisines again
        r.cuisines.loaded
      end

      # make sure we load each Cuisine once
      cuisine_map = Hash.new {|h,id| h[id] = Cuisine.find(id)}

      RestaurantCuisine.find(:all,
          :conditions => ["restaurant_id in (?)", ids]).each do |row|
        # use the association target so we don't do an insert
        id_map[row[:restaurant_id]].cuisines.target << cuisine_map[row[:cuisine_id]]
      end

      return restaurants
    end
    </code>
  </pre>
</noscript>
<script src="//gist.github.com/578513.js" type="text/javascript"></script>  

OK, that seems reasonable enough. What are the times like?

<noscript>
  <pre>
    <code>
    10.times do
      r = Restaurant.find(:all, :conditions => ['id IN (?)', ids])
      Restaurant.add_cuisines(r)
      r.map(&:cuisines).flatten.map(&:id)
    end
    
    # benchmarked 10 times
        user     system      total        real
    3.070000   0.040000   3.110000 (  3.148139)
    3.040000   0.030000   3.070000 (  3.133394)
    3.060000   0.050000   3.110000 (  3.160772)
    3.050000   0.040000   3.090000 (  3.178049)
    3.100000   0.010000   3.110000 (  3.169859)
    3.070000   0.030000   3.100000 (  3.174384)
    3.120000   0.040000   3.160000 (  3.259299)
    3.120000   0.030000   3.150000 (  3.238029)
    3.100000   0.040000   3.140000 (  3.241258)
    3.060000   0.030000   3.090000 (  3.135886)
    
    # memory diff from baseline IRB for each run [1]
    4388, 10112, 10180, 10252, 10316, 10364, 10408, 10496, 10540, 10472
    </code>
  </pre>
</noscript>
<script src="//gist.github.com/578514.js" type="text/javascript"></script>  
    
Wow, an average of 3.18s! That's significantly faster than the
association loading version. And it uses far less memory, too. In
fact, that's the reason it's so much faster &ndash; you can shave off
43.5% of the total time just by instantiating each database row only
once. This is a total time reduction of 74% over the na&iuml;ve
method.

Additionally, this function can be called as an afterthought. You
can compose various functions and have them still perform well.
You can load Restaurants from any cache or other non-DB resource
and still fetch their associated Cuisines efficiently. Fun times.

### Caveats

I mentioned that I had a few comments about this technique. Most of
them pertain to changes in ActiveRecord from Rails 1.x to Rails
2.x.

* See, the companies I've been working at have all been stuck on
  Rails 1.1.6 &ndash; deplorable, I know. So, previous versions had a
  line like this:
  
    `id_map[row[:restaurant_id]].cuisines << cuisine_map[row[:cuisine_id]] # note, *not* a call to .cuisines.target`

  I'm upgrading Urbanspoon, and I discovered (thanks to unique key
  constraints in the database &ndash; don't ever let anyone tell you
  they're worthless) that modern versions of Rails will treat this
  as an *insert* statement. Yikes. Calling `.cuisines.target` lets you
  modify the array directly, rather than be intercepted by the
  associations codebase.

  My bungling first attempt at working around this was to use
  `instance_eval` to completely override the association during the
  ids-to-restaurants map building phase:

    `r.instance_eval {`
    `  @cuisines = []`
    `  ...`
    `}`

  This is a bad idea, as it litters your codebase with instances of
  Restaurants whose associations may or may not behave correctly.

* The fact that each Restaurant now points to a single instance
  of the same cuisine could lead to unexpected things. That is, if
  Restaurants A and B both have the 'Chinese' cuisine, you can modify
  the Cuisines of A and see the change reflected in B without saving
  and reloading. This different than the normal associations behavior,
  but I think it's acceptable, and perhaps even preferable.

* Finally, I think this technique could be generalized easily and
  added to ActiveRecord. I haven't researched whether others have
  gone down this path before, so it's entirely possible that one
  can do this already with a hip plugin that I haven't seen.
  
  I also don't know if the cloned vs. referenced issue of the
  previous bullet point would be a problem with inclusion in
  ActiveRecord. It is the heart of the performance gain, howerever,
  and it is personally how I'd like associations in general to 
  behave.
    
<sup>\[1\]</sup> In kilobytes; based on [this post](http://laurelfan.com/2008/1/15/ruby-memory-usage).
