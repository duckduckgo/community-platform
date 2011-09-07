use strict;
use warnings;
use Test::More;


use Catalyst::Test 'DDGC::Web';
use DDGC::Web::Controller::User;

ok( request('/user')->is_success, 'Request should succeed' );
done_testing();
