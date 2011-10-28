I recently bought a MacBook Pro (no, [my opinions](../there-and-back-again-the-return-to-linux/) 
haven't changed) for iOS development. With it, I bought a shiny new
SSD. As it shipped, I read nasty reports of a firmware bug that caused
the drive to freeze *or lose data* when awaking from sleep/hibernate
in OSX. Yikes!

My drive arrived and did indeed have the affected firmware. There was
an updated version, but OCZ does not make a firmware upgrade tool for
OSX. And even outside of OSX, the process is not straightforward.

### What didn't work:

 * Plugging the drive into a machine running Windows. The NVIDIA
   nForce drivers that my motherboard use prevent the tool from
   detecting the drives.
 * Plugging the drive in and booting into Linux (at least
   initially). The tool reports the drive as locked or frozen, and
   asks for a power cycle. Reboot and retry as one might, the message
   remains the same. Early investigations led me to believe this was
   due to an old BIOS.
 * Booting into an Ubuntu Live CD on a 2011 MacBook Pro and flashing
   from there. Most Live CDs can't even detect the DVD drive and
   boot. The ones that can don't detect either network interface, and
   Internet access is required by the tool.

### The solution:

Use Linux, either a Live CD or a full installation. When the drive
appears as locked/frozen, suspend the computer and wake it up
again. Or even plug the drive in after booting up, although this seems
marginally risky for drives that already contain data. Either of these
should trick the drive into unfreezing (I only verified the first).

Simple, yet unintuitive.
