use strict;
use warnings;
use Test::More;

require Catalyst::Test;
Catalyst::Test->import('DDGC::Web');

my $root = request('/');
ok( $root->is_success, 'Homepage should succeed' );
like( $root->content, qr!/my/login!, 'There is a link to login' );
like( $root->content, qr!/my/register!, 'There is a link to register' );

done_testing();
