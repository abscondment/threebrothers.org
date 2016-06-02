---
date:  2010-04-13
title: Android Impressions
---
<div class='rightImage'>
  <img src='http://threebrothers.org/brendan/images/android-baked-goods.jpg' title='Credit: http://www.flickr.com/photos/niallkennedy/4118685804/' alt='Credit: http://www.flickr.com/photos/niallkennedy/4118685804/' />
  <br/>
  <em>Fitter, happier, more pastries.</em>
</div>

Thanks to my [latest aquatic shenanigans](http://threebrothers.org/brendan/blog/iphone-toilet-debacle-redux-backlight/), I spent a week playing with a Nexus One. Here are my impressions. If I make any comparisons that lack context, assume they are drawn in relation to the iPhone.

## Product quality

### Hardware

Negative:

 * Only 4.5GB of space by default (512MB flash + 4GB SD)
 * Generally poorer battery performance than the iPhone
 * Five buttons &ndash; <abbr title='Keep it simple, stupid!'>KISS</abbr>

Positive:

 * Removable battery (I can't stress enough what a boon this is)
 * Swappable micro SD card
 * Screen is larger and higher resolution
 * 5 megapixel camera with flash (compare to the iPhone's flashless 3 megapixel)
 * 1GHz processor with 512MB RAM (600MHz/256MB for a 3GS)
 
The Nexus One has a substantial, polished feel. It's not exactly *sexy* in the ways the iPhone is, but it certainly doesn't feel like a cheap imitation. The specifications are pretty substantial, too. Given the superior hardware, it's understandable that battery life is inferior. Who knows about either phone's long-term battery performance. If the lithium-ion gods frown on you after a few months, you'll be forking over $79 with Apple and only $25 with Google.

### Software

Negative:

 * Inferior and slightly confusing UI
 * Inferior app selection
 * Browser feels clunky compared to Safari

Positive:

 * Android OS is open source
 * Android Market is growing
 * Background apps
 * Apps are cloud-oriented; no more syncing through slow, clunky iTunes

<div class='rightImage'>
  <img src='http://threebrothers.org/brendan/images/nexus-one-buttons.jpg' title='Credit: http://www.flickr.com/photos/naka7a/4356824760/' alt='Credit: http://www.flickr.com/photos/naka7a/4356824760/' />
  <br/>
  <em>Look at those wee, beady buttons.</em>
</div>

I found the UI to be the biggest barrier for me. I disliked the Nexus One's [pentavirate](http://www.youtube.com/watch?v=TPMS6tGOACo) of buttons before I had even turned it on. 'Back' and 'Search' are given permanent hardware real estate despite their limited applicability &ndash; many (if not most) apps have no use for them. 'Home' is present, but given a middle position with no tactile means of locating it &ndash; it's hard to switch apps in the dark.

And then there's the 'Menu' button &ndash; this is where the biggest problems lie. I'm an engineer, but I have a [degree in Informatics](http://ischool.uw.edu/informatics/prospective/at_uw.aspx) &ndash; I have enough interface design and usability knowledge to cause trouble. Here's what I see in the 'Menu' button: the iPhone makes good use of *affordances*; Android does not. What do I mean?

> <a name='rn1'></a>*An **affordance** is an aspect of an object that makes it obvious how the object is to be used. [&hellip;] Affordances must be visible to aid interpretation.*<sup><a href='#fn1'>1</a></sup>

The 'Menu' button doesn't make its functions obvious. If you press it, a menu comes up; if you hold it down, the on-screen keyboard appears. Both functions could be loosely associated with the button's graphic, but one would never guess them by simply looking at the button. This is minor, though; one can figure this functionality out quickly, and once it's known, that's that. What is bad is the precedent that this button sets for applications.

The Android developer guide prefaces its section on [Menu Design Guidelines](http://developer.android.com/guide/practices/ui_guidelines/menu_design.html) with this assertion:

> *A menu holds a set of commands (user actions) that are normally hidden, and are accessible by a button, key, or gesture.*

By convention, **every Android interface has broken affordances**. Apps are asked to obscure large portions of functionality in a hidden menu. Contrast this with Apple's in-depth [iPhone Human Interface Guidelines](http://developer.apple.com/iphone/library/documentation/UserExperience/Conceptual/MobileHIG/PrinciplesAndCharacteristics/PrinciplesAndCharacteristics.html#//apple_ref/doc/uid/TP40006556-CH7-SW1):

> *Presenting choices to the user [&hellip;] allows them to concentrate on accomplishing tasks with your application, instead of remembering how to operate it.*

People tout simplicity as being the aspect of Apple's design that makes it superior. What they're trying to articulate is that the consistent application of good affordances allows users to approach every interface with knowledge about how to use it. The UI is not only simple &ndash; it's *understood*. Apple's defaults are a shared set of *visible* controls &ndash; (almost) everything that can be done is displayed using a common language. Android causes apps to fragment the user's knowledge &mdash; you have to individually *discover* and then *remember* exactly what can be done by every app because much of the functionality is invisible.

## For consumers and developers

<div class='rightImage'>
  <img src='http://threebrothers.org/brendan/images/babbage-engine.jpg' alt='Babbage Analytical Engine' />
  <br/>
  <em>The Apple Analytical Engine<br />only accepts papyrus punch cards.</em>
</div>

I've spent a bit of time talking about what I perceive to be the biggest weakness in the Android platform. This section is *much* friendlier towards Android.

Android is a platform for hackers. It's open source, and can be hacked using any <abbr title='Java Virtual Machine'>JVM</abbr> language on any development platform. The iPhone requires you to purchase an expensive Apple computer, use only the [approved tools/languages](http://daringfireball.net/2010/04/iphone_agreement_bans_flash_compiler) , and pay $99/year to be part of the developer program. Android phones also come unlocked &ndash; that is, you can use them with any network.

I've heard it suggested that Apple's closed platform will lead to better quality and a tighter control on the market. These sound like great things *for Apple*. As consumers, we don't necessarily want Apple to have control, and we don't want to be hogtied to AT&amp;T &ndash; we want competition to force continued innovation.

There are copious blog posts discussing the negative ramifications of Apple's closed platform. If you've read none of them, *[Tinkerer's Sunset](http://diveintomark.org/archives/2010/01/29/tinkerers-sunset)* and the [post of Alex Payne's](http://al3x.net/2010/01/28/ipad.html) that inspired it (or at the very least inspired the title) are good start. I don't have much to add here. Limiting developers' tools or languages stifles innovation. The inverted version is what attracts me to Android: granting freedom to developers promotes innovation.

## Conclusion

The Nexus One hardware and the openness of the Android platform outweigh any UI advantage held by the iPhone. As this assertion comes from a guy who spends upwards of 8 hours a day inside emacs or a Linux terminal, it should be taken with a few grains of salt. When my contract with AT&amp;T is up, however, I'll be looking to the Android market for my next phone. And I'd love to get ahold of an Android tablet.

<hr/>

<sup>1</sup> <span class='fn'>Mary Beth Rosson and John M. Carroll, <em><a href='http://books.google.com/books?id=RRC9IODz4VsC&amp;pg=PA124'>Usability Engineering</a></em> (Morgan Kaufmann, 2002), 124. <a name='fn1' href='#rn1'>&crarr;</a></span>


