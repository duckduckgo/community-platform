use strict;
use warnings;

BEGIN {
    $ENV{DDGC_DB_DSN} = 'dbi:SQLite:dbname=ddgc_test.db';
    $ENV{DDGC_SNS_VERIFY_TEST} = 1;
    $ENV{DDGC_MAIL_TEST} = 1;
}

use Plack::Test;
use Plack::Builder;
use HTTP::Request::Common;
use Test::More;
use t::lib::DDGC::TestUtils;
use aliased 't::lib::DDGC::TestUtils::AWS' => 'sns';
use DDGC::Web::App::Subscriber;
use DDGC::Web::Service::Bounce;
use DDGC::Base::Web::LightService;

t::lib::DDGC::TestUtils::deploy( { drop => 1 }, schema );

my $app = builder {
    mount '/s' => DDGC::Web::App::Subscriber->to_app;
    mount '/bounce' => DDGC::Web::Service::Bounce->to_app;
    mount '/testutils' => t::lib::DDGC::TestUtils->to_app;
};

test_psgi $app => sub {
    my ( $cb ) = @_;

    for my $email (qw/
        test1@duckduckgo.com
        test2@duckduckgo.com
        test3@duckduckgo.com
    / ) {
        ok( $cb->(
            POST '/s/a',
            [ email => $email, campaign => 'a', flow => 'flow1' ]
        ), "Adding subscriber : $email" );
    }

    is( rset('Subscriber')->unbounced->count, 3,
        'No bounce reports received - 3 subscribers' );

    ok( $cb->( POST '/bounce/handler',
            'Content-Type' => 'application/json',
            Content => sns->sns_complaint( 'test1@duckduckgo.com' )
        )->is_success, 'Complaint from test1@duckduckgo.com' );

    is( rset('Subscriber')->unbounced->count, 2,
        'Complaint report received - 2 subscribers remain' );

    ok( $cb->( POST '/bounce/handler',
            'Content-Type' => 'application/json',
            Content => sns->sns_transient_bounce( 'test2@duckduckgo.com' )
        )->is_success, 'Transient bounce message about test2@duckduckgo.com' );

    is( rset('Subscriber')->unbounced->count, 2,
        'Transient bounce received - 2 subscribers remain' );

    ok( $cb->( POST '/bounce/handler',
            'Content-Type' => 'application/json',
            Content => sns->sns_permanent_bounce( 'test3@duckduckgo.com' )
        )->is_success, 'Permanent bounce message about test3@duckduckgo.com' );

    is( rset('Subscriber')->unbounced->count, 1,
        'Permanent bounce received - 1 subscriber remains' );

    my $user_with_verified_email = sub {
        my( $email) = @_;
        my $username = $email =~ s/(.*)@.*/$1/r;
        ok ( $cb->( POST '/testutils/new_user',
                    { username => $username }
             )->is_success, "Creating user $username" );
        my $user = rset('User')->find_by_username( $username );
        return 0 unless $user;
        $user->update({ email_verified => 1, email => $email });
    };

    my $user1 = $user_with_verified_email->( 'test4@duckduckgo.com' );
    ok( $user1, 'User 1 created' );
    ok( $user1->email && $user1->email_verified, 'User 1 has verified email' );
    my $user2 = $user_with_verified_email->( 'test5@duckduckgo.com' );
    ok( $user2, 'User 2 created' );
    ok( $user1->email && $user1->email_verified, 'User 2 has verified email' );

    ok( $cb->( POST '/bounce/handler',
            'Content-Type' => 'application/json',
            Content => sns->sns_permanent_bounce( 'test4@duckduckgo.com' )
        )->is_success, 'Permanent bounce message about test4@duckduckgo.com' );
    $user1->discard_changes;
    ok( !$user1->email_verified, 'User 1 no longer verified' );

    ok( $cb->( POST '/bounce/handler',
            'Content-Type' => 'application/json',
            Content => sns->sns_complaint( 'test5@duckduckgo.com' )
        )->is_success, 'Complaint from test5@duckduckgo.com' );
    $user2->discard_changes;
    ok( !$user2->email_verified, 'User 2 no longer verified' );
};

done_testing;
