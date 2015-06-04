# DuckDuckGo - Community Platform

This is the source code for the DuckDuckGo Community Platform at [duck.co](https://duck.co/)

## REQUIREMENTS

The DuckDuckGo Community Platform is built on [Perl](http://www.perl.org/),
[Catalyst](https://metacpan.org/pod/Catalyst),
[DBIx::Class](https://metacpan.org/pod/DBIx::Class),
[Text::Xslate](https://metacpan.org/pod/Text::Xslate) and
[Dancer2](https://metacpan.org/pod/Dancer2).

Requires perl 5.16.3 (or higher) and:

- cpanm ([local::lib](https://metacpan.org/pod/local::lib) and/or [perlbrew](http://perlbrew.pl/) recommended)
- gcc toolchain (gcc, make, lib headers)
- git
- wget
- imagemagick
- postgresql (recommended, you may get away with mysql / sqlite for now)

To install these on Debian / Ubuntu:

```
  apt-get install cpanm build-essential libgd2-xpm-dev libssl-dev git wget libxml2-dev imagemagick perl-doc postgresql libpq-dev
```

To proceed with installation, you will also need [Dist::Zilla](https://metacpan.org/pod/Dist::Zilla)

```
  cpanm -i Dist::Zilla
```

## INSTALLATION

After checking out, you will need to install the prerequisite modules. You must have
installed [Dist::Zilla](https://metacpan.org/pod/Dist::Zilla).  Then, you can do the
following to install the base Perl requirements (run this in the source root with
dist.ini file):

```
  dzil authordeps --missing | cpanm
  dzil listdeps --missing | grep -v abstract | cpanm
```

If you're doing this on a fresh Perl install, this may take a while to install.

To start, you must first initialize the base database. The default is to use
SQLite if no Database configuration environment variables are found, but it
is strongly recommended to use Postgresql. To do this, make sure you set
the following 3 environment variables before proceeding further (and these
variables need to be set permanently post this, so you need to put them in
a `.bashrc` or correspdonding initialization scripts for your shell):

(Use your preferred database name / user / password values)

```
  export DDGC_DB_DSN='dbi:Pg:database=ddgc';
  export DDGC_DB_USER='ddgc';
  export DDGC_DB_PASSWORD='yourdbpass';
```

Note: Do ensure that the user ('ddgc' in above example) has the 'createdb'
and the 'login' permissions. To do this, login to psql as a superuser and run:

```
  ALTER USER ddgc CREATEDB;
  ALTER USER ddgc LOGIN;
```

Now, run the script to initialize the base database:

```
  script/ddgc_deploy_dev.pl
```

Do note that the script will complain if you already have an existing database
at the target location. If this happens, you would need to use use the
`--kill` switch to reset it:

```
  script/ddgc_deploy_dev.pl --kill
```

For the flags to work, you need to generate the sprites used for the flags. This
process has to be repeated everytime the country flags are changed.

```
  script/ddgc_generate_flag_sprites.pl
```

## DEVELOPING

You can start the web server, if you are inside the repository with:

```
  script/ddgc_web_server.pl -r -d
```

If you want to do any of the above activities with intense debug logging you can
use the following ENV variables before the command, like in this example:

```
  DBIC_TRACE_PROFILE=console DBIC_TRACE=1 script/ddgc_web_server.pl -r -d
```

The `-r` switch assures that it reloads itself, if some of the codefiles are
changed. For changes on templates he will not restart. (If you work on the blog
you sadly have to restart by hand if you change the data file).

The `-d` switch sets the web server into debugging mode. This activates a side
bar with additional request informations, and also shows you much more
informations on the terminal. If you don't want those, you can just deactivate
it. For work on HTML/CSS or the blog it might disturb.

### ACCOUNTS

We prepared some accounts for testing in the default setup, those can all be
accessed with random passwords (yes, you can't test wrong password yet, sorry).

The following account exist:

- **testone** An admin, who is native German but also speaks English.

- **testtwo** A normal user who speaks Spanish with public profile.

- **testthree** A translation manager who speaks English, Arabic, and German.

- **testfour** An admin, who speaks German, Spanish, and English.

- **testfive** A normal user without public profile, who speaks Russian and
   English.

- Additionally there are also **test1** to **test100** all without any setup.
