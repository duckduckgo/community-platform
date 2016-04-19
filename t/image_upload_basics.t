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

use FindBin;
my $image = $FindBin::Dir . '/../root/static/images/logo.svg';
my $non_image = $FindBin::Dir . '/../dist.ini';

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

    my $upload_file_request = sub {
        my $opts = shift;
        my $file = $opts->{file} || $image;
        my $filename = $file =~ s/.*\///r;

        $cb->(
            POST '/admin/upload',
            Content_Type => 'form-data',
            Cookie       => $opts->{cookie},
            Content      => [
                image => [ $file, $filename ],
            ],
        );
    };

    my $admin_cookie = $create_user_and_get_cookie->( {
        username => 'imageadminuser',
        role     => 'admin',
    } );

    my $user_cookie = $create_user_and_get_cookie->( {
        username => 'imageuser',
    } );

    my $user_request = $upload_file_request->({ cookie => $user_cookie });
    ok( $user_request->is_redirect, 'Upload redirects' );
    like( $user_request->decoded_content, qr/admin_required/, 'Non-admin cannot upload images' );

    my $admin_request = $upload_file_request->({ cookie => $admin_cookie });
    ok( $admin_request->is_redirect, 'Upload redirects' );
    like( $admin_request->decoded_content, qr{/admin/upload\?show=}, 'Admin can upload images' );

    $admin_request = $upload_file_request->({ cookie => $admin_cookie, file => $non_image });
    is( $admin_request->code, 500, 'Cannot upload non-image files' );
};

done_testing;
