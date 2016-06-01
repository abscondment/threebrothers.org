---
date:  2010-03-01
title: Memory and Ruby :symbols
---
Ruby provides a really flexible and sugary syntax. A lot can be expressed in one little snippet, and the same functionality can often be <a href='http://refactormycode.com/codes/2-ruby-simple-loop' rel='nofollow external'>rewritten in many different ways</a>. In this post, I'd like to focus on some potentially dangerous properties of one particular piece of Ruby: the <a href='http://ruby-doc.org/core/classes/Symbol.html' rel='nofollow external'>Symbol</a>.

First, compare these two lines:

    (1) {:foo  => 'bar', :qux  => 'quux'}
    (2) {'foo' => 'bar', 'qux' => 'quux'}

I'd say that Ruby developers default to (1) &ndash; at least, most Ruby code that I've worked with tends to favor that variant. This seems to be in part a matter of aesthetic taste, and a subtle way to differentiate between a map's keys and values. Sending a hash of symbolized keys to a method has become a fairly common way of implementing complex options &ndash; it's <a href='http://api.rubyonrails.org/classes/ActiveRecord/Base.html#M002263' rel='nofollow external'>prevalent in Rails</a>. Rails uses this construct so often that it adds <a href='http://api.rubyonrails.org/classes/ActiveSupport/CoreExtensions/Hash/Keys.html#M001190' rel='nofollow external'>extensions to the native `Hash`</a> object to facilitate turning their `String` keys into `Symbols` and *vice versa*.

## Symbols to the rescue!

There are some really common situations where (1) is the best option. A variation of <a href='http://glu.ttono.us/articles/2005/08/19/understanding-ruby-symbols' rel='external'>the canonical example</a> follows: Say you're creating thousands of hashes to represent a common JSON object &ndash; a temperature reading. They all have the same key structure, but the data differ.

    sea = {'lat' => 47.53, 'lon' => 122.30, 'temp' => 15.0}
    sf  = {'lat' => 37.79, 'lon' => 122.41, 'temp' => 25.0}
    
    puts sea.keys[0] == sf.keys[0] # true
    puts sea.keys[0].object_id     # 86288110
    puts sf.keys[0].object_id      # 86345290

So it's 15&deg;C in Seattle and 25&deg;C in San Francisco. Typical. What's more interesting is that although your keys are equal, they are two different `String` objects. With 1,000,000 such hashes, you're carrying around 3,000,000 strings that take up a lot more space than the `Float` entries.

Symbols solve this issue. At the C level of Ruby, each symbol maps to an unsigned integer &ndash; the <a href='http://en.wikipedia.org/wiki/Symbol_table' rel='nofollow external'>symbol table</a> has one entry per symbol, and the entries exist as long as the process lives.

## Wait, why is that still lying around?

Symbols are tiny and combine identity with equality, but **they're never garbage collected**. That's how the symbol table implementation works. So, replacing 3,000,000 Strings with 3 Symbols is a great improvement. But in a long-running process that does a lot of GC and uses random, unique keys, symbols can hurt.

To illustrate the problem, I grepped through the iLike codebase for unique symbols. I stored them as Strings only, read the current memory usage, and then converted them all to Symbols using `to_sym`. The isolated increase in memory usage was ~**1.2MB** &ndash; and this test can't even find symbols created programmatically!

Now, that figure represents &lt;1% of the memory used by a typical process of ours. But that consumption adds to Ruby's large low water mark for memory. If our application created symbols for arbitrary user input, we could easily choke a box into swapdeath. Incidentally, this is one reason why `HashWithIndifferentAccess` stores its keys internally as Strings &ndash; each Rails request creates a HWIA with all of the query parameters and GCs it later. Automatically converting query parameter names to symbols would create a vector for an easy <acronym title='Denial of Service'>DOS</acronym> attack.

## Guidelines

So, how should Symbols be used?

 * Common values that are used often/repeatedly for *identity* (i.e. our temperature hash keys) should be Symbols. They're all about identity.
 * Unique, high cardinality values or values that will be discarded should not be Symbols. They need to be garbage collected.

