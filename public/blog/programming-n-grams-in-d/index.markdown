---
date:  2007-01-02
title: Programming N-Grams in D
---
I'm looking into using the <a href="http://www.digitalmars.com/d/">D programming language</a> for part of my Capstone project this coming quarter.  It's really an attractive looking language, supposedly taking the speed of C and the object oriented structure of Java to a new level.

Part of my capstone project may involve an automatic classification of texts using a computational linguistics model known as the N-gram.  N-gram analysis involves counting all occurrences of ordered tuple of size N.  While a 1-gram is  a simple word frequency count, a 5-gram tells you how often each 5 word phrase occurs in a document.  A basic explanation of how N-grams can be used for classification can be found in <a href="http://citeseer.ist.psu.edu/68861.html">a paper by Cavnar & Trenkle</a>.

D enters into the scene because it purports to combine speed with syntactic (and structural) sugar.  Extracting all of the N-grams up to N=10 from 4,000 Project Gutenberg E-texts is an interesting problem.  Writing the program in Python or Ruby would alleviate many implementation headaches, but their relative inefficiency would make it nightmarishly slow.  Coding the program in C could prove to be another form of nightmare: there's nothing more frustrating than debugging layer upon layer of memory management problems.

A few features of D make me extremely excited to try it out:
<ul>
	<li><a href="http://en.wikipedia.org/wiki/Garbage_collection_%28computer_science%29">Garbage collection</a></li>
	<li><a href="http://en.wikipedia.org/wiki/Closure_%28computer_science%29">Dynamic closures</a></li>
	<li><a href="http://en.wikipedia.org/wiki/Array_slicing">Array slicing</a></li>
	<li><acronym title="Object Oriented Programming">OOP</acronym> goodies (<a href="http://en.wikipedia.org/wiki/Interface_%28computer_science%29">interfaces</a>, <a href="http://en.wikipedia.org/wiki/Inheritance_%28computer_science%29">inheritance</a>, <a href="http://en.wikipedia.org/wiki/Method_overloading">overloading</a>)</li>
	<li><a href="http://en.wikipedia.org/wiki/Programming_by_contract">Contract programming</a></li>
	<li><a href="http://en.wikipedia.org/wiki/Unit_testing">Unit testing</a></li>
</ul>
And those are compiler-level features!  No stumbling through JUnit or writing Ruby extensions here.  Hopefully, it'll live up to my expectations.
