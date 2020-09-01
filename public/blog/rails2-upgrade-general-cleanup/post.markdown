*This is part of a series on [Rails 2 Upgrade Turbulence](http://threebrothers.org/brendan/blog/rails2-upgrade-turbulence).*

Some generic cleanup tasks:

 * @request/@params/etc are deprecated, drop the '@' everywhere.
 * application.rb becomes application_controller.rb
 * start\_form\_tag and end\_form\_tag are deprecated; use form_for instead.
 * [ActiveRecord associations have changed](http://threebrothers.org/brendan/blog/rails2-upgrade-activerecord-woes/).
 * Named routing has changed. Previously, every route created a method of the form 'some\_page\_url', which generated a relative path to the related url. Now, both 'some\_page\_url' and 'some\_page\_path' are generated. The \_url method now gives an absolute url, while \_path is relative.
 * Most gems/plugins need to be upgraded or replaced. Yay for more current versions!

I found these [Rails 2 Upgrade Notes](http://www.slashdotdash.net/2007/12/03/rails-2-upgrade-notes/) to be pretty helpful.

Also, there's nothing like a little `grep`/`cut`/`sed` to make short work of replacing *en masse*:

<noscript>
  <pre>
    <code>
ack @request . | cut -d ':' -f 1 | uniq | xargs sed -i 's/@request/request/g'
    </code>
  </pre>
</noscript>
<script src="//gist.github.com/653085.js?file=replace.sh"></script>
