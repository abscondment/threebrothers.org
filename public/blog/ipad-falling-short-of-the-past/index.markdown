---
date:  2010-01-30
title: iPad: Falling Short of the Past
---
<p>
  <img src="http://threebrothers.org/brendan/images/jobs-ipad.png" alt="Steve Jobs and the iPad" style="float:right;margin:0 0 0 1em;" />
  Steve Jobs announced the iPad this week, and technologists have run the gamut of responses. Some people think it will fart rainbows. Some think its reason-defying sorcery and closed software will <a href="http://al3x.net/2010/01/28/ipad.html" rel="nofollow">inveigle unsuspecting hackers into a gloomy extinction</a>. For the most part, however, the response has amounted to a <a href="http://www.youtube.com/watch?v=lQnT0zp8Ya4" rel="nofollow">banal whine</a> about Flash, multitasking, and maxi pads. Why anyone would complain about <em>not</em> being continually tortured by Flash is beyond me&mdash;but that's another post entirely.
</p>

<p>
  I'm continually led to appreciate the history of Computer Science. I write software for a living, and I've used a number of different languages. I began in O-BASIC, and I've taken an analogous path to the one described by Paul Graham in <em><a href="http://www.paulgraham.com/icad.html" rel="nofollow">Revenge of the Nerds</a></em>:
</p>

<blockquote>
  <p>
    <em>
      If you look at these languages in order, Java, Perl, Python, you notice an interesting pattern. At least, you notice this pattern if you are a Lisp hacker. Each one is progressively more like Lisp. Python copies even features that many Lisp hackers consider to be mistakes. You could translate simple Lisp programs into Python line for line. It's 2002, and programming languages have almost caught up with 1958.
    </em>
  </p>
</blockquote>

<p>
  &quot;Programming languages have almost caught up with 1958.&quot; Something about that really resonates with me, and I don't think it's only because I've been drinking the Lisp-flavored Clojure Kool-Aid. In fact, I'm sure it's not.
</p>

<p>
  I remember the day I had the <acronym title="Model-View-Controller">MVC</acronym> epiphany. I'd worked a little bit in <a href="http://static.springsource.org/spring/docs/2.0.x/reference/mvc.html" rel="nofollow">Spring's framework</a> and had recently dove into the relatively soothing balm of Rails. My prior projects hadn't had any really clean separation. &quot;Man,&quot; I thought, &quot;what a great, new invention. I don't know how people developed web applications before MVC existed.&quot; Then I discovered that <a href="http://heim.ifi.uio.no/~trygver/themes/mvc/mvc-index.html">MVC originated in Xerox PARC in the 70s</a>. Of course, I should have known better&mdash;I had to read all sorts of PARC papers in school. Never underestimate your own capacity to forget important and interesting information.
</p>

<p>
  Here's the interesting thing: we're constantly leaving what's rooted in history and rigor for the technique <em>du jour</em>. Lisp isn't for everyone, but enough incredibly smart people swear by it that it should give you pause. There may be a good alternative to MVC for your application, but chances are you've exchanged it for a fragile pile of highly-coupled, poorly organized classes. You may think it's OK to treat a Java interface like a C header file (yes, I maintained code that had this charming characteristic), but this simply indicates that you don't know the first thing about object-oriented programming.
</p>

<p>
  Now, it would be silly of me to quote <em>Revenge of the Nerds</em> and then make some (de)moralizing point about &quot;industry best practices.&quot; My point thus far is this: for a given problem, it's likely that an efficient and elegant solution exists already (even if only in concept). And very often, it was invented <em>years</em> ago. <b>It is good to be well-versed in the history of your trade.</b> This will help you know how to think about whole classes of problems. And this&mdash;finally&mdash;brings me back to the iPad.
</p>

