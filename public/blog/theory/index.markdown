---
date:  2004-02-25
title: Theory
---
I was just reading on <a href="http://bitconjurer.org/">Bram Cohen's website</a> about <a href="http://bitconjurer.org/simple_public_key.html">a simple public key encryption algorithm</a> that sounds like it would be fun to try and implement.

On a related tangent, I've been trying to come up with an algorithm that would solve simple cryptogram ciphers<sup><a href="#foot1">1</a></sup> in a reasonable amount of time.  When computer get faster, this will simply be a matter of checking all possible answers and printing out the one that is statistically most accurate; however, the <a href="http://www.google.com/search?hl=en&amp;ie=UTF-8&amp;oe=UTF-8&amp;q=26%21">number of possible alphabet combinations</a> is currently a little long for processing, especially in Java.

My idea is to focus on the smaller words (2-4 letters): using a dictionary of smaller words, the number of possible alphabets containing all english words that match the pattern provided is a lot smaller than all possible random combinations.  After this first pass, we will know a handful of letters.  Subbing them into the rest of the unknown code will make it feasible to sort lists of larger dictionary words according to the way they match those known letters.

Conceptually, this is pretty easy.  The hard part would be implementing it; also, I need a good dictionary database.  Anyone (meaning, Ryan mainly) know how to access the Microsoft Word dictionary files?  That would be pretty cool.  Or maybe I can make it interface with <a href="http://dictionary.reference.com/">http://dictionary.reference.com/</a>... hmmm...

<a id="foot1"></a>
<sup>1</sup> A cryptogram substitutes a random letter (that has not been used already) for the current letter in the alphabet.  Example:

ABCDEFGHIJKLMNOPQRSTUVWXYZ
BDEFGIJKLMOPQUVWXYZTRASHCN
