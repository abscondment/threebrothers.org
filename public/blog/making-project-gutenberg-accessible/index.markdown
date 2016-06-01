---
date:  2007-01-17
title: Making Project Gutenberg Accessible
---
Part of my <a href="http://www.ischool.washington.edu/informatics/capstones/default.aspx">Informatics Capstone</a> project requires a large number of freely available electronic texts -- the project is based around managing one's personal library, after all, and a lot can be done if one has access to an electronic version of one's library.  One aim of my project is to provide greater access to the books in one's library by allowing users to search within electronic texts marked as part of the library.

Enter <a href="http://gutenberg.org">Project Gutenberg</a>, the self-proclaimed "first producer of free electronic books".  Here lie some 20,000 potential seed texts, all free of restrictive copyrights.  Using <a href="http://libxml.rubyforge.org/">libxml-ruby</a> and <a href="http://www.rubyonrails.org/api/classes/ActiveRecord/Base.html">ActiveRecord</a>, I'm currently downloading the entire catalog and preparing it for use with <a href="http://lucene.apache.org/">Lucene</a>.  I'm restricting the imported texts to those that are available as raw text.  I'm also battling character encoding problems that would make <a href="http://www.joelonsoftware.com/articles/Unicode.html">Joel Spolsky proud</a>. One would think that an advanced, high-level language like Ruby would have built-in character set support in the String object rather than <a href="http://www.ruby-doc.org/stdlib/libdoc/iconv/rdoc/index.html">a clunky wrapper for UNIX's iconv() function</a>--alas, no.

But I digress.

I'm in the midst of conducting requirements gathering interviews, and things are going marvelously.  There's some great potential for creating a dynamic community of book lovers <em>and</em> providing people with a useful service.  And that's exactly the sort of thing my degree is supposed to be good for, right?  Right.
