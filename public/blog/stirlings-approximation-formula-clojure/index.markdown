---
date:  2010-11-24
title: Stirling's approximation in Clojure
---
In my free time, I've been working through [Probability Theory: A Concise Course](http://store.doverpublications.com/0486635449.html) by Y.A. Rozanov.
The first chapter contains a great factorial approximation that anyone doing
computer-based statistics or combinatorics ought to know:

![n! &#x223C; &#x221A;(2&pi;n) * (n/e)^n](http://threebrothers.org/brendan/blog/stirlings-approximation-formula-clojure/stirlings-approximation.png)

This is **Stirling's Approximation**. As *n* grows, the relative error of this
function compared to *n!* gets smaller and smaller. More formally, the
**&#x223C;** symbol expresses asypmtotic equivalence, meaning that when A(n)
&#x223C; B(n),

![lim n->&infinity; A(n)/B(n) = 1](http://threebrothers.org/brendan/blog/stirlings-approximation-formula-clojure/sim.png)

I was curious about the actual behavior of this formula, so I decided
to plot the expected convergence. To do this, I wrote up simple Clojure versions
of both functions and charted the expected convergence using Incanter.

<script src="https://gist.github.com/715040.js?file=stirling-naive.clj"></script>
<noscript>
  <pre>
    <code>
(use '(incanter core charts io latex))

(defn stirling [#^Integer n]
  (* (Math/sqrt (* 2 n Math/PI))
     (Math/pow n n)
     (Math/pow Math/E (* -1 n))))

(defn fact [#^Integer n]
  (reduce * (range 2 (inc n))))

(let [n-vals (range 5 1000)]
  (view
   (xy-plot n-vals
            (map #(- (/ (fact %) (stirling %)) 1.0) n-vals)
            :x-label "n"
            :y-label "factorial(n)/stirling(n) - 1")))
    </code>
  </pre>
</noscript>
  
The graph produced by this doesn't exactly pass muster.
                
![Hmm, that doesn't look right.](http://threebrothers.org/brendan/blog/stirlings-approximation-formula-clojure/chart-glitch.png)

We've been bit by one of the classic problems of numerical computing: the way
that a number is represented internally limits what can be done with it. In our
case, we've exceeded the range of values that a Java Double can handle. It has 8
bytes split into a 52-bit mantissa, an 11-bit exponent, and a single sign bit
(<a href='http://www.mobilefish.com/tutorials/java/java_quickguide_double.html' rel='nofollow'>in detail</a>).
The max value it can hold is 1.7976931348623157&#xd7;10<sup>308</sup>. Once we
exceed that value, everything is simply "Infinity".

<script src="https://gist.github.com/715041.js?file=overflow.clj"></script>
<noscript>
  <pre>
    <code>
user> (fact 200)
788657867364790503552363213932185062295135977687173263294742533244359449963403342920304284011984623904177212138919638830257642790242637105061926624952829931113462857270763317237396988943922445621451664240254033291864131227428294853277524242407573903240321257405579568660226031904170324062351700858796178922222789623703897374720000000000000000000000000000000000000000000000000
user> (class (fact 200))
java.math.BigInteger

user> (stirling 200)
Infinity
user> (class (stirling 200))
java.lang.Double
    </code>
  </pre>
</noscript>

Clojure magically moves from Integer arithmetic to BigInteger arithmetic
when we overstep the Integer upper bound of 2<sup>31</sup>-1. But we get no such
love from the functions in java.lang.Math.*, which quickly (at n=144) overflow
to Infinity.

Now, the entire point of this function is to have a fast approximation of the
factorial **for large _n_**, so this is an issue that we need to overcome. The
na&iuml;ve version is actually completely useless, since it only functions
for small *n*.

So let's fix it.

We need to convert our function to use an arbitrary precision decimal type.
As far as I can tell, Math.PI only comes in double precision. We'd need to have
an *n* of, oh, 9,223,372,036,854,775,807 before we exceeded the Double range
and needed to change the way we compute first expression. I don't think anyone
is actually going to seriously try doing factorials that large, but if you are,
you can make use of this [free BigSquareRoot class that uses BigDecimals](http://www.merriampark.com/bigsqrt.htm).

For my purposes, only the exponentiation, division, and multiplication in the
second expression need to be converted. Java has a handy BigDecimal class that
fits the arbitrary-precision bill:

<script src="https://gist.github.com/715046.js?file=stirling-big.clj"></script>
<noscript>
  <pre>
    <code>
(defn stirling-big [#^Integer n]
  (.multiply
   (BigDecimal. (Math/sqrt (* 2 Math/PI n)))
   (.pow (.divide (BigDecimal. n)
                  (BigDecimal. Math/E)
                  java.math.MathContext/DECIMAL128)
         n java.math.MathContext/DECIMAL128)))
    </code>
  </pre>
</noscript>

We also need to use BigDecimal division in the comparison function, but I'll
leave that as an exercise for the reader. The outcome is quite pleasing from
the numerical error standpoint:

![That's better](http://threebrothers.org/brendan/blog/stirlings-approximation-formula-clojure/chart-good.png)

You can see that as *n* gets larger, the ratio of the functions asymptotically
approaches 1. The relative error of Stirling's approximation shrinks with larger
*n*, which is great for most applications. The absolute error grows, but the
rate at which it grows is smaller than the rate at which the actual value grows.

And the performance is great, too! Check out the differences:

![Performance for the first 64 values of n](http://threebrothers.org/brendan/blog/stirlings-approximation-formula-clojure/time-short.png)
![Performance for all values of n](http://threebrothers.org/brendan/blog/stirlings-approximation-formula-clojure/time-full.png)

The raw factorial function is superior for small *n*, which is to be expected.
The factorial function has noticeable performance perturbations in the local
view, but these mostly disappear in the full view. The factorial function seems
to perform in quadratic time relative to *n*, while Stirling's formula has a
very low constant cost.

So remember Stirling's formula if you find yourself computing large factorials.

*Updated 2010-11-25 07:48 to clarify **relative error** versus **actual value**. Thanks to David Karapetyan for pointing out the discrepency.*

