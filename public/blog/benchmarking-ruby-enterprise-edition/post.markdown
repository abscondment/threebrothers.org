As part of a perpetual quest to make things run faster, I benchmarked various Ruby configurations using the Urbanspoon codebase. We have a smoke test that hits our key pages regularly to ensure things are running well, and I decided to use this for speed comparison as well. My methodology was simple.

1. Run a local staging server with MySQL & memcache. Run smoke against it a lot to get the caches really hot &ndash; we want to test the variations in *Ruby*, not in other layers.
2. For each test configuration, start Unicorn and run smoke against that server 10 times <sup>\[1\]</sup>. This basically tests how quickly Rails can load a few simple objects from the database and squish them together with a pre-rendered page from memcache.
3. Repeat #2, but clear out memcache<sup>\[2\]</sup> before the start of each run of the smoke test. This tests a lot more of the application's internals, since it makes each test run rebuild the important pages and repopulate memcache. The MySQL cache stays hot throughout both tests and it's not anywhere near breaking a sweat.
4. Now that we have 2 views of speed recorded 10 times each for all of the configurations, we can crunch some numbers. Throw out the best and worst times, take the average, and learn.

I benchmarked four <abbr title="Ruby Enterprise Edition">REE</abbr> configs, and I used the standard MRI 1.8.7 version as a baseline. The results were gratifying.

<fieldset>
  <legend>Five Pairs of Ruby Benchmarks</legend>
  <table style="width:100%;">
    <tr>
      <th style="width:40%;">Configuration</th>
      <th colspan="2">Cache hot</th>
      <th colspan="2">Cache cold</th>
    </tr>
    <tr>
      <td>MRI 1.8.7</td>
      <td>10.526875</td>
      <td>0.0%</td>
      <td>33.77225</td>
      <td>0.0%</td>
    </tr>
    <tr>
      <td>REE (default)</td>
      <td>7.90675</td>
      <td>-24.89%</td>
      <td>25.43275</td>
      <td>-24.69%</td>
    </tr>
    <tr>
      <td>REE (tuned GC<sup>[3]</sup>)</td>
      <td>6.972</td>
      <td>-33.76%</td>
      <td>22.948875</td>
      <td>-32.05%</td>
    </tr>
    <tr>
      <td>REE (copy-on-write<sup>[4]</sup>)</td>
      <td>9.0375</td>
      <td>-14.14%</td>
      <td>26.539625</td>
      <td>-21.41%</td>
    </tr>
    <tr>
      <td>REE (tuned GC, copy-on-write)</td>
      <td>7.117625</td>
      <td>-32.4%</td>
      <td>23.1595</td>
      <td>-31.4%</td>
    </tr>
  </table>
  <p style="margin:0.5em 0 0 0;padding;0;font-size:0.8em;"><em>Figures shown are total seconds elapsed and difference relative to MRI 1.8.7</em></p>
</fieldset>

Hey, cool! There's some validation, all right. Garbage collection has a huge impact on the performance of web applications, and proper tuning can mean a world of difference. REE does better out of the box, and really flies with a little tuning. Copy-on-write, which reduces overall memory usage, definitely has some performance penalties. But when GC flags are set it really doesn't degrade things much at all. This could be a huge win.

I'd love to test some other implementations when I get the time, but for now we're going to slowly migrate things to REE.

* <sup>\[1\]</sup> I did that with `for s in {1..10}; do (time ../bin/smoke) 2>&1 | grep '^real'; done | cut -f 2`
* <sup>\[2\]</sup> `echo -ne 'flush_all\r\nquit\r\n' | nc localhost 11211` will do the trick.
* <sup>\[3\]</sup> I used some settings [attributed to Twitter](http://www.rubyenterpriseedition.com/documentation.html#_garbage_collector_performance_tuning).
* <sup>\[4\]</sup> This is supposed to reduce a [Rails application's memory footprint by 33%](http://www.rubyenterpriseedition.com/documentation.html#_overview_of_ruby_enterprise_edition_ree). It's obviously a little slower, but appears to be well worth it.
