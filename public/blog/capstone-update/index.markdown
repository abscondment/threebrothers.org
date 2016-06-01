---
date:  2007-02-07
title: Capstone Update
---
It's been a while since I've posted an update about TomeTracker, my Informatics Capstone Project.  So, here goes.

I've learned the basics of the Rails framework, and (as I've indicated before) I'm <em>in love</em>.  I've modeled the basic data needed by the system, and it's functional in the following ways:
<ul>
	<li style="margin-bottom:1em;"><b>User registration and account maintenance.</b>  Registration works, and users are able to upload a personal photo, edit profile details, and choose a privacy level.  This was <em>really</em> easy to accomplish, thanks to Rails' ActiveRecord method of creating Models.</li>
	<li style="margin-bottom:1em;"><b>Basic library creation.</b>  Using Amazon.com's web service platform, users can search for books they own and link them to existing texts in the database.</li>
	<li style="margin-bottom:1em;"><b>Automated Solr updates.</b>  Rails allows a really cool addition to the <acronym title="Model View Controller">MVC</acronym> framework: <b>Observers</b>.  An Observer monitors Models, and allows additional code to be executed when the Model changes state.  The theory behind this is that some logic exterior to the Model's purview might be related directly to the Model's state; instead of placing that code <em>inside</em> the Model, a separate "observing" entity is created that exists separately.  In practical terms for my project, this system is used to update the Solr search indices.  When a LibraryEntry object is created or destroyed, a process is triggered that updates Solr by either removing or adding the associated User's id to the given document.</li>
	<li style="margin-bottom:1em;"><b>Speaking of Solr...</b>  I've determined how personalized search will be implemented.  The Solr index will contain a hidden search field: user_id.  A user who has indicated that a given BookRecord is part of his or her library will be listed by id in this field.  All searches will tacitly be enclosed as follows: <em>user_id:<b>user's id</b> AND (<b>given query</b>)</em>, thus restricting results to books that are within the given user's library.</li>
</ul>

So, the main functionality of my project is nearly complete!  Users will be able to create their libraries, associate books to texts, and perform fulltext searches!  That's pretty exciting.  Next steps involve working out usability and making the search results <em>deeper</em> by splitting the full text into sections and using Solr's highlighting feature to create a <a href="http://pluggd.com">Pluggd-like</a> heatmap of result locations.  Granted, this project is more of a proof-of-concept than anything else, so questions about the scalability of this type of indexing will remain unanswered.  Donald Knuth is quoted as saying "Premature optimization is the root of all evil"; while that certainly doesn't mean that <em>lack</em> of optimization leads to good, it lends credence to my ignoring of the potential problem.

Until next time.
