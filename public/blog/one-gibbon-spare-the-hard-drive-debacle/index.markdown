---
date:  2007-11-01
title: One Gibbon, Spare the Hard Drive Debacle
---
A <a href="https://launchpad.net/bug59695.html">bug against Ubuntu's acpi-support package</a> recently made the "headlines" on Digg, and it precipitated a flurry of worrisome blog posts and comments.

I recently upgraded my VAIO laptop to <a href="http://www.ubuntu.com/news/ubuntu710">the Gutsy Gibbon</a>, so I was very curious about whether this would affect me.  My understanding of the issue is this:

<ol>
  <li>Hard drive life expectancy can be measured in terms of Load/Unload cycles &mdash; the average drive can undergo 600,000 of these operations in its lifetime.</li>
  <li>I've been lead to believe that these occur when the disk spins down or up; this places laptops in an interesting position, because spinning the disks down during inactivity can save significant amounts of battery power.</li>
  <li>The default configuration for when to spin down disks is set in the BIOS by the manufacturer, but some manufacturers set incredibly aggressive values. Reports in bug indicate people experiencing upwards of 25 load/unload cycles in a 10 minute period.</li>
  <li>It's very likely that Apple and Microsoft override nonsensical default values to save the hard drives of their users.</li>
  <li>Ubuntu does not do this (yet), nor does any Linux distribution that I know of.  In my opinion, safe defaults should be a P0 fix.</li>
</ol>

Fortunately for me, my hard drive manufacturer seems to have set sane defaults.  According to my calculations, my laptop experiences 0.21 load/unload cycles every minute as compared to the 2.5 reported in the bug.  This means that my hard drive will last approximately 12 times longer than the one belonging to the bug's owner.  Sad for him, but I'm pleased to be unaffected.
