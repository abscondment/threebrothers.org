---
date:  2004-07-18
title: Cryptogram Solver
---
<p>At the risk of turning my site into a complete nerdfest, this entry is going to be totally devoted to my next programming project.</p>
<p>When I took <acronym title="Computer Science Engineering">CSE</acronym> 373, our final project involved a graph search algorithm.  This project wasn't very hard at all, considering the fact that we were given the algorithm in English / pseudo code and instructed to implement it.  This sort of algorithm (or rather, the way this sort of algorithm can use a tree to pictorally represent the search pattern) inspired me in thinking about a way to solve cryptograms with a computer program.</p>
<p>So far, here's what I've got:</p>
<ul><li>The program first reads a wordlist (or loads serialized forms of what I am about to describe) and sorts the words by length, forming an AVL Tree for each different length.  Those trees are then stored in an array based on size.  Also, the program will construct a Min-Heap of encrypted words (using the word length as the value by which they are ranked) and pass it to the search function.
 <ul><li>When the Min-Heap passed to the search function is empty, it will print out the solution it has found (if any) and exit.</li>
 <li>Otherwise, we select the smallest encrypted word by the Min-Heap operation deleteMin; this leaves us with the word we are currently investigating and the modified heap.
  <ul><li>The search function then iterates through the AVL tree correspoding to the current encrypted word's length, checking the encrypted word against every word in that list.  If the encrypted word <i>could</i> map to the current word (I.E., a previous mapping in this branch of the tree hasn't excluded a certain letter in the encrypted word from mapping to a certain letter in the test word), it updates all the encrypted words in the Min-Heap to match the new mapping.  Then it recursively calls the search function, passing it the new Min-Heap.  After the new branch of the search tree has completed, the mapping for this word is removed from the Min-Heap and the next word is tested.</li>
  </ul></li>
 </ul></li>
</ul>
<p>Now to implement this beast...</p>
