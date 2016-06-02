---
date:  2008-01-15
title: Vector Difference Functions
---
<h3>Problem Formulation</h3>

Given vectors <em><b>a</b></em> and <em><b>b</b></em> of identical (but arbitrary) dimension, what's the best way to tell how "different" the vectors are?

<h4>Simple distance function</h4>

There are two different ways one can approach this problem.  The trivial approach is to calculate an absolute distance between the two vectors.  This works especially well in smaller dimensions:

<blockquote>
  <em><b>a</b></em> = [0, 5]<br/>
  <em><b>b</b></em> = [5, 0]
</blockquote>

If we treat these 2-dimensional vectors as points on a plane, there's a simple <a href="http://en.wikipedia.org/wiki/Euclidean_distance#Two-dimensional_distance">Euclidean two-dimensional distance function</a> that describes the difference between <em><b>a</b></em> and <em><b>b</b></em>.  This distance function scales to an arbitrary number of dimensions.  Our distance for <em><b>a</b></em> and <em><b>b</b></em> is:

<blockquote><p>&radic;<span style="border-top:1px solid #000;">((0 - 5)<sup>2</sup> + (5 - 0)<sup>2</sup>)</span> = <b>7.07</b> (or 5 * &radic;<span style="border-top:1px solid #000;">2</span>)</p></blockquote>

This naturally has an equivalent in any <a href="http://en.wikipedia.org/wiki/Euclidean_space">Euclidean space</a> of any dimension.  For many applications of vector math, however, a pure distance calculation becomes less interesting as the dimension of the space grows.  Consider the following 5-dimensional vectors:<blockquote>
<em><b>c</b></em> = [1, 1, 1, 1, 1]<br/>
<em><b>d</b></em> = [1, 0, 0, 0, 0]<br/>
<em><b>e</b></em> = [9, 9, 9, 9, 9]
</blockquote>

This gives us the following distances:

<blockquote>
<em><b style="border-top:1px solid #000;">cd</b></em> = <b>2</b><br/>
<em><b style="border-top:1px solid #000;">ce</b></em> = 4 * &radic;<span style="border-top:1px solid #000;">20</span> = <b>17.889</b><br/>
<em><b style="border-top:1px solid #000;">de</b></em> = 2 * &radic;<span style="border-top:1px solid #000;">97</span> = <b>19.698</b>
</blockquote>

<h4>Angular difference function</h4>

In lower dimensions, the direction of a vector is a very simplistic construct.  The second dimension is made of components that are either up or down, left or right.  Naturally, one can differentiate between vectors in this manner, but it's often not as meaningful as a regular distance calculation.  Referring back to vectors <em><b>a</b></em> and <em><b>b</b></em>, we can quickly calculate that (assuming [0, 0] as the origin) they are 90&deg; apart &mdash; in a word, orthogonal.

We can calculate an angle between two N-dimensional vectors as follows (for more detail, read about the <a href="http://en.wikipedia.org/wiki/Euclidean_space#Euclidean_structure">structure of Euclidean spaces</a>):

<blockquote><p><em>&theta;</em> = cos<sup>-1</sup>((<b>x</b> &bull; <b>y</b>) / (||<b>x</b>||*||<b>y</b>||))</p></blockquote>

For our 5-dimensional vectors, this gives us the following angular relationships:

<blockquote>
a(<b><em>c,d</b></em>) = <b>63.435&deg;</b><br />
a(<b><em>c,e</b></em>)  = <b>0&deg;</b><br />
a(<b><em>d,e</b></em>) = <b>63.435&deg;</b>
</blockquote>

<h3>Which function to choose?</h3>

The angular and distance relationships differ greatly with this set of vectors.  Although the distance between <em><b>c</b></em> and <em><b>e</b></em> is almost as large as that between <em><b>d</b></em> and <em><b>e</b></em>, the angle between the former pair is 0.  In other words, <em><b>c</b></em> and <em><b>e</b></em> point <em>exactly</em> the same direction, and differ only in magnitude.  Thus, depending on the real-world relationships that one might be modeling with these two vectors, they might be considered identical.  <em><b>d</b></em> is the oddball from the angular perspective.

"What's a practical use of this?", you ask.  Imagine evaluating candidates in a political race based on how they appropriated money in the past.  Take as many differentiating spending categories as can be imagined; each category represents a dimension in our vector, and the amount spent by a given candidate is the magnitude in that direction traveled by the candidate.

So, we can envision the following political arena (cost in millions; stereotypes in spades):

<table border="1" style="text-align:center;">
  <tr>
    <th>Candidate</th>
    <th>Education</th>
    <th>Defense</th>
    <th>Health Care</th>
    <th>Raising Own Pay</th>
    <th><a href="http://zapatopi.net/cascadia/">Republic of Cascadia</a></th>
  </tr>
  <tr>
    <td>Joe Greedy</td>
    <td>0</td>
    <td>0</td>
    <td>0</td>
    <td>1,000</td>
    <td>0</td>
  </tr>
  <tr>
    <td>Leftist Len</td>
    <td>450</td>
    <td>100</td>
    <td>590</td>
    <td>100</td>
    <td>10</td>
  </tr>
  <tr>
    <td>Ron Rightwing</td>
    <td>100</td>
    <td>666</td>
    <td>200</td>
    <td>100</td>
    <td>50</td>
  </tr>
  <tr>
    <td>Cascadian Callie</td>
    <td>1</td>
    <td>1</td>
    <td>1</td>
    <td>0</td>
    <td>5</td>
  </tr>
