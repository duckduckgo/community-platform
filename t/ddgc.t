#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use File::Temp qw/ tempdir /;
use DDGCTest::Database;

use_ok('DDGC');
use_ok('DDGC::Web');

my $tempdir = tempdir;
$ENV{DDGC_ROOTDIR} = "$tempdir";

# generate test database and run tests while doing so
my $test = DDGCTest::Database->new(DDGC->new({ config => DDGC::Config->new }),1);
$test->deploy;

use Catalyst::Test 'DDGC::Web';

my $root = request('/');
ok( $root->is_success, 'Homepage should succeed' );
like( $root->content, qr!/my/login!, 'There is a link to login' );
like( $root->content, qr!/my/register!, 'There is a link to register' );

#my $login = request('/my/login?username=testone&password=ficken');
#ok( $login->is_success, 'Login should succeed' );

my $testone_userpage = request('/testone');
like($testone_userpage->decoded_content, qr!User page of testone!, 'Userpage of testone works' );

done_testing();
