use strict;
use warnings;

# Database setup
BEGIN {
    $ENV{DDGC_DB_DSN} = 'dbi:SQLite:dbname=ddgc_test.db';
}

use Test::More;
use t::lib::DDGC::TestUtils;
use HTTP::Request::Common;
use Plack::Test;
use Plack::Builder;
use Plack::Session::State::Cookie;
use Plack::Session::Store::File;
use File::Temp qw/ tempdir /;
use JSON::MaybeXS qw/:all/;

use DDGC;
use DDGC::Web;

my $d = DDGC->new;
t::lib::DDGC::TestUtils::deploy( undef, $d->db );

# Application setup and creation
my $app = builder {
    enable 'Session',
        store => Plack::Session::Store::File->new(
            dir => tempdir,
        ),
        state => Plack::Session::State::Cookie->new(
            secure => 0,
            httponly => 1,
            expires => 21600,
            session_key => 'ddgc_session',
        );
    mount '/testutils' => t::lib::DDGC::TestUtils->to_app;
    mount '/' => DDGC::Web->new->psgi_app;
};

# Tests - assert things here
test_psgi $app => sub {
    my ( $cb ) = @_;

    # Create user
    my $user_request = $cb->(
        POST '/testutils/new_user',
        { username => 'ia_user' }
    );
    ok( $user_request->is_success, 'Creating an IA user' );

    # Get session
    my $session_request = $cb->(
        POST '/testutils/user_session',
        { username => 'ia_user' }
    );
    ok( $session_request->is_success, 'Getting IA user Cookie' );
    my $cookie = 'ddgc_session=' . $session_request->content;

    # Retrieve CSRF Token
    my $action_token = $cb->( GET '/testutils/action_token' )->decoded_content;
    ok( $action_token && !ref $action_token, 'Have a CSRF token scalar' );

    # Create an IA
    my $new_ia_req = $cb->(
        POST '/ia/create',
        Cookie          => $cookie,
        Content         => [ data => encode_json( {
            id            => 'test_ia',
            name          => 'Test IA',
            description   => 'This is a test IA',
            example_query => 'testing IAs',
            repo          => 'longtail',
            action_token  => $action_token,
        } ) ],
    );
    ok( $new_ia_req->is_success, 'Creating IA' );

    # Find IA
    my $ia = $d->rs('InstantAnswer')->find('test_ia');
    ok( $ia, 'Query returns something' );
    is( ref $ia, 'DDGC::DB::Result::InstantAnswer' ,'IA is a Result' );

    # "Approve" IA
    my $ia_approve_request = $cb->(
        POST '/ia/save',
        Cookie  => $cookie,
        Content => [
            id           => 'test_ia',
            field        => 'public',
            value        => 1,
            action_token => $action_token,
        ],
    );
    ok( $ia_approve_request->is_success, 'IA "Approve" request succeeds' );

    # IA should be in repo JSON
    my $ia_repo_json_request = $cb->( GET '/ia/repo/all/json?all_milestones=1' );
    ok( $ia_repo_json_request->is_success, 'Can retrieve longtail JSON' );
    my $ia_repo = decode_json( $ia_repo_json_request->decoded_content );
    is( ref $ia_repo->{test_ia}, 'HASH', 'Test IA approved - is in repo JSON' );

    # Use this when you need to see session data
    # $cb->( GET '/testutils/debug_session' );

};

done_testing;
