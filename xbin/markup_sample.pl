#!/usr/bin/env perl

$|=1;

use strict;
use warnings;

use FindBin;
use lib $FindBin::Dir . "/../lib"; 

use DDGC;

my $ddgc = DDGC->new;
my $markup = $ddgc->markup;

my $test_markup = <<'__BBCODE__';

http://google.com/
https://duckduckgo.com/

[url=http://google.com]Google[/url]
[url]http://google.com[/url]
[url=https://duckduckgo.com]DuckDuckGo[/url]
[url]https://duckduckgo.com[/url]
[url=javascript:alert(123)]foo[/url]

[img=https://duck.co/static/img/logo_ddg_community.png]Good[/img]
[img=http://i.imgur.com/YKGX4ns.gif]Bad[/img]

[img]https://duck.co/static/img/logo_ddg_community.png[/img]
[img]http://i.imgur.com/YKGX4ns.gif[/img]

__BBCODE__

print $test_markup;

print "\n--- PRIVACY\n\n";

print $markup->html($test_markup);

print "\n--- NO PRIVACY\n\n";

print $markup->html_without_privacy($test_markup);
