#!/usr/bin/env perl

use FindBin;
use lib $FindBin::Dir . "/../lib"; 

use strict;
use warnings;

use Plack::Runner;
use DDGC::Config;
use DDGC::Search::Server;
use DDP;

my $config = DDGC::Config->new;

my $server = DDGC::Search::Server->new(config => $config);

my $runner = Plack::Runner->new;
$runner->parse_options(@ARGV);
$runner->set_options(host => '127.0.0.1') unless grep { /--host/ } @ARGV;
$runner->run($server->to_app);
