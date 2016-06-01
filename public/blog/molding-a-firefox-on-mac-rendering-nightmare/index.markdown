---
date:  2008-02-13
title: Molding: A Firefox on Mac Rendering Nightmare
---
At iLike, we have a really cool page showing <a href="http://ilike.com/artist">the fastest-spreading songs</a> among our user base.  That page has many, many songs on it, and &mdash; as you can see below &mdash; you can listen to clips of many of those songs.

<img src="http://threebrothers.org/brendan/blog/files/mac-rendering-bug.png" alt="Mac rendering bug" style="border:2px solid #666;padding:.25em;width:500px;" />

We have a pretty awesome clip player that indicates how far along you are in the song you're currently playing.  It does this by positioning a <em>&lt;div&gt;</em> behind the track title and artist name, and resizing it as time elapses.  The title and artist name are stuck inside a <em>&lt;span&gt;</em> &mdash; the red box surrounding "<em>New York</em> by Cat Power" in the above picture is this very element.  It provides a great visual effect, unless you're both a Firefox user and a Mac user.

In this happy case, the "by" portion of the title appears to <b>mold</b>.  That's right, I'm coining a term.  In the image above, the word "by" appears slightly bolded, with really fuzzy edges.  In reality (read: in our <acronym title="HyperText Markup Language">HTML</acronym> and <acronym title="Cascading Style Sheets">CSS</acronym>), "by" isn't bold; it has default font weight.  For some reason, however, Firefox on Mac does extra rendering.

You could actually watch the "by" turn fuzzy-bold, growing little nasty pixelated edges (you could do this by selecting "by" and then de-selecting it).  It actually looks like the word is growing <em>mold</em>.  This behavior was so inexplicable and opaque that this functionality has been around for a long time; I just figured out how to fix it, however, and thought that it might be plaguing other developers.

The issue is one of transparency.  For some reason, the rendering engine is overproducing (molding, if you will) <b>opaque, black</b> text inside a <em>&lt;span&gt;</em> that has another element (a &lt;div&gt; in our case) positioned directly behind it.  Instead of properly anti-aliasing the text, the renderer adds a bunch of really ugly artifacts.  All sorts of trickery fails to knock sense into the render.

I finally found something that works, however:

    .song_title {
      [snip]
      opacity:0.99;
    }

Forcing the text from completely opaque to partly transparent appears to jump us out of the buggy render path.  As far as the user is concerned, setting the opacity to 99% changes nothing &mdash; it still looks solid black to me!  Yet, we no longer get nasty molding.  Who knew that one line of code could reverse all that ugliness?

