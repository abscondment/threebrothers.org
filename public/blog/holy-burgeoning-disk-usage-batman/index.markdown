---
date:  2008-02-01
title: Holy Burgeoning Disk Usage, Batman!
---
My server runs <a href="http://www.gentoo.org/">Gentoo Linux</a>.  Gentoo is a really neat distribution &mdash; it's main idea is to build <em>everything</em> in the system from source.  This sounds like a truly odious task, but Gentoo's engineers have built an incredible system called Portage to deal with the pain of compilation.  In fact, I don't think I've typed a single <b>make</b> command on this machine (yeah, nothing appears in bash_history).

Portage is invoked via the <b>emerge</b> command: this allows the user to synchronize a list of available packages and install or uninstall based on that list.  The system provides a really easy way to always run the most recent version of your software.  You get bug patches <em>the day</em> they're released.

From my point of view, Gentoo is a hobbyist's distribution: You tinker with it on a weekly (or even daily) basis, and there's almost always something new to compile.  You get to have a terminal sit on your screen with compilation gibberish flying by, making you feel very Matrix-esque.  And it is, in fact, a surprisingly stable system for all of the new code flying about.  This server was up for 160 days before <a href="http://threebrothers.org/brendan/blog/articles/2008/01/28/resurrected-living-in-a-lighthouse">someone kicked the plug out of the wall</a>, for example.

The plug kicking incident worried me for a day or two: "That server has a lot of things on it that I really don't want to lose; I should probably back it up; Oh, I hope the hard drive didn't die...", and so on.  So, I went to make backups today and find out that nearly all of the disk space is being used up.  A quick search for the offending directories finds them nice and bloated:

    brendan@bloom ~ $ for x in /*; do sudo du -ks $x; done | sort -g
    [snip]
    348200  /opt
    603992  /home
    918601  /proc
    3673612 /var
    8647420 /usr

Hmm... why is /usr sucking up <b>8.3G</b>?

    brendan@bloom ~ $ for x in /usr/*; do sudo du -ks $x; done | sort -g
    [snip]
    497928  /usr/share
    560600  /usr/lib
    2638336 /usr/portage
    4798196 /usr/src

What!?  It appears that I have <b>4.6G of kernel sources</b> just sitting there.  That observation leads me to believe that /usr/portage is full of unneeded sources, too.  Yuck!  Of course, I immediately found <a href="http://www.gentoo.org/doc/en/kernel-upgrade.xml#doc_chap9">an emerge command to fix my issue</a>.  Come on, though... I wish it would have at least told me that this scenario was going to happen.

So I just nuked a bunch of source code that was sitting around hogging space (actually, the machine is still deleting &mdash; it's running at load 6.8 because it's deleting gigs of data, compiling a new version of <a href="http://www.postgresql.org/">PostgreSQL</a>, and hosting this as I type).  Obviously, this server is a hobby machine and not a production environment.  Really, 
running any large application on a fleet of Gentoo servers would be a potential operations nightmare.  You'd have to figure out how to avoid this scenario completely, and the performance boost from custom compilation will most likely never ought weigh the added complexity of the infrastructure.

It's not out of the question: one could create a version-controlled 'master build image' and a way to push new images out to existing servers, and then create a testing environment to run all of your applications against the newly compiled system utilities.  You'd batch up a bunch of new patches against the base system, test them out, and deploy if the tests passed.  But this seems like an insane headache when you can achieve pretty much the same performance from a bunch of servers running a pre-compiled distribution.  Optimizing performance via custom compilation is basically a form of vertical scaling; while it might pay off at some level of scale, you should definitely scale horizontally first.

