---
date:  2010-06-08
title: Cleaning up with Some Shell Commands
---
Today, I encountered an interesting problem when syncing my music library
between two different computers. Whenever I buy a CD (and yes, I still
buy CDs on occasion &mdash; albeit ones that are used or heavily
discounted), I rip it into [FLAC](http://flac.sourceforge.net/). But
sometimes, I'll have ripped an MP3 version of the same album on a
different computer. Merging the differing libraries fills my main
music repository with FLAC and MP3 versions of the same songs, which
is not exactly what I want. I'd much rather throw away the lower
bitrate files when a lossless one exits.

My solution is for the general form of "given a directory full of
files matching pattern X, delete files matching pattern Y", although
it will require parameter tweaking to be applied outside of the
context of my music library.

    find . -name '*.flac' | cut -d"/" -f 1-3 | uniq | while read line; do
      echo rm -f "$line/"*.mp3
    done

I'll dissect how it works:

 * <b>find . -name '*.flac'</b>: Gets the path for all flac files under this root.
 * <b>cut -d"/" -f 1-3</b>: Removes the actual filename. My paths are of the form "./Artist/Album/Track.extension", so I cut out everything after the second "/".
 * <b>uniq</b>: Ensure that each album directory is only listed once.
 * <b>while read line; do [...] done</b>: Grabs each line of input and makes it available inside the loop as the `$line` variable.

The inside of the loop performs a simple `rm` &ndash; actually, the
posted line only *echoes* the command, which is much better for
testing. To adapt this for other purposes, tweak the file matching
lines and the `cut` line. Test first with `ls` or `echo`. Don't
accidentally delete your data.



