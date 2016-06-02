---
date:  2010-03-29
title: iPhone Toilet Debacle Redux: The Backlight
---
Last Tuesday marked the 485<sup>th</sup> day since I dropped my first-generation iPhone in the toilet. I commemorated the occasion by setting my 3G in a precarious position on the edge of the bathroom sink, and then watching in horror from the shower as my almost-2-year-old came in and rammed it with a truck. Right into the toilet.

<div class='rightImage'><img src='http://threebrothers.org/brendan/images/cat-toilet.jpg' alt='' title='Credit: http://www.flickr.com/photos/harvardavenue/79221382/' /><br/><em>No!!!! My Phone!!!!</em></div>

You've probably experienced the sinking feeling that accompanies circumstances such as this one. My wife fished the phone out and I immediately shut it down, dried it off, and stuck it into a glass full of rice. What a crappy situation &ndash; pun indended. I began figuring out how I would justify buying a *third* ridiculously expensive phone-computer given my complete inability to protect said device.

Over the next few days, I discovered that the phone was still largely functional. The backlight was completely dead, but I could receive calls, connect to WiFi, and (most importantly) the touchscreen still worked. Adjusting brightness settings did nothing for the backlight. My tests were brief, and I placed the phone back in its rice cocoon afterwards with hopes that more moisture would be absorbed.

## Fixing the backlight

Fortunately, Phil hadn't yet [left for Google](http://thebogles.com/blog/2010/04/joining-google/), and he found some interesting claims about a method to fix a backlight that had died a watery death. The steps were:

 1. Backup the phone
 2. Perform a factory restore
 3. Adjust the brightness settings

I was skeptical, but after 5 days of no progress I thought it was worth a shot. Because I don't really ever leave Linux, I hadn't yet updated to the 3.1.3 OS release. I did this upgrade in lieu of the 'factory restore' step, and (after completing step 3) was delighted to find my backlight fully functional! Major kudos to Phil for locating this information.

It's interesting to engage in wild speculation about the hardware/software details that could lead to this. Perhaps some hardware state was corrupted by a short, and the resulting value had no valid meaning for the backlight. Normal brightness adjustment operated on the value, but didn't change enough of it to make it meaningful again (perhaps bit operations on an int that was saved as much larger than it's theoretical max &ndash; only operating on the lower order bits). Part of the upgrade/restore procedure writes sane defaults into these locations, restoring functionality. Who knows.

### Coda

In the intervening days between my phone's death and revival, I got to play with a Nexus One from work. I'll write a post comparing the two soon. And I'm *really* glad that I don't have to shell out for a new phone... yet.

