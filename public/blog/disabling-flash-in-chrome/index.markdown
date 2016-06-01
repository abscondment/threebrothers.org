---
date:  2010-02-25
title: Disabling Flash in Chrome, and Other Tricks
---
I just learned that there is a handy switch one can pass while launching Chrome to bypass the plugin architecture:

    google-chrome --disable-plugins

Previously I had resorted to moving `libflashplayer.so` or removing read access from it, but this is a much more controlled method.

The are a ton of [other Chrome switches](http://www.google.com/codesearch/p?hl=en#h0RrPvyPu-c/chrome/common/chrome_switches.cc) that I only found by browsing the source &ndash; good thing it's available. Among them is `allow-file-access-from-files`, which would have come in handy yesterday.

