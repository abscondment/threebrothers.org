---
date:  2008-05-15
title: A modern-day seekdir() bug that's older than me
---
Take a gander at <a href="http://www.vnode.ch/fixing_seekdir">Fixing seekdir()</a>, an account of quashing a bug in the <acronym title="Berkley Software Distribution">BSD</acronym> directory libraries.  This is a very interesting piece of UNIX history, and probably still exists in the most recent versions of Apple's OSX.

My favorite part?

    =========================== 4.1 c.1 =======================================
    /* Copyright (c) 1982 Regents of the University of California */

That's right &mdash; this bug has been lurking <em>since 1982</em>.

