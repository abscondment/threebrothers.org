---
date:  2010-10-21
title: ActiveRecord woes
---
*This is part of a series on [Rails 2 Upgrade Turbulence](http://threebrothers.org/brendan/blog/rails2-upgrade-turbulence).*

ActiveRecord associations have changed. There are some gotchas, at least compared to the Rails 1.1.6 frame of mind.

## Join v. Queries

Instead of forcing a join against the tables for every incuded association, ActiveRecord is now smart enough to split things into separate, on-index loads of each model. It then slaps the correct assocations back together. If separate loading is not possible, it can fall back on the join model.

### Broken SQL

The nature of programmatically generating SQL is that, well, things break. Specifically, if you find with both `:include` and `:joins` statements, you'll be in for a rude awakening. Whether single or multiple, every query will include the specified `:joins`. If your application expected a single, joined query (as with Rails 1.x), and you now get multiple, this will break.

You can also use `:include` and have `:conditions` or `:order` statements with unqualified column names. These also get applied to each of the queries, but since the columns don't exist in every table we're querying, things break. If you qualify the column names, ActiveRecord is smart enough to perform the join for you instead of executing separate queries.

## Associations

As I hinted in code when writing about [Bulk-loading associations with ActiveRecord](http://threebrothers.org/brendan/blog/bulk-loading-associations-with-active-record/), you need to be careful when using normal Array operators on collection-like associations. You can easily add to an association without expecting an insert.

E.g., `Restaurant.find(:first).cuisines << Cuisine.find(:first)` now generates an insert statement that establishes that relation instead of simply pushing the Cuisine object into an array.

To manipulate the collection directly without doing anything in the database, you must use `association.target`:

    Restaurant.find(:first).cuisines.target << Cuisine.find(:first)

