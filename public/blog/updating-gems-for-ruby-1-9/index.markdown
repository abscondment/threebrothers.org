---
date:  2010-01-27
title: Updating gems for Ruby 1.9
---
<p>I recently updated two libraries for Ruby 1.9 compatibility and made them available on <a href="http://gemcutter.org" rel="nofollow">Gemcutter</a>. Both of these libraries include hefty C extensions written against the 1.8 headers.</p>

<p>After reading Evan Miller's fantastic article on <a href="http://www.evanmiller.org/how-not-to-sort-by-average-rating.html">how <em>not</em> to sort by average rating</a>, I really wanted to apply his solution. However, I quickly ran into a problem: the magical <span style="font-family:courier new,mono;">statistics2</span> library he used was nowhere to be found. At least, it wasn't available as a gem, and wasn't included in the standard distribution. Wait, you say people actually <a href="http://raa.ruby-lang.org/project/statistics2/" rel="nofollow">shared libraries before RubyGems</a>?! I guess so. I quickly updated the packaging, added Hoe support and released it as a gem&mdash;with <a href="http://github.com/abscondment/statistics2">source on Github</a> and <a href="http://gemcutter.org/gems/statistics2">gem on Gemcutter</a>.</p>

<p>At some point, I needed to do spatial clustering with more points than can comfortably run in a na&iuml;ve linear search. <a href="http://thebogles.com/blog/">Phil Bogle</a> suggested that perhaps a Voronoi diagram could be useful to me, and from this came RubyVor. RubyVor provides efficient calculation of Voronoi diagrams and Delaunay triangulation by wrapping <a href="http://ect.bell-labs.com/who/sjf/">Steven Fortune's C program</a> in a Ruby extension. It too was released as <a href="http://github.com/abscondment/rubyvor">a Github project</a> and a <a href="http://gemcutter.org/gems/rubyvor">Gemcutter gem</a>.</p>

<p>Both the libraries wouldn't compile against 1.9 headers due to changes in basic type structs. The symptom of this problem is messages like the following that spew during extension compilation.</p>

    rb_cComputation.c:39: error: 'struct RArray' has no member named 'ptr'
    rb_cComputation.c:45: error: 'struct RArray' has no member named 'len'
    rb_cComputation.c:284: error: 'struct RFloat' has no member named 'value'

<p>So what's going on here? Well, the answer is simple: Ruby 1.8 used different C structs; the member values we once accessed directly are no longer where the code thinks they ought to be. Just to illustrate, take a look at the RArray struct:</p>

    
    /* Ruby 1.8 */
    struct RArray {
      struct RBasic basic;
      long len;
      union {
        long capa;
        VALUE shared;
      } aux;
      VALUE *ptr;
    };
  
    /* Ruby 1.9 */
    struct RArray {
      struct RBasic basic;
      union {
        struct {
          long len;
          union {
            long capa;
            VALUE shared;
          } aux;
          VALUE *ptr;
        } heap;
        VALUE ary[RARRAY_EMBED_LEN_MAX];
      } as;
    };

<p>The 1.9 Array has a <em>much</em> more complicated structure. In a 1.8 extension, a programmer would often write things like <span style="font-family:courier new,mono;">RARRAY(a)->ptr</span> to iterate directly over the array via pointers. In 1.9, however, accessing the pointer is more verbose and convoluted. Since this is less than ideal, the Ruby developers simplify things with new macros in 1.9 (<span style="font-family:courier new,mono;">RARRAY_PTR(a)</span> in this case). These also provide nice a level of indirection that can allow the underlying structs to change, but the client code to function without change.</p>

<p>The solution to making these gems compatible with both versions lies in this layer of abstraction: if we can write and use Ruby 1.8 versions of certain 1.9 macros, the code will be struct-agnostic. Below is my fix for RubyVor; it's important to note that structs other than RArray and RFloat also changed, so this isn't a solution for every issue. This is a general pattern that can be used for fixing C-level struct incompatibility. You'll need to figure out the correct 1.8 version of any macros for other structs.</p>

    #ifndef RUBY_19
    #ifndef RFLOAT_VALUE
    #define RFLOAT_VALUE(v) (RFLOAT(v)->value)
    #endif
    #ifndef RARRAY_LEN
    #define RARRAY_LEN(v) (RARRAY(v)->len)
    #endif
    #ifndef RARRAY_PTR
    #define RARRAY_PTR(v) (RARRAY(v)->ptr)
    #endif
    #endif

<p>Now that I use these three macros instead of direct member access, these extensions are compatible with both Ruby versions. So have fun triangulating and crunching statistics in Ruby 1.9!</p>

