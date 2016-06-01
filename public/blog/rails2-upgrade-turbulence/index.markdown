---
date:  2010-10-21
title: Rails 2 Upgrade Turbulence: a Series
---
Here are several posts on Rails 2 upgrade issues that I encountered at Urbanspoon:

 * [General Cleanup](http://threebrothers.org/brendan/blog/rails2-upgrade-general-cleanup)
 * [Disabling Sessions](http://threebrothers.org/brendan/blog/rails2-upgrade-disabling-sessions)
 * [ActiveRecord Woes](http://threebrothers.org/brendan/blog/rails2-upgrade-activerecord-woes)
 * [git-svn Workflow Warts](http://threebrothers.org/brendan/blog/rails2-upgrade-git-svn-workflow-warts)
 * [Troubleshooting a Slow Production Deployment](http://threebrothers.org/brendan/blog/rails2-upgrade-troubleshooting-a-slow-production-deployment)

I've found it common for startups to get stuck on old versions of Rails because the incremental upgrade task is always lower priority than feature work (rightfully so). As time progresses, the task becomes more and more daunting. I bit the bullet and upgraded our site.

Considering that Rails 3 is out now, we're still a touch behind the times. That said, there are still interesting things one could learn from the process of taking a real site (that serves quite a bit of traffic) from Rails 1.1.6 to 2.3.10.

