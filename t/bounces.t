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
        ), 'Complaint from test1@duckduckgo.com' );

    is( rset('Subscriber')->unbounced->count, 2,
        'Complaint report received - 2 subscribers remain' );

    ok( $cb->( POST '/bounce/handler',
            'Content-Type' => 'application/json',
            Content => sns->sns_transient_bounce( 'test2@duckduckgo.com' )
        ), 'Transient bounce message about test2@duckduckgo.com' );

    is( rset('Subscriber')->unbounced->count, 2,
        'Transient bounce received - 2 subscribers remain' );

    ok( $cb->( POST '/bounce/handler',
            'Content-Type' => 'application/json',
            Content => sns->sns_permanent_bounce( 'test3@duckduckgo.com' )
        ), 'Permanent bounce message about test3@duckduckgo.com' );

    is( rset('Subscriber')->unbounced->count, 1,
        'Permanent bounce received - 1 subscriber remains' );

};

done_testing;
