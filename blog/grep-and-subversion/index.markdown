---
date:  2008-05-16
title: Grep and Subversion
---
A while ago, <a href="http://twitter.com/grantr">Grant</a> supplied a nice shell hack for recursively grepping through a subversion enlistment while ignoring the .svn directory contents.  This was the solution to a <a href="http://twitter.com/laurelfan/statuses/774697353">thread</a> about <a href="http://twitter.com/abscondment/statuses/774699294">counting</a> the number of occurrences of a given word (HACK, in this case) within your project; <a href="http://twitter.com/grantr/statuses/774701774">the final response</a> did this rather nicely.

I've found myself wanting to needing this more and more: searching for all instances in which a certain method is called, for all uses of a particular phrase, for all uses of a <acronym title="Cascading StyleSheets">CSS</acronym> class, <em>et cetera</em>.  And <a href="http://www.hhhh.org/wiml/virtues.html">like a good programmer</a>, I have consistent trouble actually typing out all of those commands and flags.  Whether it's my memory or merely my lazy fingers matters not; I needed this to be encapsulated as a shell script that I could call just like grep.

Here's my condensed version.  I know some distributions include an 'rgrep' by default; since that name was available on both of mine, I simply took it.  Note that I appended the <em>.sh</em> extension so that I could easily force my web server to spit it out as text/plain &mdash; in my actual environment, it's just <em>rgrep</em>, and is stuck into a PATH-friendly directory for easy use.


<a href="http://threebrothers.org/brendan/blog/files/rgrep.sh">rgrep.sh</a>

Usage: rgrep &lt;pattern&gt; &lt;directory&gt; &lt;grep arguments&gt;
