use strict;
use warnings;

BEGIN {
    $ENV{DDGC_SNS_VERIFY_TEST} = 0;
}

use Plack::Test;
use Plack::Builder;
use HTTP::Request::Common;
use Test::More;
use aliased 't::lib::DDGC::TestUtils::AWS' => 'sns';
use DDGC::Web::Service::Bounce;

my $app = builder {
    mount '/bounce' => DDGC::Web::Service::Bounce->to_app;
};

test_psgi $app => sub {
    my ( $cb ) = @_;

    ok( !$cb->( POST '/bounce/handler',
            'Content-Type' => 'application/json',
            Content => sns->sns_transient_bounce( 'test2@duckduckgo.com' )
        )->is_success, 'Unsigned message fails SNS verify' );
};

done_testing;
