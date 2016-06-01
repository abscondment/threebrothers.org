---
date:  2007-04-03
title: Samba Share Success
---
I've been struggling to set up a Samba share on my work machine that provides a public folder to <em>both</em> Windows and Linux clients for quite some time now.  See, we have a <a href="http://www.slimdevices.com/pi_squeezebox.html">Squeezebox</a> set up in the developer workspace.  It's a great system, facilitating countless battles between those of disparate musical taste.  Naturally, I've wanted in on the action since I started&mdash;but until now, I've been largely denied.

The set up requires that people host their own music in a shared folder, and place a Windows shortcut to their share in a folder on the machine that is running the <a href="http://www.slimdevices.com/pi_features.html">SlimServer software</a>.  Sounds simple enough, right?  I'd assume so, too, but the plethora of <a href="http://www.google.com/search?q=samba+public+share">Samba tutorials</a> provide conflicting and only partially working solutions.

The problem I kept encountering is this: in order for the shortcut to work, Windows can't be required to provide a password to access the share.  However, the vast majority of tutorials suggest that setting

    security = share

is the correct way to achieve this.  Unfortunately, this causes windows to misbehave: <b>"The account is not authorized to log in from this station,"</b> and other such nonsense.

Fortunately, I found <a href="http://micheljansen.org/blog/entry/182">this configuration</a>, which had some components that all the others missed.  Here are key steps that had been absent in other configurations:

 * Follow a standard user security method:<br/>`security = user`
 * Make sure that Samba has a 'nobody' account set up with <em>no</em> password:<br/>`# smbpasswd -an nobody`
 * Add the following to the `[global]` section:<br/>`map to guest = bad user`

Finally, I can contribute to the musical cacophony!


