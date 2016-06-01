---
date:  2011-05-06
title: Ruby 1.9.2 on Ubuntu 11.04 
---
I've been building an application from scratch, and I want to go with
the latest and greatest of the Ruby world. It's not yet clear to me
which of Ruby 1.9.2, JRuby, and REE fit the bill, but I've picked
1.9.2. &ndash; at least for now.

I'm building around Ubuntu server, and am automating this process with
Chef. I've seen two different companies get stuck on outdated Ruby or
Rails versions due to lack of easy provisioning, and I don't want to
be in that boat. On the other hand, I want to devote as much time as
possible to user facing features; no one's going to use what I make
based on our future server maintenance paths.

## Ubuntu packages

Ubuntu 11.04 provides a fake 1.9.2 package that is provided by
`ruby1.9.1`. Installing `ruby1.9.1` actually installs 1.9.2-p0, but
all of the binaries are suffixed with 1.9.1. I hate this false naming
on a purely conceptual level, but I'm sure there's some Debian-based
compatibility issue and I could get over it. However, there have been
three [important](http://svn.ruby-lang.org/repos/ruby/tags/v1_9_2_136/ChangeLog)
[releases](http://svn.ruby-lang.org/repos/ruby/tags/v1_9_2_180/ChangeLog)
[since](http://svn.ruby-lang.org/repos/ruby/tags/v1_9_2_290/ChangeLog)
1.9.2-p0 that contain significant bug fixes. The combination makes that
a show stopper for me.

## RVM

RVM is a tempting option. It's PATH magic is a little too incomplete
for production use, in my opinion &ndash; RVM binaries are
conspicuously absent for cron jobs and other non-interactive
shells. This could probably be fixed, but that would feel like a hack
around a hack. And I really don't want to deal with the eventual and
inevitable breakage of all that magic *in a production environment*.

## Compile from source

I considered just compiling a binary on each machine, but this is a
quick path to upgrade/maintenance hell. Another downside (that RVM
shares) is the time cost &ndash; with a precompiled package, Ruby is
installed in a matter of seconds. Compiling for minutes could be a
minor problem when provisioning a bunch of extra instances in
*The Cloud*.

## Roll your own .deb

I decided to combine the source option with the packing option. This
allows me to quickly distribute and install a binary while retaining
control over patch level, executable names, *et cetera*. However, it
made me appreciate the
[difficulties faced by Ruby package maintainers](http://www.lucas-nussbaum.net/blog/?p=617)
&ndash; it's not exactly a straightforward process.

Here are some things I learned the hard way:

 * [checkinstall is broken on Ubuntu](https://bugs.launchpad.net/ubuntu/+source/checkinstall/+bug/78455).
   You have to pass in `--fstrans=no` to get it to work properly.
 * Ruby wants to install in `/usr/local`, but Ubuntu/Debian would
   prefer it to live in `/usr`. I decided to stick with the host
   system's default.
 * PATH is tricky here, too. If you install in `/opt`, your gem binaries
   won't be on the PATH. You'll need to solve the same sort of PATH
   issues RVM has if you want to add your `/opt` bindir to everyone's
   PATH.
 * `update-alternatives` is your friend; use it!

Here's the build process I settled on:

    #!/bin/bash
    sudo apt-get -y install zlib1g-dev libssl-dev libreadline5-dev
    libyaml-dev build-essential bison checkinstall
    cd /tmp
    wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.2-p290.tar.gz
    tar xvzf ruby-1.9.2-p290.tar.gz
    cd ruby-1.9.2-p290
    ./configure --prefix=/usr\
                --program-suffix=1.9.2\
                --with-ruby-version=1.9.2\
                --disable-install-doc
    make
    sudo checkinstall -D -y\
                      --fstrans=no\
                      --nodoc\
                      --pkgname='ruby1.9.2'\
                      --pkgversion='1.9.2-p290'\
                      --provides='ruby'\
                      --requires='libc6,libffi5,libgdbm3,libncurses5,libreadline5,openssl,libyaml-0-2,zlib1g'\
                      --maintainer=brendan.ribera@gmail.com
    sudo update-alternatives --install /usr/bin/ruby ruby /usr/bin/ruby1.9.2 500\
                            --slave   /usr/bin/ri   ri   /usr/bin/ri1.9.2\
                            --slave   /usr/bin/irb  irb  /usr/bin/irb1.9.2\
                            --slave   /usr/bin/gem  gem  /usr/bin/gem1.9.2\
                            --slave   /usr/bin/erb  erb  /usr/bin/erb1.9.2\
                            --slave   /usr/bin/rdoc rdoc /usr/bin/rdoc1.9.2

I'm not 100% confident in my checkinstall/deb-foo &ndash; namely, the
semantics of `--requires` and `--provides` are a little unclear to
me. Nor am I sure that the list of required binaries that I provided
is completely accurate. What I do know is that all of this works.

I can now automate installation of this package on any machine I
provision and instantly have the latest Ruby patch level with properly
named binaries. Cool!

*Updated 2011-09-01 15:12 to point this script at the **1.9.2-p290** release.*

