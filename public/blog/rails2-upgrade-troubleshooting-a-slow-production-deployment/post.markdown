*This is part of a series on [Rails 2 Upgrade Turbulence](http://threebrothers.org/brendan/blog/rails2-upgrade-turbulence).*

Staging and testing a big release is important, but there are some factors that
can only be obsereved in the true production environment. Sure, I can replay the
most interesting 80% of a yesterday's traffic against a test server without it
failing &ndash; but I'm only *one user* making *sequential* requests. This
completely dodges the question of how the new code will work at scale.

The [ActiveRecord changes around association loading in Rails 2](http://threebrothers.org/brendan/blog/rails2-upgrade-activerecord-woes/)
made me particularly curious about the production behavior of Urbanspoon. We had
recently added two identical servers to our production rotation, so I took over
one and did a test deploy of the Rails 2 branch.

Initial traffic (balanced to about 3% of our load) looked good &ndash; snappy
response times and no exceptions. But when I bumped it up to take a full share,
performance was substandard. The Rails 2 server was running at *nearly twice the load*
of its counterpart, and was taking *on average twice as much time* to serve
requests. Yech. We loaded up Rails 1, and performance improved... although
this test server was still slower than the control. What a quandary.

## Monitoring works.

Since we run munin, we have easy access to historical performance. My debugging
tools/steps were:

 1. top - get a quick, side-by-side eyeball of CPU, load, iowait, memory usage.
 2. munin
   * Rails times: total, views, db
     * total time and db time in Rails 2 was twice that in Rails 1
     * Raised the question of whether these are even comparable across
       different major Rails revisions.
   * Load/Memory graphs &ndash; same story as top.
   * Interrupt graphs
     * Wow &ndash; lots of "Rescheduling interrupts" on the slow server.
 3. cat /proc/cpuinfo, /proc/meminfo, /proc/interrupts, /proc/ioports (AHCI on
    one, but not the other?), ifconfig, etc.
   * Are these machines actually the same? Lots of subtle differences.

These were all useful, but they didn't give me a definitive answer. The machines
looked different, but the old code ran significantly faster than the new code.
Yet all reports easily reached by Google lead me to believe Rails 2 might even
give us a speed *boost*. So was it really slower, was there a hardware issue, or
what?

## Debugging works.

At this point, I switched into the :debug log-level to see if I could spot any
subtle issues. Was ActiveRecord sending a flood of extra association loads that
we should force into a join? Was memcache getting hit at all? Were our DB times
slow due to bad network performance?

Very quickly, I noticed something suspicious: our memcache keys looked like
absolute urls. Ah, great. Looks like we were being bit yet again by the new
[Rails 2 named routes](http://threebrothers.org/brendan/blog/rails2-upgrade-general-cleanup/) &ndash; nameley,
that *_url routes now produce an absoluter URL instead of a relative one. In
addition to this, Rails 2 changed the [fragment\_cache\_key method to include a
prefix](http://github.com/rails/rails/blob/v2.3.10/actionpack/lib/action_controller/caching/fragments.rb#L33) &ndash; so no matter what, fragment caching in Rails 2
would have totally new keys.

So on our most popular pages, we were using a completely different keyspace.
All of the Rails 1 servers were using an identical keyspace, and the one Rails 2
was in its own. This memcache filled quickly, but the new server's keys got
ejected at a *much* higher rate. Its cache misses were through the roof, and
therefore so were its load and response times (although, isn't it nice when
averaging a 120ms response time is "through the roof"?).

Neat. But fixing the keys didn't bring performance up to par with the other
server. We noticed two things:

 * Those pesky "Rescheduling interrupts" were still there &ndash; at three
   orders of maginitude more per second from the slow server to the other.
 * <abbr title='Advanced Host Controller Interface'>AHCI</abbr> was disabled
   on the slow server.

Even after enabling AHCI and doing an OS reload, the "identical" servers were
none too identical. So we took a leap of faith and  deployed Rails 2 to the
other, faster one, and performance was as expected. We're still working with
our hosting company to figure out what's wrong with the slow machine.
