*This is part of a series on [Rails 2 Upgrade Turbulence](http://threebrothers.org/brendan/blog/rails2-upgrade-turbulence).*

Now that I had confidence that the code was production-ready, it was
time to merge changes back into trunk. We still have a main SVN
repository, although most people use the git-svn bridge. This proved
problematic in three ways which have *nothing to do with Rails*
whatsoever, but could prove useful to know about.

## git-svn rebase problems

I use a git-svn repository where the `master` branch tracks the trunk
of SVN. I branched from `master` to create the `dev_rails2` topic
branch. This follows the canonical example:

              A---B---C dev_rails2
             /
        D---E---F---G master

I also pushed `master` and `dev_rails2` to a remote Git repository. A
few co-workers and I worked in the `dev_rails2` branch and checked in
to the remote repository, and I pulled all changes back into my local
branch.

To prevent the gigantic merge that the Rails 2 upgrade would create, I
pulled trunk into the topic branch weekly. This involved:

 * git checkout master
 * git svn rebase
 * git checkout dev_rails2
 * git merge master
 * (resolve conflicts)
 
If you do things this way, you have to use a more obscure git-svn
command to commit your changes &ndash; dcommit won't work. Can you
spot the reason from looking at my workflow? No? Well, don't feel
too bad; I didn't anticipate the problem either.

If you merge `master` into `dev_rails2` as I did, you will eventually
want to merge `dev_rails2` back into master to commit. This can happen
with no conflicts if you resolved everything in `master` &ndash;&gt;
`dev_rails2` merges already.

So I'd do this:

 * git checkout master
 * git svn rebase
 * git merge dev_rails2 *(succeeded)*
 
But then in order for `git svn dcommit` to work, I'd need to do this: 

 * git svn rebase *(failed spectacularly)*
 * git svn dcommit *(doesn't work without the prior succeeding)*

The last step will rewind all of your merged changesets (which now
include some of the existing commits in Subversion) and apply them
to the current state of subversion. This generates conflicts because
it's attempting to diff the already resolved state against Subversion,
and the resolution often would not apply cleanly.

The correct solution is:

    git svn set-tree [first-hash]..[last-hash]

To <a rel='external nofollow' href='http://www.kernel.org/pub/software/scm/git/docs/git-svn.html'><abbr title='Quote the Effing Manual'>QTFM</abbr></a>:

    You should consider using dcommit instead of this command. Commit
    specified commit or tree objects to SVN. This relies on your imported
    fetch data being up-to-date. This makes absolutely no attempts to do
    patching when committing to SVN, it simply overwrites files with those
    specified in the tree or commit. All merging is assumed to have taken
    place independently of git svn functions.

Huh? `set-tree`? Yeah, I'd never heard of it either. And I fixed my problem
before I learned about it. In order to save revision history, I decided to
re-resolve all of the conflicts (sometimes badly, since there were too many
commits to remember every bit of minutiae) and fix the bad commits later.
This meant I'd have the following:

 1. Changes made in `master` (and therefore Subversion) that I wanted to keep.
 2. Changes made in `dev_rails2` that I wanted to keep, but that also contained
    random, badly-resolved conflicts.
 3. Changes to fix the bad resolutions.
 
Because the `dev_rails2` branch was in a good (i.e. a correctly merged view
of the final product that I wanted to commit) state, I managed to get #3 by
making a separate clone of it and copying files into the checkout in which I
had run (and resolved) `git svn rebase`. This allowed me to preserve ~130
commit comments worth of Rails 2 upgrade knowledge. But man, I wish I had
known about `set-tree` beforehand.

## git-svn dcommit problems

After finally merging in `dev_rails2` and getting a clean `git svn rebase`, I
was ready to commit. Not so fast &ndash; `git svn dcommit` failed rather
quickly:

    [hash] doesn't exist in the repository at /usr/lib/git-core/git-svn [...]
    Failed to read object [hash] at /usr/lib/git-core/git-svn line [...]

Who knows what `set-tree` would have done here. Two of my changes had made it
into Subversion, but the process halted on the commit in which I had copied
the new mysql\_replication\_adapter plugin into vendor/plugins. After Googling
around, I discovered this [great post about submodules](http://de-co-de.blogspot.com/2009/02/git-svn-and-submodules.html)
causing this of failure.

Although I didn't have a git submodule, the basic issue turns out to be the
same. Something in my commit (I believe it was an empty directory) appeared
differently in the subversion changeset. When git-svn attempted to map this
back to the git objects it knew about, a mismatch occurred. The object existed
in one repository but not the other, so the system (wisely) errored out.

Unfortunately, fixing this was not as simple as deleting the bad directory
in HEAD. git-svn has to commit your work sequentially, so I needed to rewrite
history.

    $ git tag broken [hash that failed to commit]
    $ git checkout broken
    $ # remove the directory, re-add with correct name, cross fingers
    $ git commit --amend
    $ git rebase --onto HEAD broken master

After rewriting the svn-incompatible changes, `git svn dcommit` worked! But *of course* there was one more issue.

## .svn directories in the tree

I had to update quite a few plugins, and I did this by checking out the source
code and copying it into place in vendor/plugins. This was a short-sighted way
of doing things, but using git-svn puts one in the unenviable position of being
able to use neither git submodules nor svn:externals. Unfortunately, git-svn is
more than happy to let you check full copies of Subversion repositories into
your own Subversion repository. Mind blowing, no?

The affect of this is that when you `svn up`, Subversion fails to update because
it can't actually add the .svn directories that are in the source tree &ndash;
it'd overwrite the ones that it truly needs! Also unfortunate is that you can't
delete them locally because *a)* they don't exist yet and *b)* even if they did,
the svn client helpfully ignores any attempts to operate on files named .svn. So
this is broken and will fail:

    svn del -m 'Delete .svn checkin' path/to/bad/.svn

Instead, one must delete the checked-in .svn directory on the remote server:

    svn del -m 'Delete .svn checkin' svn+ssh://svn-server/trunk/path/to/bad/.svn

Whew!
