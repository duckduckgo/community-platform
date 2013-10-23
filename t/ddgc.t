use strict;
use warnings;
use Test::More;
use File::Temp qw/ tempdir /;
use DDGCTest::Database;

my $testdir = tempdir;
$ENV{DDGC_TESTING} = $testdir;

# generate test database and run tests while doing so
my $test = DDGCTest::Database->for_test($testdir);
$test->deploy;

my $ddgc = $test->d;

require Catalyst::Test;
Catalyst::Test->import('DDGC::Web');

my $root = request('/');
ok( $root->is_success, 'Homepage should succeed' );
like( $root->content, qr!/my/login!, 'There is a link to login' );
like( $root->content, qr!/my/register!, 'There is a link to register' );

#my $login = request('/my/login?username=testone&password=ficken');
#ok( $login->is_success, 'Login should succeed' );

# test redirect?
#my $testone_userpage = request('/testone');
#like($testone_userpage->decoded_content, qr!TestOne!, '' );

my $testone_userpage = request('/TestOne');
like($testone_userpage->decoded_content, qr!TestOne!, 'Userpage of testone works' );

# $ddgc->envoy->notify_cycle(2);

# for (@{$ddgc->postman->transport->deliveries}) {
# 	print $_->{envelope}->{to}->[0]."\n";
# 	print $_->{envelope}->{from}."\n";
# }

done_testing();
