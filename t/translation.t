use strict;
use warnings;

# Database setup
BEGIN {
    unlink 'ddgc_test.db';
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
use URI;

use DDGC;
use DDGC::Web;

my $d = DDGC->new;
t::lib::DDGC::TestUtils::deploy( undef, $d->db );

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

test_psgi $app => sub {
    my ( $cb ) = @_;

    my $create_user_and_get_cookie = sub {
        my $opts = shift;

        my $user_request = $cb->(
            POST '/testutils/new_user',
            {
                username => $opts->{username},
                ( $opts->{role} ) ? ( role => $opts->{role} ) : (),
            }
        );
        ok( $user_request->is_success, 'Creating a user' );

        my $session_request = $cb->(
            POST '/testutils/user_session',
            { username => $opts->{username} }
        );
        ok( $session_request->is_success, 'Getting user Cookie' );
        my $cookie = 'ddgc_session=' . $session_request->content;
    };

    my $retire_request = sub {
        my ( $user, $token_id, $retire ) = @_;

        $cb->(
            GET "/translate/single_token/$token_id/retire/$retire",
            Cookie => $user,
        );
    };

    my $token = sub {
        $d->rs('Token')->search({ msgid => $_[0] })->one_row;
    };

    my $new_lang = sub {
        my ( $locale, $name ) = @_;
        $d->rs('Language')->create({
            locale => $locale,
            name_in_english => $name,
            name_in_local => $name
        });
    };

    my $admin = $create_user_and_get_cookie->( {
        username => 'tadminuser',
        role     => 'admin',
    } );
    my $admin_user = $d->find_user('tadminuser');

    my $user = $create_user_and_get_cookie->( {
        username => 'tuser',
    } );
    my $user_user = $d->find_user('tuser');

    my $l1 = $new_lang->('en_US', 'US English');

    my $domain = $d->rs('Token::Domain')->create({
        name => 'test',
        key => 'test',
        source_language_id => $l1->id,
    });

    $_->create_related(
        user_languages => {
            grade => 5,
            language_id => $l1->id,
        }
    ) for ( $admin_user, $user_user );

    my $l2 = $new_lang->('en_GB', 'UK English');
    my $l3 = $new_lang->('en_AU', 'Aus English');

    $domain->create_related(
        token_domain_languages => {
            language => $_
        }
    ) for ( $l2, $l3 );

    $domain->create_related( tokens => { msgid => $_ } )
        for ( qw/ foo bar baz qux quux quuz / );

    my $r = $retire_request->( $user, $token->('baz')->id, 1 );
    ok( !$r->is_success, 'Non-admin cannot retire token' );
    is( $token->('baz')->retired, 0, 'Token baz not retired' );

    $r = $retire_request->( $admin, $token->('baz')->id, 1 );
    ok( $r->is_success, 'Admin can retire token' );
    is( $token->('baz')->retired, 1, 'Token baz retired' );

};

done_testing;