<p>
  <img src="http://threebrothers.org/brendan/images/parcpad.png" alt="The ParcPad" style="float:left;margin:0 1em 0 0;" />
  Critics are right to be at least a little disappointed, but not due to the likes of Flash or multitasking. The iPhone and iPad are still behind research prototyped at PARC (yes, them again) in the late 80s. Mark Weiser's <a href="http://sandbox.xerox.com/ubicomp/" rel="nofollow">Ubiquitous Computing research</a> conceived of and built a variety of devices for home and office use&mdash;called tabs, pads, and boards&mdash;sized just like iPhones, iPads, and large LCD screens. They even wrote software and built networking devices to stitch the environment together.
</p>

<p>
  It's obvious that Xerox has had a profound impact on Steve Jobs, from the Lisa to the iPhone. When I first heard about the iPhone in 2007, I instantly thought of the ParcTab. Hardware has improved tremendously since the ParcTab experiments and <a href="http://www.ubiq.com/weiser/researchreports.htm" rel="nofollow">papers</a>. Apple now reaps the benefits of faster and cheaper processors, ram, and storage. Wireless networking is pervasive and fast. Screens are vastly better, and touch inputs have obviously improved. The device is supremely capable. But the ubiquitous user interface is completely absent.
</p>

<p>
  I recently advised a nontechnical friend about purchasing an iPhone. She wanted to know how it interfaced with her computer and TV. &quot;It really doesn't,&quot; was my response. But she expected it to. It doesn't take an engineer to see that devices like the iPhone and iPad <em>ought</em> to operate as an extension to the computer or TV. Instead, we have this media syncing model that's reminiscent of some lousy corporate <acronym title="Personal digital assistant">PDA</acronym>. Technology pundits who are quibbling about little features are missing the point: the iPad should have made the jump to seamless, ubiquitous integration. This would have been a technological revolution equivalent to the introduction of the iPhone. This is the next step.
</p>

<p>
  Both the iPhone and the iPad should operate as stand-alone devices. But they could bring so much more power and flexibility if they also acted as extensions to a desktop, laptop, or distributed network. A general-purpose, network-aware, hand-held device that can continue operating without the network. Access this computer and that; give a presentation on this screen; share files with these people; receive and send email; play a game; order lunch&mdash;and use any of your iPhone, iPad, or MacBook at any point in the progression, with the others automatically and wirelessly synced. This is what I expected of Apple.
</p>

<p>
  Indeed, Mark Weiser accurately predicted our current systems in 1996. In <a href="http://www.ubiq.com/hypertext/weiser/acmfuture2endnote.htm">The Coming age of Calm Technology</a>, he describes a transition from the internet and distributed computing to &quot;The <acronym title="Ubiquitous Computing">UC</acronym> Era&quot;&mdash;and he said it would take place between 2005 and 2020. He describes the philosophy of UC with four tenets:
</p>

<ul>
  <li>The purpose of a computer is to help you do something else.</li>
  <li>The best computer is a quiet, invisible servant.</li>
  <li>The more you can do by intuition the smarter you are; the computer should extend your unconscious.</li>
  <li>Technology should create calm.</li>
</ul>

<p>
  This is the standard to which Apple should be held. We're collectively forgetting how good the iPad <em>should</em> be, because we're forgetting how much brilliant computer science research has already been done. Like Java, Perl, and Python, the present incarnation will inch towards superior and older definition. And although I disagree with them philosophically about the openness of their systems to hackers, I believe they will soon reach the ubiquitous computing standard. This will be good for technology all around.
</p>
<p>
  Just remember to peer back a few decades occasionally and recall exactly how much we should expect from modern-day engineering.
</p>

<p>
  <br/>
  <em>
    What has been is what will be,<br/>
    &nbsp;&nbsp;&nbsp;and what has been done is what will be done,<br/>
    &nbsp;&nbsp;&nbsp;and there is nothing new under the sun.
  </em>
  <br/>
  <a href="http://www.gnpcb.org/esv/search/?q=Ecclesiastes+1" rel="nofollow">Ecclesiastes</a>
</p>

