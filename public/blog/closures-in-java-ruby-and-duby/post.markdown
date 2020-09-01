On Wednesday, I noticed Phil Hagelberg's [Android-Duby app playground](http://github.com/technomancy/Garrett "Garret: A playground for Android Duby development"). This piqued my interest for several reasons, but a primary one is the work Phil Bogle is doing to port [iLike's <em>Local Concerts</em> app](http://www.ilike.com/mobile/concerts) to the Android platform. Many people have found Java's syntax to be too rigid and verbose, and this makes [Duby](http://github.com/headius/duby)'s promise to convert Ruby-like syntax to JVM bytecode particularly enticing.

<div class="rightImage"><img src="//threebrothers.org/brendan/blog/closures-in-java-ruby-and-duby/badges.png" alt="Bandit from 'The Treasure of the Sierra Madre'" /><br/><em>Closures? We don't need no stinkin' closures!</em></div>
Having only taken a cursory glance at the concept, we both agreed that Duby would be most useful if it supported Ruby's block syntax. Phil (Bogle) was expressing frustration with Java's lame substitute for closures: the anonymous class. Not only is the construct syntactically and conceptually verbose, but the restriction of scoped access to only final variables is [vastly inferior to true closures](http://www.cuberick.com/2009/08/anonymous-inner-classes-poor-mans.html).

Let's begin with some definitions. For our purposes, closure is *not* the emotional freedom you achieve after letting go of something big and devastating. Rather, it's a function that is a *first-class object* &mdash; this means it can be passed and stored as a standard variable &mdash; that is bound to variables in a certain scope. Both Java and Ruby achieve passing by instantiating Objects for new closures.

Examine this contrived example:

    public void demo() {
        Runnable r = printClosure("Are we functional yet?");
        r.run();
    }

    public Runnable printClosure(String text) {
        return new Runnable() {
            public void run() {
                System.out.println(text);
            }
        };
    }

We create the closure, return it, and later call it. Although this looks reasonable, the code actually fails to compile.

    Closure.java:14: local variable text is accessed from within inner class; needs to be declared final
                    System.out.println(text);
                                       ^
    1 error

To make this work as desired, we need to copy `text` into a final variable: `final String fText = text;`. As a side effect, the Java "closure" won't be able to modify variables it refers to or see modifications made to them. But why? The answer lies in the particulars of Java scoping. This instance of `Runnable` is an anonymous inner class &mdash; it has its own unique scope and limited access to the scopes of other classes. The `text` variable disappears once the `printClosure` function returns, so our `Runnable` can't hang on to it. It also can't really *see* it &mdash; making it `final` makes it OK for the value to be read after that scope is being eaten by GC.

But this severely limits the usefulness of passing the function. The following Ruby can't be implemented with Java's anonymous inner class:

    #!/usr/bin/env ruby

    def make_block
      a = 1
      b = 2
      block = lambda { |x| x + b }
      b = 999 # block sees this change
      return block
    end

    def run_block(&block)
      puts "first with 1: #{yield 1}"
      eval "b = a", block.binding # block still sees a
      puts "again with 1: #{yield 1}"
    end

    run_block(&make_block)

    # Output:
    # first with 1: 1000
    # again with 1: 2

<div class="rightImage"><img src="//threebrothers.org/brendan/blog/closures-in-java-ruby-and-duby/scope.png" alt="Credit: http://www.flickr.com/photos/doviende/95495500/" title="Credit: http://www.flickr.com/photos/doviende/95495500/" /><br/><em>That's not a scope. <b>This</b> is a scope!</em></div>
See, Ruby's blocks are closures. They are [given the local scope](http://onestepback.org/index.cgi/Tech/Ruby/RubyBindings.rdoc) in which they're created. So `block` can always see and change `a` and `b`, and there's only ever one instance of `a` and `b`. No duplication. Full access. This let's us create some truly [awesome control structures and higher-order functions](http://weblog.raganwald.com/2007/01/closures-and-higher-order-functions.html) that are unimaginable in Java. Ruby does this by always providing a `Binding` object for the current scope. A closure will copy the current binding and add new local variables to it, leaving the preexisting variables accessible.

A natural question now follows: "Can we do real closures in any JVM language?" Well, actually, yeah. [Clojure does it](http://clojure.org/functional_programming#toc2), and [so does Scala](http://www.scala-lang.org/node/4960). That question was something of a straw man &mdash; a little bit of thought will lead us to conclude that Java's syntax is to blame rather than the machine itself. And as luck would have it, Duby does it too.

However, Duby has one interesting constraint: its compiler can optionally produce either `.class` or `.java` files. This places us back within the restrictive confines of Java syntax! Fortunately, the Duby folk have come up with a really neat hack to make the closures work.

The compiler does the following:

* Creates an anonymous inner class to pass around as the closure.
* Creates a *second* inner class to represent variables shared between the local scope and the closure.
* Performs all operations (whether from the closure or in the local scope) on shared variables by accessing them as members of the binding object.

The binding object gets to live beyond the life of the local scope since the closure holds on to its reference. It provides public access to its members, so either the local scope or the closure can modify these free variables. Unfortunately, the syntax for writing this is so verbose and fragile that it completely destroys its viability &mdash; unless a compiler like Duby's is producing the code.

For more details, check out [the DubyBlocks Wiki page](http://kenai.com/projects/duby/pages/DubyBlocks).

<br style="clear:both;"/>
