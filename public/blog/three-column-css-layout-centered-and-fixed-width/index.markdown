---
date:  2007-03-01
title: Three Column CSS Layout: Centered and Fixed-Width
---
This technique may not be news to anyone, but it was a good learning experience for me.  I worked with my friend Steve Hardin to create <a href="http://thethreadseattle.org">The Thread</a> website for our upcoming art night.  Steve is an awesome designer, with a very distinctive style that lends itself to the web readily.

Steve handed me an initial layout, which used tables to hold his stunning imagery at pixel-perfect attention.  I assume it was the product of Dreamweaver, Photoshop, or some other type of <acronym title="What You See Is What You Get">WYSIWYG</acronym> editor.  Being something of a web standards snob (<acronym title="Web Standards Snob: Addicted to &lt;acronym&gt;">WSS</acronym>?), I really wanted to avoid the use of tables <em>for layout</em>.

Let's back up a second so I can be perfectly clear.  The <acronym title="HyperText Markup Language">HTML</acronym> tables in question validate, and so they are standards-compliant in the strictest sense.  However, there are <a href="http://www.hotdesign.com/seybold/">many reasons</a> why <a href="http://www.saila.com/usage/layouts/cssvtables.shtml">using tables</a> for layout is <a href="http://www.davespicks.com/essays/notables.html">a bad idea</a>.  I'm especially partial to the argument given at the second link, which makes a case for <b>semantics</b>, <b>accessibility</b>, and <b>efficiency</b>.

Above all this, however, I really wanted the page to look <em>exactly</em> as Steve had created it--and if I couldn't figure out a way around tables, then tables I would use.

Fortunately, Steve's design looked like it could fit in a classic metaphor: the Three Column <a href="http://alistapart.com/articles/holygrail">"Holy Grail"</a> layout.  Referencing that article and another on <a href="http://alistapart.com/articles/multicolumnlayouts">Multi-Column Layouts</a>, I went to work.

The layout was rather simple: a left column displaying a 230 pixel image, a right column displaying a 50 pixel image, and a center column.  The center column was a bit tricky: Steve's design subdivided it into two 260 pixel columns, with 10 pixels of space between the original left column, the center left, the center right, and the original right column.  This was just for the front page; the page I was to add would use the full 530 pixels and have a 10 pixel margin on the left and the right.  Additionally, the whole design is centered in the page.

Reading through the above articles I found two major techniques: a centered layout having fixed-width rails with a fluid center, or a left-aligned layout with everything of fixed-width.  Not what I had in mind&mdash;the page really looked better centered, and making the center column fluid would disrupt the design.  Giving a `text-align:center;` property to any of the surrounding block elements did nothing useful.

Fortunately, I remembered a <a href="http://www.bluerobot.com/web/css/center1.html">really neat article on <acronym title="Cascading Style Sheets">CSS</acronym> centering</a>, which turned out to provide exactly what I needed:

    margin:0px auto;

Applying that to the containing block in the 3 column <a href="http://alistapart.com/d/multicolumnlayouts/3ColFixed.html">fixed-width example</a> centered it perfectly!  Well, I had to remove the `float:left;` directive and change the coloring around, too.  A full listing of the revised example CSS is below:



    #container{
      margin:0px auto;		
      width:500px;
      /* The width and color of the left rail */
      border-left:150px solid #cf9;
      /* The width and color of the right rail */
      border-right:200px solid #c33;
    }

    #leftRail{
      float:left;
      width:150px;
      margin-left:-150px;
      position:relative;
      background-color:#cf9;
    }

    #center{
      background-color:#9cc;
      float:left;
      width:500px;
      margin-right:-500px;
    }

    #rightRail{
      float:right;
      width:200px;
      margin-right:-200px;
      position:relative;
      background-color:#c33;
    }

You can also <a href="http://threebrothers.org/brendan/blog/wp-content/uploads/2007/03/3ColFixedCentered.html">view the example</a>.</blockquote>

In the end,  I achieved my goal: <a href="http://thethreadseattle.org">The Thread</a> uses <em>no</em> tables, <a href="http://validator.w3.org/check?uri=http://thethreadseattle.org">validates</a>, and looks exactly like the original design!  A victory for CSS, indeed.

