---
date:  2009-12-31
title: Solving cryptograms in Clojure
---
<p>
  While working on <a href="http://projecteuler.net/index.php?section=problems&amp;id=96" rel="nofollow">Project Euler</a>, I discovered Peter Norvig's elegant <a href="http://norvig.com/sudoku.html">Sudoku solver</a> implementation. Although the associated <a href="http://ravimohan.blogspot.com/2007/04/learning-from-sudoku-solvers.html" rel="nofollow"><acronym title="Test-driven development">TDD</acronym> discussion</a> brought me <a href="http://pindancing.blogspot.com/2009/09/sudoku-in-coders-at-work.html" rel="nofollow">much humor</a>, it was the efficacy and flexibility of constraint propagation and search that really stuck with me. As I implemented this solver in Clojure, I had a small epiphany: one could also model <a href="http://en.wikipedia.org/wiki/Cryptogram" rel="nofollow">cryptograms</a> as a constraint problem and find a solution in a nearly identical manner. Here is my account of implementing such a solution.
</p>

<h2>Formulation</h2>
<p>
  The problem is rather different than Sudoku. In some ways, it's simpler: we don't need to figure out which rows, columns, and boxes are affected by each state change. That eliminates a lot of bookkeeping, which is fortunate; figuring out how to compare a set of partially decrypted words to see whether they match an encrypted word and the current puzzle state is enough of a hassle.
</p>
<p>
  I want to list the possible solutions for an encrypted word, and then use search and constraint propagation to eliminate these possibilities. To find the solution list, I'll convert each word into what I term its <em>base form</em>. This is done by replacing each character with a representation of its order of appearance. For example, both "seas" and "that" become "ABCA". Using integers naturally limits this technique to words with 10 or fewer distinct characters, so I have opted to use upper-case characters instead. To make a comprehensive list, I group all words in <span style="font-family:courier new,mono;font-size:0.8em;">/usr/share/dict/words</span> by their base form to create a dictionary keyed on base forms. We can then look up candidate solutions using the base form for any encrypted word. This solution is similar to the one required by the ever popular <a href="http://www.google.com/search?q=anagram+interview+question" rel="nofollow">anagram interview question</a>. It quite naturally introduces a limitation to our solver; namely, in order to decrypt a word it must appear in the computer's word list. I find this list on a standard *NIX distribution to be quite sufficient.
</p>
<p>
  In Clojure, a single entry in the base form dictionary looks something like this:
</p>
<p style="font-family:courier new,mono;font-size:0.8em;margin-left:2em;">
  {"ABBABC" ["beebes" "inning" "peeped" "peeper" "teeter"]}
</p>
<p>
  When an encrypted word has only one candidate on its list, we can consider it solved and propagate that choice. If we encounter a state where an encrypted word has an empty candidate list, we know we've propagated impossibly conflicting constraints. Unlike the Sudoku problem, simply maintaining a list of potential valid states isn't enough. We really need to store a list of all applied decryption rules, and use them as follows.
</p>

<h2>Rules and eliminating candidates</h2>
<p>
  Say we have the following encrypted word/candidate list with some yet-to-be-applied rules:
</p>
<p style="font-family:courier new,mono;font-size:0.8em;margin-left:2em;">
  ;;; Candidates<br/>
  ("vkkvkl" ["beebes" "inning" "peeped" "peeper" "teeter"])<br/><br/>
  ;;; New rules<br/>
  {\v \p}
</p>
<p>
  The new rules say we should translate every encrypted "v" to a "p". We can integrate this into the base form and generate a partially decrypted base form for the encrypted word. We can then use that to further eliminate candidates.
</p>
<p style="font-family:courier new,mono;font-size:0.8em;margin-left:2em;">
  ;;; New base form for "vkkvkl", given our rules<br/>
  "pBBpBC"<br/><br/>
  ;;; New hybrid base forms for existing candidates<br/>
  ["ABBABC" "ABBABC" "pBBpBC" "pBBpBC" "ABBABC"])<br/><br/>
  ;;; New candidates<br/>
  ("vkkvkl" ["peeped" "peeper"])
</p>

<h2>Propagation</h2>
<p>
  Propagating the constraints is straightforward. We follow four simple rules:
</p>
<ol>
  <li>If any encrypted word has no candidates, we are in an inconsistent state. Return nil.</li>
  <li>Otherwise, if <em>all</em> words have only one candidate, return. We've found a solution!</li>
  <li>Otherwise, if any encrypted word has only one candidate, accept that candidate as a solution. Update the existing rules in light of this solution and apply them to all the other candidates recursively.</li>
  <li>Otherwise, return what we have so far &mdash; all words still have more than one candidate, so we have deduced all that we can. We'll fall back on search to progress further.</li>
</ol>

<h2>Search</h2>
<p>
  Now that we have the basic tools for modeling and enforcing the constraints, we can easily write a function to fully apply given rules to a set of candidates.
  However, as seen above in point 4, we can encounter a state where we've eliminated some candidates but have not found a solution. Indeed, this is the <em>initial</em> problem state. In order to begin (and later to progress), we need to choose an encrypted word and one of its candidates and run with that pair. If it's an invalid pairing, we will reach an inconsistent state and backtrack to try the next pairing. This is a basic depth-first search. Our search will return the first valid result (where "valid" means all encrypted words are solved). We can optimize the search by always starting with first candidate of whichever <em>unsolved</em> encrypted word has the fewest number of candidates &mdash; this trims the search tree fairly well. We can also ensure that the set of decryption rules is actually changed by a given candidate before attempting to search further.
</p>

<h2>Concluding thoughts</h2>
<p>
  Cryptograms often have many, many solutions. The first solution found by search is often <em>not</em> the most correct one &mdash; especially in terms of human language. There are some things that could be done in the search function to improve the chance of correctness: e.g. picking the next candidate by word/letter frequency. A more advanced system could use some <acronym title="Natural Language Processing">NLP</acronym> techniques to determine whether the decrypted solution passed as human language. All of these are moot, considering that the benefit provided wouldn't outweigh complexity they would add to this simple algorithm.
</p>

<h3>Caveat developer</h3>
<p>
  I'm providing my implementation as a reference. Given that I'm a novice Clojurer, it's liable to be hideous and non-idiomatic. I found working in Clojure to be extremely satisfying, both for this project and for the Sudoku one. My solution is a mere 132 lines (whitespace/comments included), so this is obviously a very expressive language.
  I've been very impressed by flexibility of its <a href="http://technomancy.us/132">persistent data structures</a> and its <a href="http://clojure.org/lazy" rel="nofollow">lazy evaluation</a>. These make it a very powerful language, and it's definitely a tool I want to sharpen.
</p>
<p><a href="/files/cryptogram.clj">cryptogram.clj</a></p>

