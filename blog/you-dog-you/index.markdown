---
date:  2008-01-10
title: You Dog, You
---
I just updated this site's configuration to use <a href="http://mongrel.rubyforge.org/docs/lighttpd.html">Mongrel on Lighttpd</a>.  It's not really a recommended setup, but I'm not using any of the features that are reported as being problematic.

I haven't noticed a marked increase in speed over FCGI, but I do believe it's now able to withstand a larger pounding.  I'm planning on trying to hack together the Lua-based magnet caching that the above link describes, which will allow lighttpd to completely bypass the mongrels to serve cached Rails content.

This server is running Gentoo, and thus I have a love/hate relationship with it.  I mostly love it, but right now I can't figure out how to do what I want to do: <a href="http://google.com/search?q=install+ruby+1.9+on+gentoo">install Ruby 1.9 on Gentoo</a>.  It's been reported (both <a href="http://antoniocangiano.com/2007/11/28/holy-shmoly-ruby-19-smokes-python-away/">sensationally with little relevance</a> and <a href="http://antoniocangiano.com/2007/02/19/ruby-implementations-shootout-ruby-vs-yarv-vs-jruby-vs-gardens-point-ruby-net-vs-rubinius-vs-cardinal/">with relevant comparisons</a> &mdash; Ruby 1.9 is listed as 'yarv' in the second benchmark) that this new version is significantly faster than 1.8, so I'm excited to try it out in the wild.  Unfortunately, I haven't found any good instructions for installing it, and my Gentoo-foo is weak.  I could easily download the source, compile it, and symlink the binary... but I really don't want to clutter my server up with an intricate maze of symlinks that only I know about.  No, I'll wait until I can install 1.9 with Portage (which may be now... if you have insight let me know).
