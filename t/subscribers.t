use strict;
use warnings;

BEGIN {
    $ENV{DDGC_DB_DSN} = 'dbi:SQLite:dbname=ddgc_test.db';
    $ENV{DDGC_MAIL_TEST} = 1;
}


use Plack::Test;
use Plack::Builder;
use HTTP::Request::Common;
use Test::More;
use Test::MockTime qw/:all/;
use t::lib::DDGC::TestUtils;
use DDGC::Web::App::Subscriber;
use DDGC::Base::Web::Light;
use DDGC::Util::Script::SubscriberMailer;
use URI;

t::lib::DDGC::TestUtils::deploy( { drop => 1 }, schema );
my $m = DDGC::Util::Script::SubscriberMailer->new;

my $app = builder {
    mount '/s' => DDGC::Web::App::Subscriber->to_app;
};

test_psgi $app => sub {
    my ( $cb ) = @_;

    set_absolute_time('2016-10-18T12:00:00Z');

    for my $email (qw/
        test1@duckduckgo.com
        test2@duckduckgo.com
        test3@duckduckgo.com
        test4@duckduckgo.com
        test5@duckduckgo.com
        test6duckduckgo.com
    / ) {
        ok( $cb->(
            POST '/s/a',
            [ email => $email, campaign => 'a', flow => 'flow1' ]
        ), "Adding subscriber : $email" );
    }

    my $transport = DDGC::Util::Script::SubscriberMailer->new->verify;
    #is( $transport->delivery_count, 5, 'Correct number of verification emails sent' );

    $transport = DDGC::Util::Script::SubscriberMailer->new->verify;
    is( $transport->delivery_count, 0, 'No verification emails re-sent' );

    my $unsubscribe = sub {
        my ( $email ) = @_;
        my $subscriber = rset('Subscriber')->find( {
            email_address => $email,
            campaign => 'a',
        } );
        my $url = URI->new( $subscriber->unsubscribe_url );
        ok(
            $cb->( GET $url->path ),
            "Verifying " . $subscriber->email_address
        );
    };

    my $verify = sub {
        my ( $email ) = @_;
        my $subscriber = rset('Subscriber')->find( {
            email_address => $email,
            campaign => 'a',
        } );
        my $url = URI->new( $subscriber->verify_url );
        ok(
            $cb->( GET $url->path ),
            "Verifying " . $subscriber->email_address
        );
    };

    for my $email (qw/ test1@duckduckgo.com test2@duckduckgo.com test3@duckduckgo.com /) {
        $verify->( $email );
    }

    set_absolute_time('2016-10-19T12:00:00Z');
    $transport = DDGC::Util::Script::SubscriberMailer->new->execute;
    #is( $transport->delivery_count, 3, '3 received emails' );
    is( $transport->delivery_count, 5, '5 received emails' );

    $transport = DDGC::Util::Script::SubscriberMailer->new->execute;
    is( $transport->delivery_count, 0, 'Emails not re-sent' );

    set_absolute_time('2016-10-21T12:00:00Z');
    $transport = DDGC::Util::Script::SubscriberMailer->new->execute;
    is( $transport->delivery_count, 0, '0 received emails - non scheduled' );

    $unsubscribe->('test2@duckduckgo.com');

    set_absolute_time('2016-10-22T12:00:00Z');
    $transport = DDGC::Util::Script::SubscriberMailer->new->execute;
    #is( $transport->delivery_count, 2, '2 received emails - one unsubscribed' );
    is( $transport->delivery_count, 4, '4 received emails - one unsubscribed' );
};

done_testing;
