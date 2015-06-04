# DuckDuckGo - Community Platform

This is the source code for the DuckDuckGo Community Platform at [duck.co](https://duck.co/)

## REQUIREMENTS / INSTALLATION

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
- postgresql (recommended, though you may get away with mysql or sqlite for now)

To install these on Debian / Ubuntu:

```
  apt-get install cpanm build-essential libgd2-xpm-dev libssl-dev git wget libxml2-dev imagemagick perl-doc postgresql libpq-dev
```

To proceed with installation, you will also need [Dist::Zilla](https://metacpan.org/pod/Dist::Zilla)

```
  cpanm -i Dist::Zilla
```

To install community-platform's Perl dependencies, go to its directory and
run:

```
  dzil authordeps --missing | cpanm --mirror http://duckpan.org/
  dzil listdeps --missing | grep -v abstract | cpanm --mirror http://duckpan.org/
```

This will take some time. You can add `--notest` to the cpanm command, but
this may result in fires later.

## TEST DATA

Before running the dev server, we need a database schema.

The default is to use SQLite if no DSN configuration environment
variables are found, e.g.

```
  export DDGC_DB_DSN='dbi:Pg:database=ddgc';
  export DDGC_DB_USER='ddgc';
  export DDGC_DB_PASSWORD='yourdbpass';
```

To run the dev environment deployment script, your postgres user requires
the following permissions:

```
  ALTER USER ddgc CREATEDB;
  ALTER USER ddgc LOGIN;
```

This script deploys the schema and populates it with a test / dev data set:

```
  script/ddgc_deploy_dev.pl
```

You can also roll over any existing schema with the `--kill` switch:

```
  script/ddgc_deploy_dev.pl --kill
```

For the flags to work, you need to generate their sprites. This
process has to be repeated everytime the country flags are changed.

```
  script/ddgc_generate_flag_sprites.pl
```

Community platform's generated static files, media uploads, caches, duckpan
packages etc. live in `$HOME/ddgc/`

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
