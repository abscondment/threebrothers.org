---
date:  2011-01-21
title: Experimenting with Mirah for Android
---
A while ago I wrote about [Closures in Duby](../closures-in-java-ruby-and-duby/). Duby is now called Mirah, and it's a promising way to write compiled code without the weight of Java syntax. I've been updating Urbanspoon's Android application, and I decided to use Mirah for portions our next release.

## Getting started

Mirah is available as a JRuby gem. Hopefully you use RVM to [manage your Rubies](http://rvm.beginrescueend.com/), because chances are good that you'll want to switch between them for various purposes.

Here's an install script that will probably be obsolete the second I finish writing it. Enjoy.

### Installing mirah

    $ rvm jruby
    $ gem install mirah

#### miranhdroid - optional install for new project creation

    $ rvm jruby
    $ cd ~/code && git clone https://github.com/jackowayed/mirahndroid.git
    $ cd mirahndroid && rake gem
    $ gem install pkg/mirahndroid-*.gem
    $ cd ..
    $ mirahndroid create -a NewProjectActivity -n NewProject -p new-project -k com.urbanspoon -t android-9

## Welcome to the Wild West

Now you can write Rubylike code that compiles to Java. Cool. There's really nothing different about *Android* development, but it does showcase Mirah's *raison d'être*. Alternate JVM languages that require a runtime are often too slow for writing real, interactive mobile applications. Compiled code is a must, and Mirah provides just that. But there are quite a few gotchas...

### Not quite Ruby, not quite Java

There are a handful of things from both of these worlds that are [missing or different](https://gist.github.com/704274). Familiarize yourself with that list; it'll come in handy.

### Mixed-language Source is Hard

Urbanspoon's application has a significant chunk of existing Java. It'd be a waste to rewrite it, since it already works well.

Building a project with mixed source is complicated. The current mirahc can't do anything with .java sources &mdash; it infers types from classfiles and can't resolve them from the sources. So if you have an existing class that you want to reference from Mirah, you need to be able to compile it before you compile the Mirah code. Your Java code is conceptually just another .jar for the Mirah code to use.

This places an unfortunate constraint on your application, however: your Java code can never explicitly refer to classes defined in Mirah. That'd result in a circular dependency.

Ideally, mirahc would be able to infer types from both .class and .java files. Then the build process would be easy: mirahc -j to output .java into the gen folder, and javac to compile everything at once. But I think this would require a rudimentary Java parser, and the "Java code can't see Mirah classes" constraint seems easier.

### Rough build tools

Android gives you a stock build.xml, but it'll need customization. The *mirahndroid* project will give you an Ant task like this:

    <target name="compile" depends="-resource-src, -aidl"
            description="Compiles project's .mirah files into .class files">
      <exec executable="mirahc" dir="src">
        <arg line="-c ${sdk.dir}/platforms/${target-version}/android.jar:gen/" />
        <arg value="-d" />
        <arg value="../bin/classes/" />
        <arg value="." />
      </exec>
    </target>
    
That's a fine start, but you'll need to customize it to compile the generated R.java class if you want to access your application's resources. To make my mixed Java/Mirah project work, I copied the "compile" task from `tools/ant/build.xml` in the Android SDK and inserted the mirahc exec call at the end.

### Return types in if statements

**Update** &ndash; this has been fixed in commit [7fa9c6294695a391dccd](https://github.com/mirah/mirah/commit/7fa9c6294695a391dccdd3364f01c5c2213959bf)

We're creating statically typed code. Mirah has some cool type inferencing going on, but your variables are typed nevertheless. Even things like if statements have return values, and you need to make sure they match up. You'll probably just start littering 'nil' around at the end of each branch:

    if owed > 100
      message = "You owe a lot of money."
      owed += 1
      nil
    else
      message = "All paid!"
      nil
    end

### Nested interfaces

You can't easily implement a nested interface. For example, Android's `GpsStatus.Listener` &mdash; [see this thread](http://groups.google.com/group/mirah/browse_thread/thread/a86cf47e5f65619f).

### Odd scoping

The block syntax is cool, but scoping of self and instance variables is incomplete.

    this = self
    grid.setOnItemClickListener do |parent, view, position, id|
      this.launch(int(id))
    end

It's super easy to add anonymous listeners with this syntax. But you need to make sure to create *local variables* to point to the values you'd like to acces inside the block. Inside "self", for example, refers to that anonymous class (you did read about [the cool blocks implementation](../closures-in-java-ruby-and-duby/), right? Likewise, instance variables don't exist inside the block. You need to pull them into the scope surrounding the block to access them inside the block.

## Bleeding Edge

Some of the problems I encountered were resolved by using a development snapshot of the Mirah gem. If the idea of using bleeding edge technology in a production application makes your blood pressure rise, this might not be for you... yet. As it matures, Mirah will be a more and more attractive alternative to java. I, for one, enjoy running off of unstable branches.

