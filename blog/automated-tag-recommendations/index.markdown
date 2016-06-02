---
date:  2007-03-06
title: Automated Tag Recommendations
---
I've posted before about an nice linguistics technique that I think has a huge number of interesting applications.  It's described in Cavnar and Trenkle's 1994 paper on <a href="http://citeseer.ist.psu.edu/68861.html">N-Gram based text categorization</a>; more than a decade later, it's still a really cool idea that warrants exploration.  Since it's time for Jobster's March "Innovation Week," I decided to finally do some exploring.

I'm working on a service that accepts text&mdash;say, from a user profile or a r&eacute;sum&eacute;&mdash;and uses that text to return a limited set of probable tags.  A service like this wouldn't be uniquelly useful to a job search site; really, it could be rather useful to any site that implements tagging and collects text in the way of user profiles.

I think this could be particularly useful for Jobster in two specific areas.  First, a user creating a new profile might add a r&eacute;sum&eacute; and be instantly provided with a set of likely tags.  Likewise, users who have not tagged themselves and yet have uploaded r&eacute;sum&eacute; could have the tags returned by this service attributed to them.  Second (and more important, in my opinion), this could allow Facebook users of the <a href="http://washington.facebook.com/group.php?gid=2229765339">Jobster Career Center</a> to see more applicable job postings immediately.

I began by creating a few really basic text profiles for eight different tags: <a href="http://jobster.com/find/people/about/account+management">account management</a>, <a href="http://jobster.com/find/people/about/creative">creative</a>, <a href="http://jobster.com/find/people/about/human+resource+management">human resource management</a>, <a href="http://jobster.com/find/people/about/java">java</a>, <a href="http://jobster.com/find/people/about/marketing">marketing</a>, <a href="http://jobster.com/find/people/about/rails">rails</a>, <a href="http://jobster.com/find/people/about/seattle">seattle</a>, and <a href="http://jobster.com/find/people/about/software+developer">software developer</a>.  I created the text profiles using text (including r&eacute;sum&eacute;s) from the first 10 user profiles that appeared for each tag.  Obviously, this is a gross approximation: the <a href="http://jobster.com/find/people/about/software+developer">software developer</a> tag has (as of now) 113 users; <a href="http://jobster.com/find/people/about/creative">creative</a> has 2,759.  A real profile will need to account for every user's text.

I then created two sample user profiles: one using <a href="http://threebrothers.org/brendan/resume/">my r&eacute;sum&eacute;</a>, the other using text from <a href="http://jobster.com/people/jasongoldberg">Jason Goldberg's Jobster Profile</a>.  My profile should correlate strongly to the software side of things, while Jason's would likely go towards the business side.  Here are the numbers from the rough (and I mean <b>rough</b>) prototype:

    Brendan:
    203810  rails
    213947  software-developer
    228487  java
    250153  creative
    256944  seattle
    267096  marketing
    280711  account-management
    282841  hrm

    Jason:
    292370  seattle
    299983  account-management
    303124  creative
    306446  rails
    308225  marketing
    310352  hrm
    313499  java
    318043  software-developer

The number in front of the tag indicates how different the user's profile is from the tag's text profile; a small number indicates less difference, while a larger number indicates large differences.

It's interesting to note that Jason's suggested tags all are less strongly correlated than mine are; I attribute this to relative sizes of our text profiles: my r&eacute;sum&eacute; totals roughly 5.3K of text, while only 3.2K worth of text exists in Jason's profile.  The more text, the greater the accuracy.

It's also interesting to note the prominence of "rails" in Jason's recommended tags.  I was perplexed by this, until I noticed that (as of now) five of the top ten <a href="http://jobster.com/find/people/about/rails">rails people</a> work for Jobster.  Because of the unequal representation, this automatically biases profiles with terms relating to "Jobster" towards the rails tag.  Considering text from all 52 rails people would resolve this.

My next move is to create a complete text profile for all tags used by Jobster users.  This will take a lot of text processing, and I'll have to figure out some good way to automatically extract text from both Word Documents and PDFs.  Once that profile is completed, I'll be able to demonstrate a top 50 suggested tags list based on a given group of text.

