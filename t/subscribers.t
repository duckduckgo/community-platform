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

sub _verify {
    my ( $cb, $email, $campaign ) = @_;
    my $subscriber = rset('Subscriber')->find( {
        email_address => $email,
        campaign => $campaign,
    } );
    my $url = URI->new( $subscriber->verify_url );
    ok(
        $cb->( GET $url->path ),
        "Verifying " . $subscriber->email_address
    );
}

sub _unsubscribe {
    my ( $cb, $email, $campaign ) = @_;
    my $subscriber = rset('Subscriber')->find( {
        email_address => $email,
        campaign => 'a',
    } );
    my $url = URI->new( $subscriber->unsubscribe_url );
    ok(
        $cb->( GET $url->path ),
        "Verifying " . $subscriber->email_address
    );
}

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
        notanemailaddress
    / ) {
        ok( $cb->(
            POST '/s/a',
            [ email => $email, campaign => 'a', flow => 'flow1' ]
        ), "Adding subscriber : $email" );
    }

    for my $email (qw/
        test6duckduckgo.com
        test7@duckduckgo.com
        test8@duckduckgo.com
        test9@duckduckgo.com
        lateverify@duckduckgo.com
    / ) {
        ok( $cb->(
            POST '/s/a',
            [ email => $email, campaign => 'c', flow => 'flow1' ]
        ), "Adding subscriber : $email" );
    }

    my $invalid = rset('Subscriber')->find( {
        email_address => 'notanemailaddress',
        campaign => 'a'
    } );
    is( $invalid, undef, 'Invalid address not inserted via POST' );

    my $transport = DDGC::Util::Script::SubscriberMailer->new->verify;
    is( $transport->delivery_count, 9, 'Correct number of verification emails sent' );

    $transport = DDGC::Util::Script::SubscriberMailer->new->verify;
    is( $transport->delivery_count, 0, 'No verification emails re-sent' );

    _verify($cb, 'test8@duckduckgo.com', 'c');
    _verify($cb, 'test9@duckduckgo.com', 'c');

    set_absolute_time('2016-10-20T12:00:00Z');
    $transport = DDGC::Util::Script::SubscriberMailer->new->execute;
    is( $transport->delivery_count, 7, '7 received emails' );

    $transport = DDGC::Util::Script::SubscriberMailer->new->execute;
    is( $transport->delivery_count, 0, 'Emails not re-sent' );

    set_absolute_time('2016-10-21T12:00:00Z');
    $transport = DDGC::Util::Script::SubscriberMailer->new->execute;
    is( $transport->delivery_count, 0, '0 received emails - non scheduled' );

    _unsubscribe($cb, 'test2@duckduckgo.com', 'a');
    _verify($cb, 'lateverify@duckduckgo.com', 'c');

    set_absolute_time('2016-10-22T12:00:00Z');
    $transport = DDGC::Util::Script::SubscriberMailer->new->execute;
    is( $transport->delivery_count, 6, '6 received emails - one unsubscribed' );

    $transport = DDGC::Util::Script::SubscriberMailer->new->execute;
    is( $transport->delivery_count, 0, 'Emails not re-sent' );

    set_absolute_time('2016-10-23T12:00:00Z');
    $transport = DDGC::Util::Script::SubscriberMailer->new->execute;
    is( $transport->delivery_count, 1, '1 received email - late verify, rescheduled' );

    $transport = DDGC::Util::Script::SubscriberMailer->new->execute;
    is( $transport->delivery_count, 0, 'Emails not re-sent' );
};

done_testing;
