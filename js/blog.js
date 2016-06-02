var pageTracker  = null,
    gaJsHost     = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");

var trackGA = function() {
  if (typeof(_gat) == 'undefined') {
    setTimeout(trackGA, 13);
  } else {
    try {
      var pageTracker = _gat._getTracker("UA-12753089-1");
      pageTracker._setDomainName(".threebrothers.org");
      pageTracker._trackPageview();
    } catch(err) {}
  }
};

var loadGA = function() {
  // GA Script
  var gaEl  = document.createElement('script');
  gaEl.type = 'text/javascript';
  gaEl.src  = gaJsHost + 'google-analytics.com/ga.js';
  document.getElementsByTagName('head')[0].appendChild(gaEl);
  trackGA();
};

var loadDisqus = function() {
  var links = document.getElementsByTagName('a');
  var query = '?';
  
  for(var i = 0; i < links.length; i++) {
    if(links[i].href.indexOf('#disqus_thread') >= 0) {
      query += 'url' + i + '=' + encodeURIComponent(links[i].href) + '&';
    }
  }

  var embedEl = document.createElement('script');
  embedEl.type = 'text/javascript';
  embedEl.charset = 'utf-8';
  embedEl.src = 'http://disqus.com/forums/tbdo-brendan/embed.js';
  embedEl.onload = function() {
    var disqusEl = document.createElement('script');
    disqusEl.type = 'text/javascript';
    disqusEl.charset = 'utf-8';
    disqusEl.src = 'http://disqus.com/forums/tbdo-brendan/get_num_replies.js' + query;
    document.getElementsByTagName('head')[0].appendChild(disqusEl);
  };
  document.getElementsByTagName('head')[0].appendChild(embedEl);
  

};
    
var deferredLoad = function() {
  setTimeout(loadDisqus, 750);
  setTimeout(loadGA, 1);
};



