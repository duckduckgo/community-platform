use strict;
use warnings;

BEGIN {
    $ENV{DDGC_DB_DSN} = 'dbi:SQLite:dbname=ddgc_test.db';
    $ENV{DDGC_MAIL_TEST} = 1;
}

use Test::More;
use t::lib::DDGC::TestUtils;
use DDGC;
use DDGC::DB;
use DDGC::Base::Web::Common;
use DDGC::Util::Script::AddUserSubscription;
use DDGC::Util::Script::ActivityMailer;

my $d = DDGC->new;
my $m = DDGC::Util::Script::ActivityMailer->new;

my $schema = DDGC::DB->connect( $d );
t::lib::DDGC::TestUtils::deploy( { drop => 1 }, $schema );

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
    ok( DDGC::Util::Script::AddUserSubscription->new(
        sub => {
            user => $user,
            sub  => $sub,
            meta1 => $meta1,
            meta2 => $meta2,
            meta3 => $meta3,
        })->execute,
        sprintf('Subscribe %s to %s', $user, $sub),
    );
}
new_subscription('af.user1', 'updated_ia_page', 'pokemon');
new_subscription('af.user2', 'updated_ia_page', 'pokemon');
new_subscription('af.user3', 'updated_ia_page', 'bananas');
new_subscription('af.user3', 'created_ia_page');
new_subscription('af.admin', 'updated_ia_page', 'pokemon');
new_subscription('af.admin', 'updated_ia_page', 'apples');
new_subscription('af.admin', 'created_ia_page');
new_subscription('af.comleader', 'updated_ia_page', 'bananas');

sub update_latest_activity {
    my ( $update ) = @_;
    my $max_id = rset('ActivityFeed')->search(
        {},
        {
            select => {
                max => 'me.id',
                -as => 'max_id'
            }
        }
      )->one_row->get_column('max_id');
    ok( rset('ActivityFeed')->find( $max_id )->update( $update ),
        'Update ActivityFeed entry');
}

sub new_ia {
    my ( $id, $name ) = @_;
    ok( $d->rs('InstantAnswer')->create(
            {
                id      => $id,
                meta_id => $id,
                name    => $name,
            }
        ),
        sprintf('Create %s IA Page', $name),
    );
}
new_ia( 'pokemon', 'Pokemon' );
new_ia( 'bananas', 'Bananas' );
update_latest_activity({ for_role => 2 });
new_ia( 'apples', 'Apples' );
new_ia( 'donuts', 'Donuts' );

sub update_ia {
    my ( $id, $update ) = @_;
    ok( $d->rs('InstantAnswer')->find( $id )->update( $update ),
        sprintf('Update %s IA Page', $id) );
}
update_ia( 'pokemon', { dev_milestone => 'planning' } );
update_ia( 'apples', { dev_milestone => 'planning' } );
update_ia( 'donuts', { dev_milestone => 'planning' } );
update_ia( 'bananas', { dev_milestone => 'planning' } );

my $users = rset('User')->unsent_activity_from_to_date(
    DateTime->now->subtract( hours =>  1 )
);

my $transport = DDGC::Util::Script::ActivityMailer
                    ->new( users => $users )
                    ->execute;

done_testing;
