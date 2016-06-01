---
date:  2011-02-27
title: Using memcached -k to prevent paging
---
Memcached is a powerful brute. Since it's basically just a giant in-memory hash
map, you can safely run it on just about any machine that has spare memory. But
be sure to know the sort of memory profile your machine has.

If something causes memcached to go to swap, performance degrades significantly. 
Paging can block all queries to the given server, which can in turn block all
rendering for every page of your site. The performance degradation I observed
was on the order of 30+ seconds, so this is enough for any number of layers in
your application stack to time out inscrutably.

Fortunately, memcached provides the `-k` switch to indicate that its memory should
be locked from paging. You'll wind up running like this:

    brendan@ishmael:~$ sudo memcached -m 1024 -p 11211 -u memcache -l 127.0.0.1 -k
    warning: -k invalid, mlockall() failed: Cannot allocate memory

Oh, wait. Cannot allocate memory?

    brendan@ishmael:~$ ulimit -l
    64

Ah, I see. We're limited to 64k of locked memory by default. Fortunately, this
can be changed with per-user granularity by adding some lines to
/etc/security/limits.conf:

    root            -       memlock         1048576

That takes the root user's limit up quite a bit. The memcached help output
indicates that you should up the limit for the user that *launches* the program,
not for the user that memcached eventually runs under.

Of course, even better than all this would be organizing the system architecture
in such a way that the memcached machine never needs to swap.

