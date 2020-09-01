The quarter is winding down.  At least, I <em>hope</em> with as much sincerity as I can muster that it'll end soon; I'm ready to be focusing on work rather than school.  More on that in a different post; this one is about my <a href="http://www.ischool.washington.edu/informatics/capstones/default.aspx">Capstone Project</a>.

I've always loved literature, so it was a natural choice to focus my efforts in that direction.  The working name of my project is <b>TomeTracker</b>.  My aim was fairly simple: I wanted to provide people with better access inside the books <em>they already own</em>.

<a href="http://books.google.com">Google Books</a> and <a href="http://a9.com">Amazon's A9</a> search engine already provide services aimed at helping people <em>buy</em> books.  But I've already bought a bunch of books&mdash;far too many, if you ask my wife&mdash;and I want to make better use of <em>them</em>.

So, <b>personalized library search</b> is a key goal of my project.  And (because the concept is cool), I also want to make use of <b>heatmaps</b> to provide intuitive search results visualization.  Books may be long or short, but summarizing search results in heatmap form communicates very useful data regardless of a given book's length.  Here are the results thus far, with a few (contrived?) examples:

<b>First, a general library view</b>
This sample account has a scant 52 books, mostly because I'm lazy.
<img id="image48" src="//threebrothers.org/brendan/blog/wp-content/uploads/2007/02/lib-view.jpg" alt="lib-view.jpg" />

<b>Full-text search; heatmap results</b>
I wondered how many of my 52 books talk about <b>King Lear</b>.  Let's find out!
<img id="image49" src="//threebrothers.org/brendan/blog/wp-content/uploads/2007/02/lear.jpg" alt="lear.jpg" />

<b>Detailed results by book</b>
It's obvious that <em>King Lear</em> (the play) will contain the words "king" and "lear", but some of these other books are less obvious.  <em>Ulysses</em>, for instance&mdash;granted, Stephen Dedalus is always giving some-theory-or-another about Shakespeare, but he usually confines the ranting to <em>Hamlet</em>.  So what does the text actually say?
<img id="image50" src="//threebrothers.org/brendan/blog/wp-content/uploads/2007/02/lear2.jpg" alt="lear2.jpg" />

Ah.  Thank you, James Joyce... that's so much clearer.  Unfortunately, being able to search inside of <em>Ulysses</em> won't help you understand it.  Moving right along...

<b>Wonder when Friday appears in Robinson Crusoe?</b>
Yeah, it's pretty easy to locate unique passages in a given book, although it does require you to know something about the book in question.  For example, knowing that "Friday" is a character in Robinson Crusoe and that Raskolnikov commits murder with an axe is imperative for the following two examples.
<img id="image51" src="//threebrothers.org/brendan/blog/wp-content/uploads/2007/02/friday.jpg" alt="friday.jpg" />

When does Raskolnikov commit murder in <em>Crime and Punishment</em>?
<img id="image52" src="//threebrothers.org/brendan/blog/wp-content/uploads/2007/02/axe.jpg" alt="axe.jpg" />

Heatmaps are great for identifying <b>topical regions</b> within a text, and being able to retrieve snippets from a specific book allows the searcher to find <b>specific quotes</b>.  I've only been dabbling and testing thus far, but I think this would be really useful for writing papers and doing research.

<b>What's next?</b>
I think there's a lot here already, but there's more in the works.  I'm adding a social networking aspect to the prototype: find people with similar libraries, recommend books to other users, argue your pathetic heart out with a particular book as the focus... you get the gist.

Most of my "pending" work is in this arena.  There are always touch-ups and optimizations that I'd love to implement, but the quarter is only so long.  I'm going to have to make a poster and a presentation for this soon enough, so it's getting close to "code complete".

I've written other posts about the technology that's powering this system, so I won't touch on specific implementation here.  Suffice it to say, this is all being powered by <a href="http://www.opensource.org/docs/definition.php">Open Source</a> software: <a href="http://www.gnu.org"><acronym title="GNU's Not Unix">GNU</acronym></a>/<a href="http://kernel.org">Linux</a>, <a href="http://lucene.apache.org/solr/">Solr</a>, and <a href="http://rubyonrails.org">Ruby on Rails</a>.  Even the texts are from <a href="http://gutenberg.org">Project Gutenberg</a>.  And I think that's pretty cool.

Until next time.