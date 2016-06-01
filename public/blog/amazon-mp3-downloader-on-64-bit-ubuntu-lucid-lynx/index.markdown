---
date:  2010-06-04
title: Amazon MP3 Downloader on 64-bit Ubuntu (Lucid Lynx)
---
I recently upgraded nearly all of my 32-bit Linux installations to the
latest 64-bit Xubuntu "Lucid Lynx" release, and was chagrined to find
that I couldn't install the Amazon MP3 downloader. For whatever
reason, they've decided to only support a 32-bit installation.
Fortunately, 64-bit users can still install and use 32-bit packages
through a handy tool called `getlibs`.

There's a thread about [using getlibs](http://ubuntuforums.org/showthread.php?t=474790) on the
Ubuntu forums that I found helpful, but (for the amazonmp3 package, at
least) that tool alone is insufficient. I began by installing
`getlibs` and forcing the installation of `amazonmp3`, which leaves it
without any dependencies and quite inoperable. `getlibs` attempts to
resolve these 32-bit dependencies and install them outsite of apt system.

    wget http://frozenfox.freehostia.com/cappy/getlibs-all.deb
    sudo dpkg -i getlibs-all.deb
    wget http://amazonm-002.vo.llnwd.net/u/d1/clients/en_US/1.0.9/amazonmp3_1.0.9~ibex_i386.deb?httpHeader%5FContent-Disposition=attachment%3B%20filename%3Damazonmp3.deb&amp;marketplace=1
    sudo dpkg -i --force-all amazonmp3.deb
    sudo getlibs /usr/bin/amazonmp3

At this point, you'll see a frustrating spew of "No match"
notices for various libboost libraries. Through `aptitude search libboost`,
I realized that Lucid had upgraded to version 1.40.0, but
the Amazon was built for the 1.34.1 version that comes with
Intrepid/Jaunty. `getlibs` works within the constraints of your
current apt sources, so it couldn't resolve these dependencies.

    No match for libboost_filesystem-gcc42-1_34_1.so.1.34.1
    No match for libboost_regex-gcc42-1_34_1.so.1.34.1
    No match for libboost_date_time-gcc42-1_34_1.so.1.34.1
    No match for libboost_signals-gcc42-1_34_1.so.1.34.1
    No match for libboost_iostreams-gcc42-1_34_1.so.1.34.1
    No match for libboost_thread-gcc42-mt-1_34_1.so.1.34.1

Fortunately, the repositories for previous distributions are still
accessible and can be searched fairly easily. Installing these
dependencies manually through getlibs will make them available to the
amazonmp3 binary.

    sudo getlibs -w http://old-releases.ubuntu.com/ubuntu/pool/main/b/boost/libboost-filesystem1.34.1_1.34.1-11ubuntu1_i386.deb
    sudo getlibs -w http://old-releases.ubuntu.com/ubuntu/pool/main/b/boost/libboost-regex1.34.1_1.34.1-11ubuntu1_i386.deb
    sudo getlibs -w http://old-releases.ubuntu.com/ubuntu/pool/main/b/boost/libboost-date-time1.34.1_1.34.1-11ubuntu1_i386.deb
    sudo getlibs -w http://old-releases.ubuntu.com/ubuntu/pool/main/b/boost/libboost-signals1.34.1_1.34.1-11ubuntu1_i386.deb
    sudo getlibs -w http://old-releases.ubuntu.com/ubuntu/pool/main/b/boost/libboost-iostreams1.34.1_1.34.1-11ubuntu1_i386.deb
    sudo getlibs -w http://old-releases.ubuntu.com/ubuntu/pool/main/b/boost/libboost-thread1.34.1_1.34.1-11ubuntu1_i386.deb
    sudo getlibs -w http://old-releases.ubuntu.com/ubuntu/pool/main/i/icu/libicu38_3.8.1-2ubuntu0.2_i386.deb

Now `amazonmp3` works correctly, although don't be surprised if you
encounter a few issues. For instance, it attempts to use load the
64-bit libgvfsdbus.so library on startup, but doesn't seem to care
when that loading fails. C'est la vie.

*Updated 2010-11-26 09:05 to fix links to the .deb files. Thanks to Stefan for this info.*

