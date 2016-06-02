---
date:  2008-01-18
title: MapReduce: A major step backwards (for house painters)
---
I've been subscribed to <a href="http://www.databasecolumn.com" rel="nofollow">The Database Column</a> blog for a while now.  Their initial posts were intriguing, highlighting the <a href="http://www.databasecolumn.com/2007/09/data-compression.html" rel="nofollow">efficiency gains available to column store databases</a> and the impact of <a href="http://www.databasecolumn.com/2007/10/database-parallelism-choices.html" rel="nofollow">database architecture on scalability</a>.  While these posts were very interesting, their recent articles have contained a traces of a new element: product marketing.  They appear to be very interested in selling their column store database to people; while that's fine and good, it's not what I want to read about &mdash; especially when it appears (to me) that their intent has strayed from the purely technical description of solutions to a "this is why everything else is inferior to our product" pitch.

Enter the latest article: <a href="http://www.databasecolumn.com/2008/01/mapreduce-a-major-step-back.html" rel="nofollow">MapReduce: A major step backwards</a>.

They make five rather disruptive and disingenuous (or misinformed) claims:
<blockquote>
  <ol>
    <li>MapReduce is a step backwards in database access</li>
    <li>MapReduce is a poor implementation</li>
    <li>MapReduce is not novel</li>
    <li>MapReduce is missing features</li>
    <li>MapReduce is incompatible with the DBMS tools</li>
</ol>
</blockquote>

You can read the complete article if you want to know the meat of their arguments.  I think their points are wrong or irrelevant on all counts, however.

All of their errors stem from one of the following assumptions:

<ul>
  <li>Believing that databases can match the scalability of MapReduce for computation (which they can't &mdash; if they could, Google would be building their inverted index within a database process, which is a laughable idea).<br /><br /></li>
  <li>Asserting that MapReduce is used as a tool for <em>data access</em>.  That's a ridiculous and stupid idea, <b>akin to condemning paint brushes for their bad database architecture and lack of schemas</b>.  MapReduce is only transformational (and therefore it doesn't need indexing or other database-y things).<br /><br /></li>
  <li>That decades of database research necessitate their newer ideas about parallelism will scale better than old-school functional programming.<br /><br /></li>
  <li>That Google must not exist, or is covering up the truth about its infrastructure (Which is obviously a giant column-store database, since that's the only thing that's good for anything. I mean, actually building a giant system with MapReduce is like programming Assembly, right?).<br /><br /></li>
  <li>That <a href="http://www2.sqlonrails.org/">SQL On Rails</a> must be the best open source project in the world, since it puts the database back on its throne.</li>
</ul>

It irks me to see such a hasty condemnation of an obviously successful technology.  While column store databases doubtless have many advantages over other forms of databases, their creators (this company specifically) ought to make their limitations perfectly clear.  Such databases are as yet unproven, and seems like a nasty attempt at self-aggrandizing by smearing the competition.

If they assert that their database is a better massively parallel computation system than MapReduce, they ought to do a complete analysis of <em>their own system</em> compared to a well-designed MapReduce system.  Such an analysis would need to be on a domain problem that is already dominated by MapReduce &mdash; building an inverted index for a search engine, for example.

As it is now, this article makes me think of a kid on a tricycle declaring that his neighbor's Lamborghini is slow because his tricycle has three wheels.  Whiskey Tango Foxtrot, kid?
