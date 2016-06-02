---
date:  2008-03-18
title: Cool (and practical) idea: Consistent Hashing
---
The last few days have thrown a <a href="http://highscalability.com/paper-consistent-hashing-and-random-trees-distributed-caching-protocols-relieving-hot-spots-world-wi">deluge of posts about applications of consistent hashing</a> into my path. Enough so that I broke down to read <a href="http://citeseer.ist.psu.edu/karger97consistent.html">one</a>, then <a href="http://www.lexemetech.com/2007/11/consistent-hashing.html">another</a>, and then a third.

I liked the way that third article read the most, so I decided to link to it a little more prominently:
read on to discover <a href="http://www.spiteful.com/2008/03/17/programmers-toolbox-part-3-consistent-hashing/">what consistent hashing is and why your caching layer should use it</a>.  Some choice bits:

<blockquote><p><em>Let's say you're a hot startup and your database is starting to slow down. You decide to cache some results so that you can render web pages more quickly.  [You might] end up using what is known as the na&iuml;ve solution: put your N server IPs in an array and pick one using key % N.<br/>[...]<br/>[As] soon as you add a server and change N, most of your cache will become invalid. Your databases will wail and gnash their teeth as practically everything has to be pulled out of the DB and stuck back into the cache. If you've got a popular site, what this really means is that someone is going to have to wait until 3am to add servers because that is the only time you can handle having a busted cache.</em></p><p>And...</p><p><em>If you are building a big system, you really need to consider what happens when machines fail. If the answer is "we crush the databases," congratulations: you will get to observe a cascading failure. I love this stuff, so hearing about cascading failures makes me smile. But it won't have the same effect on your users.</em></p></blockquote>

