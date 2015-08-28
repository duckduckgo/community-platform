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


my $user = t::lib::DDGC::TestUtils::new_user( 'user' )->{user};
my $community_leader = t::lib::DDGC::TestUtils::new_user( 'community_leader', 'community_leader' )->{user};
my $forum_manager = t::lib::DDGC::TestUtils::new_user( 'forum_manager', 'forum_manager' )->{user};
my $idea_manager = t::lib::DDGC::TestUtils::new_user( 'idea_manager', 'idea_manager' )->{user};
my $translation_manager = t::lib::DDGC::TestUtils::new_user( 'translation_manager', 'translation_manager' )->{user};
my $admin = t::lib::DDGC::TestUtils::new_user( 'admin', 'admin' )->{user};

ok( $admin->is( 'admin' ), 'admin->is an admin' );
ok( $admin->is( 'translation_manager' ), 'admin->is a translation_manager' );
ok( $admin->is( 'idea_manager' ), 'admin->is an idea_manager' );
ok( $admin->is( 'community_leader' ), 'admin->is a community_leader' );
ok( $admin->is( 'forum_manager' ), 'admin->is a forum_manager' );

ok( !$community_leader->is( 'admin' ),
    'community_leader->is NOT an admin' );
ok( !$community_leader->is( 'translation_manager' ),
    'community_leader->is NOT a translation_manager' );
ok( $community_leader->is( 'idea_manager' ),
    'community_leader->is an idea_manager' );
ok( $community_leader->is( 'community_leader' ),
    'community_leader->is a community_leader' );
ok( $community_leader->is( 'forum_manager' ),
    'community_leader->is a forum_manager' );

ok( !$forum_manager->is( 'admin' ),
    'forum_manager->is NOT an admin' );
ok( !$forum_manager->is( 'translation_manager' ),
    'forum_manager->is NOT a translation_manager' );
ok( $forum_manager->is( 'idea_manager' ),
    'forum_manager->is an idea_manager' );
ok( $forum_manager->is( 'community_leader' ),
    'forum_manager->is a community_leader' );
ok( $forum_manager->is( 'forum_manager' ),
    'forum_manager->is a forum_manager' );

ok( !$idea_manager->is( 'admin' ),
    'idea_manager->is NOT an admin' );
ok( !$idea_manager->is( 'translation_manager' ),
    'idea_manager->is NOT a translation_manager' );
ok( $idea_manager->is( 'idea_manager' ),
    'idea_manager->is an idea_manager' );
ok( $idea_manager->is( 'community_leader' ),
    'idea_manager->is a community_leader' );
ok( $idea_manager->is( 'forum_manager' ),
    'idea_manager->is a forum_manager' );

ok( !$translation_manager->is( 'admin' ),
    'translation_manager->is NOT an admin' );
ok( $translation_manager->is( 'translation_manager' ),
    'translation_manager->is a translation_manager' );
ok( !$translation_manager->is( 'idea_manager' ),
    'translation_manager->is NOT an idea_manager' );
ok( !$translation_manager->is( 'community_leader' ),
    'translation_manager->is NOT a community_leader' );
ok( !$translation_manager->is( 'forum_manager' ),
    'translation_manager->is NOT a forum_manager' );

ok( !$user->is( 'admin' ),
    'user->is NOT an admin' );
ok( !$user->is( 'translation_manager' ),
    'user->is NOT a translation_manager' );
ok( !$user->is( 'idea_manager' ),
    'user->is NOT an idea_manager' );
ok( !$user->is( 'community_leader' ),
    'user->is NOT a community_leader' );
ok( !$user->is( 'forum_manager' ),
    'user->is NOT a forum_manager' );


done_testing;
