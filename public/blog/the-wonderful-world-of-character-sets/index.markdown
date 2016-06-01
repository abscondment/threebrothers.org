---
date:  2007-01-19
title: The wonderful world of Character Sets
---
Avast yer browsing!  I ran into a funny story about <a href="http://itre.cis.upenn.edu/~myl/languagelog/archives/004064.html">character set mishaps</a> on Language Log today.  If <em>only</em> I were having problems with unintentionally affiliating my work with piracy--alas, no.  Hopefully, you're using a browser that actually displays Unicode correctly.  If not, you'll be perplexed by the icon below. (What Icon? Ruh roh... I'd suggest emailing the makers of your wonderful browser and telling them to read this <a href="http://www.joelonsoftware.com/articles/Unicode.html">article on Unicode</a>.)

<p style="text-align: center"><span style="font-size: 3em">&#x2620;</span></p>

What I am running into in my capstone project is this: Thus far, I've imported roughly 10,000 of <a href="http://gutenberg.org">Project Gutenberg's</a> E-Texts.  That's a lot o' document, if you ask me.  Many of these texts are available in multiple encodings, and multiple character sets.  For simplicity's sake, I'm only grabbing texts that are available in raw text--no zips, no <acronym title="HyperText Markup Language">HTML</acronym>, <em>et cetera</em>.

Despite my filtering by encoding type and my best efforts with iconv, many of the text streams throw encoding errors when I try to insert them into the <a href="http://www.postgresql.org">database</a>.  Most are available in an alternate character set, but (so far) 7.39% are only available in what I will term an "offensive" format.

Were I more concerned with writing a perfect importation program, I would deal with the offending characters in some manner and salvage the rest of the text.  But, I'm happy with the number of texts I have so far.  An important aspect of software <em>engineering</em> is realizing when to trade the theoretical ideal for a practical implementation--I'm going to be swamped implementing the features that do make the final cut in this project, and missing >8% of the available seed texts is hardly a rational concern.

<b>Update:</b>
I've finished processing the catalog.  Here are the final figures...
<blockquote><span style="font-size:.8em;font-family:mono, sans-serif;">&nbsp;potential&nbsp;|&nbsp;processed&nbsp;|&nbsp;errors&nbsp;|&nbsp;valid&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;percent_err<br />       
<hr />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;19573&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;18718&nbsp;|&nbsp;&nbsp;&nbsp;2646&nbsp;|&nbsp;16072&nbsp;|&nbsp;0.14136125654450261780</span></blockquote>

What this means is that out of 19,573 uniquely titled works, I attempted to process 18,718.  The difference between those two numbers lies in available format: I only accepted raw text.  Out of those 18,718 documents, 16,072 were entered successfully; ~14% were lost due to character set incompatibility.  Frankly, 16,072 documents is more than enough for my purposes, and so I'm moving on.
