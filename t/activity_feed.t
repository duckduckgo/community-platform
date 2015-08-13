use strict;
use warnings;

BEGIN {
    $ENV{DDGC_DB_DSN} = 'dbi:SQLite:dbname=ddgc_test.db';
    $ENV{DDGC_MAIL_TEST} = 1;
}

use Test::More;
use t::lib::DDGC::TestUtils;
use DDGC;
use DDGC::Util::Script::AddUserSubscription;
use DDGC::Util::Script::ActivityMailer;

my $d = DDGC->new;
my $s = DDGC::Util::Script::AddUserSubscription->new;
my $m = DDGC::Util::Script::ActivityMailer->new;

# Create users
sub new_user {
    my ( $username, $role, $email, $verified ) = @_;
    my $user = t::lib::DDGC::TestUtils::new_user( $username, $role );
    ok( $user->{ok},
        sprintf('Creating %s user', $role // ''),
    );
    if ( my $user = $user->{user} ) {
        $user->update({
            email => $email,
            email_verified => $verified,
        });
    }
}
new_user( 'af.admin', 'admin', 'admin@example.org', 1 );
new_user( 'af.comleader', 'forum_manager', 'comleader@example.org', 1 );
new_user( 'af.user1', undef, 'user1@example.org', 1 );
new_user( 'af.user2', undef, 'user2@example.org', 0 );
new_user( 'af.user3', undef, undef, undef );

sub new_subscription {
    my ( $user, $sub, $meta1, $meta2, $meta3 ) = @_;
    $s->sub({
        user => $user,
        sub  => $sub,
        meta1 => $meta1,
        meta2 => $meta2,
        meta3 => $meta3,
    });
    ok ($s->execute,
        sprintf('Subscribe %s to %s', $user, $sub),
    );
}
new_subscription('af.user1', 'updated_ia_page', 'pokemon');
new_subscription('af.user2', 'updated_ia_page', 'pokemon');

done_testing;
