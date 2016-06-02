---
date:  2008-05-07
title: Firefox 2 to 3: A Cautionary Tale
---
I've been using <a href="http://www.mozilla.com/en-US/firefox/all-beta.html">Firefox Beta 3</a> whenever I can, and I've really enjoyed it.  It has <em>huge</em> gains over Firefox 2 and Internet Explorer in the area of memory consumption, and that makes me really happy.  Firefox 2.x was fun and all, but it didn't really shine over the 1.x series in the ways that I hoped it would.  Combine that lack-of-notable-improvement with its piggish memory usage, and one could be questioning one's faith in Mozilla rather often.  I kept thinking to myself, "Man, I hope they work on this in the next release."

So, when the Beta came out and was being lauded for its memory leak improvements, I jumped at it.  And man, was it better!  But of course, the nifty extensions that I've come to rely on at work (Firebug in particular) haven't yet been released for the 3.x branch.  So (on my home laptop, at least), I find myself switching between the old and new rather often.

The caution: <b>make sure to keep separate .mozilla directories for your different versions</b>!

After a while of switching back and forth, I found <em>both</em> copies to be horribly slow.  Using any form elements, clicking any links, and even attempting to type a new URL into the address bar caused Firefox to eat CPU cycles like nobody's business.  So, while I was really pleased that it used less memory, my sloppy switching techniques turned it into an unusable mess.  By deleting everything and storing separate directories (.mozilla2 and .mozilla3, with the active one symlinked as .mozilla), I seem to have resolved the issue for both versions.  Whew!
