#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib $FindBin::Dir . "/../lib";

use 5.010;

use DDGC::Helper::Translate;

#
# you need script/ddgc_pogenerator.pl to fill up the po-files dir for the specific context
#

l_add_context('duckduckgo-results','po-files/duckduckgo-results');
l_add_context('test-context','po-files/test-context');
l_set_locales('de_DE');

l_set_context('test-context');

say l('Hello %1','stranger');
say l('You are %1 from %2','someone','somewhere');

l_set_context('duckduckgo-results');

say l('Hello %1','stranger');
say l('try');
