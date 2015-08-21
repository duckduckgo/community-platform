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
new_subscription('af.user1', 'created_ia_page');
new_subscription('af.user2', 'updated_ia_page', 'pokemon');
new_subscription('af.user3', 'updated_ia_page', 'bananas');
new_subscription('af.user3', 'created_ia_page');
new_subscription('af.admin', 'updated_ia_page', 'pokemon');
new_subscription('af.admin', 'updated_ia_page', 'apples');
new_subscription('af.admin', 'created_ia_page');
new_subscription('af.comleader', 'updated_ia_page', 'bananas');
new_subscription('af.comleader', 'created_ia_page');

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
my @deliveries = $transport->deliveries;
ok( scalar @deliveries == 3, 'Correct number of emails sent' );

sub got_email {
    my ( $address ) = @_;
    return grep { lc($address) eq lc($_) }
           map { $_->{successes}->[0] }
           @deliveries;
}
ok( got_email( 'comleader@example.org' ),
    'comleader@example.org received email'
);
ok( got_email( 'comleader@example.org' ),
    'admin@example.org received email'
);
ok( got_email( 'user1@example.org' ),
    'user1@example.org received email'
);
ok( got_email( 'user1@example.org' ),
    'user1@example.org received email'
);
ok( !got_email( 'user2@example.org' ),
    'user2@example.org did not receive email'
);

my $admin_delivery = (grep {
    'admin@example.org' eq lc($_->{envelope}->{to}->[0])
} @deliveries )[0];
my $admin_email_body = $admin_delivery->{email}->object->body_raw;
ok( $admin_email_body =~ /pokemon created/i,
    'admin knows about pokemon created' );
ok( $admin_email_body =~ /apples created/i,
    'admin knows about apples created' );
ok( $admin_email_body =~ /donuts created/i,
    'admin knows about donuts created' );
ok( $admin_email_body =~ /bananas created/i,
    'admin knows about bananas created' );
ok( $admin_email_body =~ /apples updated/i,
    'admin knows about apples updated' );
ok( $admin_email_body =~ /pokemon updated/i,
    'admin knows about pokemon updated' );
ok( $admin_email_body !~ /bananas updated/i,
    'admin not subscribed to banana updates' );

my $comleader_delivery = (grep {
    'comleader@example.org' eq lc($_->{envelope}->{to}->[0])
} @deliveries )[0];
my $comleader_email_body = $comleader_delivery->{email}->object->body_raw;
ok( $comleader_email_body =~ /pokemon created/i,
    'comleader knows about pokemon created' );
ok( $comleader_email_body =~ /apples created/i,
    'comleader knows about apples created' );
ok( $comleader_email_body =~ /donuts created/i,
    'comleader knows about donuts created' );
ok( $comleader_email_body =~ /bananas created/i,
    'comleader gets activity for privileged role' );
ok( $comleader_email_body !~ /apples updated/i,
    'comleader not subscribed to apples updates' );
ok( $comleader_email_body !~ /pokemon updated/i,
    'comleader not subscribed to pokemon updates' );
ok( $comleader_email_body =~ /bananas updated/i,
    'comleader knows about banana updates' );

my $user1_delivery = (grep {
    'user1@example.org' eq lc($_->{envelope}->{to}->[0])
} @deliveries )[0];
my $user1_email_body = $user1_delivery->{email}->object->body_raw;
ok( $user1_email_body =~ /pokemon created/i,
    'user1 knows about pokemon created' );
ok( $user1_email_body =~ /apples created/i,
    'user1 knows about apples created' );
ok( $user1_email_body =~ /donuts created/i,
    'user1 knows about donuts created' );
ok( $user1_email_body !~ /bananas created/i,
    'user1 not getting created activity for privileged role' );
ok( $user1_email_body !~ /apples updated/i,
    'user1 not subscribed to apples updates' );
ok( $user1_email_body =~ /pokemon updated/i,
    'user1 knows about pokemon updated' );

done_testing;
