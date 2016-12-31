# DuckDuckGo - Community Platform

This is the source code for the DuckDuckGo Community Platform at [duck.co](https://duck.co/)

## Requirements / Installation

The DuckDuckGo Community Platform is built on [Perl](http://www.perl.org/),
[Catalyst](https://metacpan.org/pod/Catalyst),
[DBIx::Class](https://metacpan.org/pod/DBIx::Class),
[Text::Xslate](https://metacpan.org/pod/Text::Xslate) and
[Dancer2](https://metacpan.org/pod/Dancer2).

Requires perl 5.16.3 (or higher) and:

- cpanm ([local::lib](https://metacpan.org/pod/local::lib) and/or [perlbrew](http://perlbrew.pl/) recommended)
- gcc toolchain (gcc, make, lib headers)
- git
- libcurl
- imagemagick
- postgresql (recommended, though you may get away with mysql or sqlite for now)

To install these on Debian / Ubuntu:

```
  apt-get install cpanm build-essential libgd2-xpm-dev libssl-dev git libcurl4-gnutls-dev libxml2-dev imagemagick perl-doc postgresql libpq-dev
```

To proceed with installation, you will also need [Dist::Zilla](https://metacpan.org/pod/Dist::Zilla)

```
  cpanm -i Dist::Zilla
```

To install community-platform's Perl dependencies, go to its directory and
run:

```
  dzil authordeps --missing | cpanm
  dzil listdeps --missing | grep -v abstract | cpanm
```

This will take some time. You can add `--notest` to the cpanm command to speed
things up, but this may result in fires later.

## Test Data

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

## Development

To launch the development web server:

```
script/ddgc_dev_server.sh
```

This, by default, launches a plack server bound to port 5001 with DBIC and
Catalyst console debugging enabled with Plack debug panels in rendered output.

It watches the `lib/` directory and restarts if there are any changes written.
It supports the following options:

- -p <PORT> - Set port to bind to
- -m - Use a debug mailer on localhost:1025 (python -m smtpd -n -c DebuggingServer localhost:1025)
- -n - Don't render Plack debug panels (useful for frontend work)

Front end elements (js, css...) in `src/` are managed by node.js / grunt.

To launch a task to rebuild static files when they change, use

`grunt watch`

### User Accounts

The following accounts are created by `ddgc_deploy_dev.pl`:

- **testone** An admin, who is native German but also speaks English.

- **testtwo** A normal user who speaks Spanish with public profile.

- **testthree** A translation manager who speaks English, Arabic, and German.

- **testfour** An admin, who speaks German, Spanish, and English.

- **testfive** A normal user without public profile, who speaks Russian and
   English.

- Additionally there are also **test1** to **test40** all without any setup.

Any random password will suffice, as a separate service is used to provide
authentication in production.

## License

This software is licensed under Perl 5 dual license: either GPLv1 or later, or, at users' choice, Artistic 1.0.
We welcome contributions to this software under the same licensing terms.

## Third party credits

The project is built using other software packages and creative content:

- SCEditor, [MIT license](http://www.opensource.org/licenses/MIT)
- jQuery JavaScript Library v1.9.1, [MIT license](http://www.opensource.org/licenses/MIT)
- aToolTip jQuery plugin, [CC-BY 3.0 Unported license](http://creativecommons.org/licenses/by/3.0)			
- Select2, [Apache License 2.0](http://www.apache.org/licenses/LICENSE-2.0) or [GPL v2](http://www.gnu.org/licenses/gpl-2.0.html)
- handlebars v1.3.0, [MIT license](http://www.opensource.org/licenses/MIT)
- HTML5shiv, dual license, [MIT](http://www.opensource.org/licenses/MIT) or [GPL v2](http://www.gnu.org/licenses/gpl-2.0.html)
- jQuery Iframe Transport, part of jQuery-File-Upload jQuery plugin, [MIT license](http://www.opensource.org/licenses/MIT)
- Dropzone, [MIT license](http://www.opensource.org/licenses/MIT)
- ContentLoaded, [MIT license](http://www.opensource.org/licenses/MIT)
- addPlaceholder jQuery plugin, code made available on [author's blog](http://iliadraznin.com/2011/02/jquery-placeholder-plugin/)

