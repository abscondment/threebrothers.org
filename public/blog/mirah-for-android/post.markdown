A while ago I wrote about [Closures in Duby](../closures-in-java-ruby-and-duby/). Duby is now called Mirah, and it's a promising way to write compiled code without the weight of Java syntax. I've been developing [Urbanspoon's Android application](http://www.urbanspoon.com/android), and I decided to use Mirah for portions our next release.

# Getting started

Mirah is available as a JRuby gem. Hopefully you use RVM to [manage your Rubies](http://rvm.beginrescueend.com/), because chances are good that you'll want to switch things around.

# Mixed-source projects

Urbanspoon's application has a significant chunk of existing Java. It'd be a waste to rewrite it, since it already functions.

Building a project with mixed source is complicated. The current mirahc can't do anything with .java sources -- it infers types from classfiles and can't resolve them from the sources. So if you have an existing class that you want to reference from Mirah, you need to be able to compile it before you compile the Mirah code. Your Java code is conceptually just another .jar for the Mirah code to use.

This places an unfortunate constraint on your application, however: your Java code can never explicitly refer to classes defined in Mirah. That'd result in a circular dependency.

Ideally, mirahc would be able to infer types from both .class and .java files. Then the build process would be easy: mirahc -j to output .java into the gen folder, and javac to compile everything at once. But I think this would require a rudimentary Java parser, and the "Java code can't see Mirah classes" constraint seems easier.

# Gotchas

* if/else return types
* class variables
* nested interfaces
* self, instance variables & blocks
