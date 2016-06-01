---
date:  2008-02-21
title: Joel on Office Binary Formats
---
Joel Spolsky has some very enlightening comments on Microsoft's recently released <a href="http://www.microsoft.com/interop/docs/OfficeBinaryFormats.mspx">Office Binary Formats</a>.  Specifically, he <a href="http://www.joelonsoftware.com/items/2008/02/19.html">explains why they are so inscrutable</a>.  An excerpt:

<blockquote>
  <p><em>A normal programmer would conclude that Office's binary file formats:</em></p>
  <ul>
    <li><em>are deliberately obfuscated</em></li>
    <li><em>are the product of a demented Borg mind</em></li>
    <li><em>were created by insanely bad programmers</em></li>
    <li><em>and are impossible to read or create correctly.</em></li>
  </ul>
  <p><em>You'd be wrong on all four counts. With a little bit of digging, I'll show you how those file formats got so unbelievably complicated, why it doesn't reflect bad programming on Microsoft's part, and what you can do to work around it.</em></p>
</blockquote>

Given its pedigree, I can't see how <acronym title="Office Open eXtensible Markup Language">OOXML</acronym> could be a good choice for a standard.  Joel says the following about OOXML's proprietary predecessors:

<blockquote>
<p><em><b>They were not designed with interoperability in mind.</b> The assumption, and a fairly reasonable one at the time, was that the Word file format only had to be read and written by Word. That means that whenever a programmer on the Word team had to make a decision about how to change the file format, the only thing they cared about was (a) what was fast and (b) what took the fewest lines of code in the Word code base. The idea of things like SGML and HTML&mdash;interchangeable, standardized file formats&mdash;didn't really take hold until the Internet made it practical to interchange documents in the first place; this was a decade later than the Office binary formats were first invented.</em></p>
</blockquote>

