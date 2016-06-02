---
date:  2010-11-16
title: Facebook Connect, IE, and the Mysterious IFrame
---
The Facebook Connect JavaScript does some really neat things to
function the way it does, but one of its behaviors is unexpected and
downright buggy. When attempting to establish a cross-domain
communication channel in Internet Explorer (IE8, at least &ndash;
perhaps not the others), it loads a duplicate copy of the current page
in an IFrame. That's right &ndash; IE8 users attempt to make two hits
to the same page for a single view.

## A tale of broken CAPTCHAs

This behaviour is entirely undocumented. I mean, go ahead &ndash; check
<a href='http://developers.facebook.com/docs/reference/javascript/' rel='nofollow'>the Javascript SDK</a>
&ndash; you won't find any mention of it. It's a really bad
behavior, too. If you have Facebook Connect (or a Like button, for
that matter) on any page that has some transient state (say, a CAPTCHA
that gets invalidated and regenerated every time the page loads),
loading the page a second time can invalidate the version that the
user actually interacts with.

This was the case for our production user registration flow for a long
time. The first hit displayed an image for one CAPTCHA, and the second
hit surreptitiously invalidated it so that there was no possible way
the user could solve the CAPTCHA. Thanks, guys.

The reason for this double hit is straightforward. The [same-origin policy](http://www.w3.org/Security/wiki/Same_Origin_Policy) 
restricts how scripts can communicate with different
domains. For the most part, interesting interactions are
restricted. The whole idea of Facebook Connect is predicated on the
idea that their JavaScript will run on your site and provide you with
functionality from a different domain, so they had to find a way to
bypass the restrictions. There are, quite naturally,
[some tricky ways to make things work using IFrames](http://softwareas.com/cross-domain-communication-with-iframes). But
following the ever-present JavaScript mantra, Not All Browsers Will
Behave the Same Way. I actually doubt whether browsers behave at all,
ever.

It seems that Facebook's engineers found IE8 wouldn't do their bidding
unless the communication channel IFrame was hosted on the same domain
as the main site. Oh, and that IFrame needs to run their JavaScript,
too. So what better way to ensure this than, uh, reload the current
page (which we know has the Connect JavaScript) in a hidden
IFrame. No site is going to care if they rack up double hits from a
large percentage of their user base, right? As they helpfully append
`fb_xd_fragment` as a query parameter, you can just make a special
case short-circuit in your routing based on that. Right? Right?

## A solution emerges

Remember how I linked to those oh-so-helpful JavaScript SDK docs that
had nothing whatsoever to say about this problem? They are (shock of
all shocks) incomplete. Littered all over the Internet, you'll find
references to a mythical **Cross Domain Communication Channel file**
that solves this
problem. Stale versions of [Facebook's own documentation](http://developers.facebook.com/search?q=Cross_Domain_Communication_Channel)
and
[connect-js Github page](https://github.com/facebook/connect-js/wiki/custom-channel-url)
hint at it, although the current versions of both are devoid of references.

The channel file is a static chunk of HTML hosted on your domain that
does nothing but load the Facebook Connect JavaScript. Through a
now-undocumented configuration parameter, you can tell the Connect
JavaScript on your site to load *that file* in the IFrame instead of
loading a copy of your current page. Problem solved!

Why wouldn't Facebook document this? Oh, wait &ndash; they did... sort
of. It's listed as part of
<a href='http://developers.facebook.com/docs/reference/oldjavascript/FB.Facebook.init' rel='nofollow'>the old JavaScript API</a>.
Oh, but wait. Apparently the API *has* changed a little, and
`xdChannelUrl` should just be `channelUrl`. They're close enough,
right? That's like, hardly worth mentioning. Or documenting.

*Update 2010-11-26 09:05: It appears this* is
*documented, or at least it is now. Peperone23 points out [the FB.init documentation](http://developers.facebook.com/docs/reference/javascript/FB.init).*

So now you do something like this:

    FB.init({
              apiKey: 'OMGWTFBBQ',
              status: true,
              cookie: true,
              xfbml: true,
              channelUrl: window.location.protocol + '//example.com/xd_receiver.html'
            });
        
And in xd_receiver.html, you do this:

    <!DOCTYPE html> 
    <html><head><title></title></head><body><script src="//connect.facebook.net/en_US/all.js"></script></body></html> 

Voil&agrave;! Facebook can use this static, lightweight, stateless
page to achieve their ends instead of loading the current page a
second time. Set some way-in-the-future cache headers on that sucker
and call it good.

