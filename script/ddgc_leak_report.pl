#!/usr/bin/env perl

# Output Devel::Leak::Object counts accumulated in a series of requests
#
# You will probably need to update this script to suit your needs,
# i.e. adding apps to the mounts in builder

use strict;
use warnings;

use FindBin;
use lib $FindBin::Dir . "/../lib";

use Plack::Builder;
use CHI;
use DDGC::Web;
use DDGC::Web::App::Blog;
use DDGC::Web::Service::Blog;
use HTTP::Request::Common;
use Plack::Test;
use Plack::App::File;
use Plack::Session::State::Cookie;
use Plack::Session::Store::File;

use Devel::Leak::Object qw{ GLOBAL_bless };

my $iterations = $ARGV[0] // 100;
my $route = $ARGV[1] // '/';

my $app = builder {
    mount '/blog' => DDGC::Web::App::Blog->to_app;
    mount '/blog.json' => DDGC::Web::Service::Blog->to_app;
    mount '/' => DDGC::Web->new->psgi_app;
};

test_psgi $app => sub {
    $_[0]->(GET $route) for (1..$iterations)
};

