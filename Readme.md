
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

We need to install local::lib, and the best route is through these instructions:

      wget http://cpan.cpantesters.org/authors/id/A/AP/APEIRON/local-lib-1.008004.tar.gz
      tar xvzf local-lib-1.008004.tar.gz
      cd local-lib-1.008004
      perl Makefile.PL --bootstrap
      make test && make install

After this you need to configure your shell to include the proper env. variables
for local::lib, you can do this for bash with this command:

      echo 'eval $(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)' >>~/.bashrc

Then re-login, and check that the environment variables are correctly set by:

      set | grep PERL5

If you see output with a variable, then you did something right, else double
check that you followed the above steps correctly.  Then you can install the
Perl modules in your local userspace.  Install this CPAN client for the modules:

      cpan App::cpanminus

After this you got the new command "cpanm" which is a much nicer way to install
modules, we need a small bunch of base modules to get our stuff best done:

      cpanm Dist::Zilla Catalyst::Devel

To ensure these above (2) steps work properly, issue each of the commands again.

If you still encounter issues, please contact us on IRC
(irc.freenode.net #duckduckgo).  You can also [create a new Issue][4] here.

[4]: https://github.com/duckduckgo/community-platform/issues/new

Now you can clone the repository of the platform:

      git clone git://github.com/duckduckgo/community-platform.git

Then inside the repository you can install the requirements for authors and the
requirements of the distribution itself:

      cd community-platform
      cpanm $( dzil authordeps --missing )
      cpanm $( dzil listdeps --missing )

**WARNING:** Check for errors! If you don't have the overview, just redo
both `cpanm` commands, and you can see the errors more clear!  As mentioned
above, it could be just a bad mirror.

When all requirements are installed we can deploy a small test setup for the
environment. The command will install the required data in ~/ddgc.

If you get a newer version you should delete this directory and redo the command:

      script/ddgc_deploy_dev.pl

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
