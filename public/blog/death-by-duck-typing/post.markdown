<img src="//threebrothers.org/brendan/blog/files/duckt.gif" alt="Duckbot" style="border:0 0 0 1em;float:right;" />

Ruby is all about the duck-typing.  Most of the time, I am too.  But sometimes, it can lead to some very confusing and very nasty issues.

Suppose you get a variable, <b>h</b>, from someone's cool helper function, and with it you want to build up a hash of Widgets.  You have millions and billions of Widgets in your database, but you're only dealing with the most recently added ones.  So you do something like this:

    h = get_my_h_now()
    # Get the 50 widgets with the highest ids and stick them into h
    Widget.find(:all, :limit => 50, :order => 'id DESC').map {
      |w| h[w.id] = w
    }

Pretty innocuous, right?  I mean, if the code works without errors, it's all good... right?  Right?

What if the cool helper function you're using doesn't do quite what you expect it to do?  Let's say you're expecting a `Hash`, but it gives you an `Array`.  Aw, buckets!  The joy of duck-typing: Your code will still work.  The curse of duck-typing: *Your code will still work*.  That's right &mdash; treat `h` as a black box, and (when keying off of your model's id) the outputs are the same.  It quacks just fine... so what's the problem? What do you suppose the following code outputs?  Oh, and please: don't run this snippet in irb; use the actual ruby interpreter or you'll never finish reading this article.

    widget = {
      :id => 123456789,
      :type => 'Really cool',
      :price => 999.99
    }
    id = widget[:id]
    h = []
    m = `ps -o rss= -p #{Process.pid}`.to_i
    puts "Using #{m}kb"
    h[id] = widget
    puts "Memory costs $#{h[id][:price]} per what???"
    m = `ps -o rss= -p #{Process.pid}`.to_i
    puts "Using #{m}kb"

(hat tip to Laurel Fan for the succinct <a href="http://laurelfan.com/2008/1/15/ruby-memory-usage" rel="external">ruby memory usage</a> syntax)

Surprised by the results?

    Using 1632kb
    Memory costs $999.99 per what???
    Using 483960kb

Yikes!  How did storing one little Widget suck up more than 470 megabytes of RAM?  The answer is all in the value of <b>id</b> and the nature of Ruby's arrays.  Ruby offers many convenient-yet-dangerous pieces of functionality (duck-typing, for one).  `Array` has a particular piece of dangerous convenience: dynamic allocation.  You can address positions on an `Array` that are larger than its current size, and the `Array` will dynamically resize itself to accommodate.  This is only dangerous because Ruby's `Array`s are not sparse; that is to say, when you address position 1,000,000 on a freshly created `Array`, Ruby has to allocate and store 1,000,000 nils and all of the pointer and class overhead associated with those nils.

So when you take a widget with id 123,456,789 and attempt to store it, using its id as the position... whew!  Ruby definitely has its work cut out for it, since you'll get over its <a href="http://viewsourcecode.org/why/hacking/theFullyUpturnedBin.html" rel="external">initial 8-megabyte heap</a> very quickly.  If you do this sort of thing in Rails and you have many requests processing at the same time, your servers will be in swap death pretty quickly.  Chances are high that you won't catch an issue like this when using a development database with low-id Models, since you'll be addressing much lower positions.

To be sure, duck-typing isn't the only perpetrator in this example: `Array` can take a good share of the blame, too.  However, we never would have got into this situation if it were impossible to attempt to address an `Array` when intending to address a `Hash`.  I still enjoy the looseness of Ruby, and (at this point) wouldn't trade it for the extra security of strict typing &mdash; it's just important to make sure that the quack you produce is the one which you intended.
