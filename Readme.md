# DuckDuckGo - Community Platform

In order to test this application on your own machine you require Perl
installed, which is the case on nearly all Unix Systems. We don't suggest trying
to install on Windows, cause we don't test our application on other platforms.
The platform itself is only tested and deployed always on Debian stable.


## Requirements

      apt-get install build-essential libgd2-xpm-dev libssl-dev git wget

If you don't have a Debian stable build, try [VMware][1] or [Virtualbox][2].

For [VMware][1] you can find an image for Debian [here][3]:

[1]: http://www.vmware.com/
[2]: https://www.virtualbox.org/
[3]: http://www.thoughtpolice.co.uk/vmware/#debian6.0

You can also try to use it on Ubuntu or other Debian-related Unix systems.


## Notes

* We do not need root anymore!
* Do anything else with your user account in your userspace!


## Getting Started

The complete procedure can take some time, because Perl normally runs the test
for all modules that you install to assure the modules works for your system.

On an Atom processor system with Linux the complete procedure could take 2+ hrs.

After this, you will have nearly all modern Perl modules installed.

For the base we need to get local::lib installed, which we can now do all very 
easy with the DuckPAN installer we created for our other OpenSource Development.

So you can do everything with one command (which will require you to relogin once
and then redo it once more):

      curl http://duckpan.org/install.pl | perl

After this (and the relogin) we still need one more package to install:

      cpanm Catalyst::Devel

If you still encounter issues, please contact us on IRC
(irc.freenode.net #duckduckgo).  You can also [create a new Issue][4] here.

[4]: https://github.com/duckduckgo/community-platform/issues/new

Now you can clone the repository of the platform:

      git clone git://github.com/duckduckgo/community-platform.git

Then inside the repository you can install the requirements for authors and the
requirements of the distribution itself:

      cd community-platform
      duckpan installdeps

**WARNING:** Check for errors! If you don't have the overview, just redo
the command, and you can see the errors more clear! It could be just a bad 
mirror or download error.

When all requirements are installed we can deploy a small test setup for the
environment.

      script/ddgc_deploy_dev.pl

The command will install the required data in ~/ddgc.

If you update to a newer version you can do this command, it will delete the
old development environment and installs a fresh one:

      script/ddgc_deploy_dev.pl --kill

And now you can start the web application with:

      script/ddgc_web_server.pl -r -d

`-r` makes it reload on changes, and the `-d` activates debugging.

By default, the system will allow any login, so you can give every username and
just type something as password. If the account doesnt exist already, he will
automatically add this account (by concept it would be the same like 
registering via XMPP on dukgo.com and then login to the web platform). We added
some accounts by default:

      testone - admin
      testtwo - public profile
      testthree - translation manager, public profile
      testfour - admin, public profile
      testfive

If you want to make modification and help us on development, you should fork our
repository and send us pull requests!

Be sure to get in contact with us on IRC!

Many thanks!
