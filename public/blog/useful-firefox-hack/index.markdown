---
date:  2007-02-24
title: Useful Firefox Hack
---
I've been tripped up by Firefox's vertical scrollbar more than once, and each time for the same reason.  I always seem to notice this problem when I'm concurrently having trouble making a page layout line up correctly.  One page will have enough contents for a text overflow, causing the vertical scrollbar to appear; click a link on that page, and a page with fewer words makes the scrollbar disappear.

Of course, I'm never actually <em>looking</em> at the scrollbar when this happens&mdash;it's definitely in the periphery.  I'll be staring at the border of a large element in the page, trying to figure out <em>why in tarnation</em> it jumps 12-or-so-pixels to the right after I click a link.  Five minutes later, I'll realize that I've actually fixed all of the layout bugs in the page, and I'm simply being fooled by the magically disappearing scrollbar.

I figured there would be an `about:config` setting to change this, but I could find nothing on Google.  Finally, I found <a href="http://ddhr.org/2006/01/19/firefox-scroll-bar/">this tip</a>, indicating that a simple change to Firefox's `userContent.css` could do exactly what I wanted: make the stupid scrollbar appear all the time.

Here's the snippet, which should have been obvious to me as a wanna-be <acronym title="Cascading Style Sheets">CSS</acronym> buff:

    html {overflow-y: scroll;}

The default value of this property is `auto` This causes a scrollbar to appear only when it is required to.  Overriding this default at the `&lt;html&gt;` level makes every page have an implicit vertical scrollbar.  Why this isn't the default, I don't know... but I'm glad to have figured out how to fix it.


