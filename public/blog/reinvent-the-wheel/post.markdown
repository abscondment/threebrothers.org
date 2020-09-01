I spent a few days of last week pursuing a novel activity: building a bicycle wheel. I followed Sheldon Brown's [excellent wheelbuiding guide](http://www.sheldonbrown.com/wheelbuild.html), and I've been quite pleased with the results. Thus far the wheel has been smooth and true, and I feel rather enlightened by the whole experience.

This marked a milestone of sorts in my journey as an amateur mechanic. It's one of those (seemingly) daunting tasks that (seemingly) impresses others once completed: &quot;Wow, and you actually rode on that without experiencing some horrific and injurious crash? Cool!&quot; But it also produces a fair amount of skepticism: &quot;Why not just buy one?&quot;, &quot;Wow, seems like a lot of unnecessary work...&quot; and so on.

<div style="text-align:center;"><img src="//threebrothers.org/brendan/images/reinvent-wheel.jpg" alt="Lacing the wheel." /><br/><em>Lacing the wheel.</em></div>

There were, quite naturally, a few jokes about me reinventing the wheel. And these set me to thinking.

I've seen firsthand what reinventing the wheel means in the software world. I once spent a few weeks fixing bugs in a Lucene-based search system. I say &quot;based&quot; because most of Lucene's sensible, extensible default implementations had been ripped out and completely rewritten in some crazed attempt at optimization.

From my latecomer's viewpoint, this seemed like a classic case of [<abbr title="Not Invented Here">NIH</abbr> syndrome](http://en.wikipedia.org/wiki/Not_Invented_Here). It cost our company quite a few man-hours to undo the unnecessary complexity &ndash; reverting to *simple* subclasses of most of Lucene's internals fixed most of our bugs, and it made the thing that much easier to test and maintain.

## A Different Approach

Back to wheels.

In the end, I saved money over buying a new wheel &ndash; even when considering the price of two new chain whips (a one-time tool purchase). I traded sleep for mechanical knowledge. In both regards, I feel that I came out ahead on the very first wheel; with a lifetime of cycling (and therefore broken wheels to replace) ahead of me, I'm certain that this was a wise move.

<div style="text-align:center;"><img src="//threebrothers.org/brendan/images/ancient-wheel.jpg" alt="Credit: http://www.flickr.com/photos/chromatic_aberration/3828921733/" title="Credit: http://www.flickr.com/photos/chromatic_aberration/3828921733/" /><br/><em>Ancient wheel.</em></div>

But this brings us to an interesting juxtaposition. To your average, non-mechanic cyclist, I undertook an extraordinary amount of effort and personal risk to create something that is machine manufactured *en masse* and readily available at any bike shop. I reinvented the wheel, in both the literal and the clich&eacute;d sense.

This is the standard response one has when looking at an unknown, black box system. But when I look at my bike I see, as it were, a semi-transparent box at a higher resolution. I [built my Vitus 979 from scratch](http://threebrothers.org/brendan/blog/vitus-979-reborn/), so each subsystem and component jumps out. I quickly jumped through these mental states:

<div class="codeBlock"><em>My rim is broken. My older frame and 8-speed Dura-Ace drivetrain limits my rear hub choices, so I'm not going to be able to buy a brand-new wheel replacement. It's also questionable whether I'll find any 8-speed Dura-Ace wheelsets, new or used. It'd be expensive to upgrade the whole drivetrain, and I have an awesome, <a href="http://www.sheldonbrown.com/k7.html#uniglide">rare Uniglide hub</a>. I should just learn how to build a wheel; that way, I can get a really nice rim, too, and come away from this with a better bike than before.</em></div>

## Not Understood Here

NIH is real. It's dangerous to think that you always need to create a new and novel implementation of readily available systems. No one creating the next consumer web startup should begin by implementing a database server from scratch. But, **it's equally dangerous to be ignorant of how these systems work**. This exactly is why programmers are often asked implement data structures like hash tables during interviews, but in practice almost always should use a native implementation thereof.

The database example is rather salient: I worked for a company that started its metadata system with a vanilla MySQL backend, but later added spellchecking and autocorrection via a native [Levenshtein distance](http://en.wikipedia.org/wiki/Levenshtein_distance) function. Rails provides another great example. It can be used like a black box, and you can build a functioning website without ever taking a look inside. But you'll always be at a disadvantage to the person who can quickly trace a behavior into some Rails internal and extend its functionality.

<div style="text-align:center;"><img src="//threebrothers.org/brendan/images/forces-wheel.jpg" alt="Credit: http://cozybeehive.blogspot.com/2010/03/jobst-brandt-part-v.html" title="Credit: http://cozybeehive.blogspot.com/2010/03/jobst-brandt-part-v.html" /><br/><em>Understanding the forces in play on a bicycle wheel.<br/>From </em><a href="http://www.amazon.com/Bicycle-Wheel-3rd-Jobst-Brandt/dp/0960723668">The Bicycle Wheel</a><em> by Jobst Brandt.</em></div>

Don't put your black boxes on a pedestal as if they can never be opened &ndash; this behavior is just [another form of knowledge debt](http://nathanmarz.com/blog/your-company-has-a-knowledge-debt-problem.html). Don't forgo learning about and tinkering with a system just because it's established. In this regard, reinventing is good practice &ndash; in fact, I'd conjecture that is where most innovation originates.

Paul Graham recently wrote that *[&quot;if people don't think you're weird, you're living badly*&quot;](http://www.paulgraham.com/addiction.html). Abstraction is incredibly useful, but it's invaluable to *also* have a deep, systemic knowledge of the lower layer. People default to having only a shallow, cursory understanding of the things they depend on. But I see a definite advantage to being weirdly interested in the innards. And very often one must re-walk the paths of a device's invention to obtain this level of understanding.

So, learn little by little about the systems you use daily. If you use open source software, you'll find this to be rather straightforward, and there will almost always be another enthusiastic person available to lend a hand. You'll find the accretions of knowledge to be invaluable; they'll color the way you approach problems and the solutions you recognize.

Oh, and please don't look at me funny if I ever mention my latent desire to build a [homebrewed steam engine and alternator](http://www.otherpower.com/steamengine.shtml).