</table><br />

Practically speaking, how similar are these candidates to each other?  Using our two methods for calculating vector differences, we get two very different answers:<br />

<table border="1" style="text-align:center;">
  <tr><th colspan="5">Difference between candidates based on Euclidean distance</th></tr>
  <tr>
    <td>&nbsp;</td>
    <th>Joe Greedy</th>
    <th>Leftist Len</th>
    <th>Ron Rightwing</th>
    <th>Cascadian Callie</th>
  </tr>
  <tr>
    <th>Joe Greedy</th>
    <td>0</td>
    <td>1170.8</td>
    <td>1142.8</td>
    <td>1000.0</td>
  </tr>
  <tr>
    <th>Leftist Len</th>
    <td>1170.8</td>
    <td>0</td>
    <td>772.37</td>
    <td>753.89</td>
  </tr>
  <tr>
    <th>Ron Rightwing</th>
    <td>1142.8</td>
    <td>772.37</td>
    <td>0</td>
    <td>709.68</td>
  </tr>
  <tr>
    <th>Cascadian Callie</th>
    <td>1000.0</td>
    <td>753.89</td>
    <td>709.68</td>
    <td>0</td>
  </tr>
</table><br />

<table border="1" style="text-align:center;">
  <tr><th colspan="5">Difference between candidates based on angular difference</th></tr>
  <tr>
    <td>&nbsp;</td>
    <th>Joe Greedy</th>
    <th>Leftist Len</th>
    <th>Ron Rightwing</th>
    <th>Cascadian Callie</th>
  </tr>
  <tr>
    <th>Joe Greedy</th>
    <td>0</td>
    <td>82.393</td>
    <td>81.919</td>
    <td>90.000</td>
  </tr>
  <tr>
    <th>Leftist Len</th>
    <td>82.393</td>
    <td>0</td>
    <td>63.463</td>
    <td>72.681</td>
  </tr>
  <tr>
    <th>Ron Rightwing</th>
    <td>81.919</td>
    <td>63.463</td>
    <td>0</td>
    <td>71.153</td>
  </tr>
  <tr>
    <th>Cascadian Callie</th>
    <td>90.000</td>
    <td>72.681</td>
    <td>71.153</td>
    <td>0</td>
  </tr>
</table><br />

<h4>Analysis</h4>

What can we glean from these tables?  Let's first take a look at one of the edge cases.  Joe Greedy, whom I hope will be beaten soundly in this election, gives money to no one but himself.  According to the angular difference, he and Cascadian Callie have nothing whatsoever in common.  This is because Callie is a wholly virtuous individual, giving no money to herself whatsoever.  Their vectors are completely orthogonal.  However, Callie appears to be the <em>nearest</em> candidate to Joe (i.e. of Joe's neighbors, they have the smallest difference) when considered with a distance function.

What!?  That's right &mdash; since Callie is an under-funded independent candidate, her vector is small in magnitude when compared to the other candidates' vectors.  She's the &quot;closest&quot; of Joe's neighbors, even though the two are ideological opposites.  Joe's vector is one-dimensional, and is closer to the origin (represented by [0,0,0,0,0]) than to any of the other candidates.  This is because the other candidates' combined moves span the entire 5-dimensional space.  Callie's moves, however, are the <em>smallest</em> in magnitude, so has moved the least distance away from Joe despite being the only one who's completely orthogonal in direction (i.e. ideology).

Note also the difference between Ron Rightwing's and Leftist Len's numbers as generated by the different functions.  The distance functions put both closer to Callie than each other, even though neither really show a ton of material support to the Cascadia movement (4.3% and 0.8% of all money, respectively).  The angular function, however, puts them as each other's nearest neighbor followed by Callie.  It recognizes that they both support Education, Defense, and Health Care to varying degrees.  It also takes into account the fact that Callie spends a little bit on those three all-important issues but that Joe does not; this pushes Joe into last place related to all three (where he belongs, that jerk).

<h3>Summary</h3>

The traditional distance function is always useful, but angular difference is often a better suited tool for the job.  The political candidate similarity chart is one such application.  I'd love to create an angular similarity graph between Federal politicians based on a large number of political dimensions.  It would be very useful to see &mdash; outside all of the jockeying and positioning &mdash; what things politicians actually vote for, and which people vote most similarly.  I believe the results would be surprising.

<h4>Source Code</h4>

I developed a really simplistic Vector class (in Ruby) to help me do these calculations, and I'm releasing it under the <a href="http://opensource.org/licenses/mit-license.php">MIT license</a>.  It's definitely not production-ready, is unfit for any use, <em>et cetera</em>, <em>et cetera</em>.

<ul>
  <li><a href="http://threebrothers.org/brendan/blog/files/vector.rb">vector.rb</a></li>
  <li><a href="http://threebrothers.org/brendan/blog/files/generate.rb">generate.rb</a></li>
</ul>
