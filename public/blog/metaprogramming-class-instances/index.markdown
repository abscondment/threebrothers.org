---
date:  2007-11-15
title: Metaprogramming Class Instances
---
Suppose you're working on a Rails project with the following setup:

    class Foo < ActiveRecord::Base
      belongs_to :bar
    end

    class Bar < ActiveRecord::Base
      has_many :foo
    end

Normally, if you wanted to load up a bunch of Foos and display their associated Bars, you'd do something like this:

    foos = Foo.find(:all, :include => [:bar])

In most cases, this is probably a fine way to do things; however, ActiveRecord doesn't always generate the best SQL, and it's quite likely that you'll want more control than 'include' allows.  At the minimum, you're going to get back a ton of duplicate Bar information in each row; depending on the result set size, this could be anything from negligible to catastrophic.Assuming we want to access all of the Bars for each Foo, we can also rule out allowing Rails to lazily load the Bars as they're needed.  That would result in a "select * from bars where id = XXX" for each Bar in each Foo.  Again, we wind up loading each Bar more times than is needed.  Instead, we can create a method to populate the Foos with their Bars.

    module Populate
      module Foos
        def self.populate_bars(foos)
          return if foos.blank?

          bar_map = {}
          bar_ids = foos.map {|foo| foo.bar_id}.uniq

          bars = Bar.find(:all, :conditions => ['id in (?)', bar_ids])
          bars.each {|bar| bar_map[bar.id] = bar}

          foos.each do |foo|
            if bar_map.has_key?(foo.bar_id)
              def foo.bar; @bar; end
              def foo.bar=(v); @bar=v; end
              foo.bar = bar_map[foo.bar_id]
            end
          end
        end
      end
    end

One would use this method as follows:

    foos = Foo.find(:all)
    Populate::Foos::populate_bars(foos)

Naturally, we don't <em>need</em> to use ActiveRecord's "find" method inside of our populate call; if the schema is sufficiently complex, we could pull things in with pure SQL.  In any case, we'll only load each Bar <em>once</em>, which is far better than either of the previously mentioned options.

Depending on your choice of database, there may be limitations on the number of arguments you can pass into the "id IN (?)" constraint of the WHERE clause.  It would be trivial to add a block-based batching method that would cut the ids into manageable batches.  If you have a large number of Foos and a large number of Bars, pulling them up in bulk (as this method does) could reduce the amount of time spent waiting for the database.

It's also important to note that you won't be able to change which Bar a given Foo belongs to after populating the Bars.  Examine these two lines:

    def foo.bar; @bar; end
    def foo.bar=(v); @bar=v; end

These two lines dynamically alter the given instance of Foo, replacing the default methods that ActiveRecord creates for association loading and alteration.  Once we've done that, we can no longer change Bar object via the normal techniques.  If we wanted to, we could always do something like this:

    foo.bar_id = other_bar.id
    foo.save

Generally speaking, however, the bar= association method won't be efficient for changing the Bars on a bunch of Foos.  A bulk update would be better suited for that.  Plus, it wouldn't be very difficult to meta-program ourselves out of this predicament; that can be an exercise for the reader.

