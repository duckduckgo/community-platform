use strict;
use warnings;

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

use DDGC::Web::App::Blog;
use DDGC::Web::Service::Blog;



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
    mount '/blog' => DDGC::Web::App::Blog->to_app;
    mount '/blog.json' => DDGC::Web::Service::Blog->to_app;
};

test_psgi $app => sub {
    my ( $cb ) = @_;

    # Create user, get session cookie
    my $user_request = $cb->(
        POST '/testutils/new_user',
        { username => 'blogadminuser', role => 'admin' }
    );
    ok( $user_request->is_success, 'Creating an admin user' );

    my $session_request = $cb->(
        POST '/testutils/user_session',
        { username => 'blogadminuser' }
    );
    ok( $session_request->is_success, 'Getting admin user Cookie' );
    my $admin_cookie_header = 'ddgc_session=' . $session_request->content;

    # Posting
    my $blog_post = encode_json({
        title       => 'A blog post',
        uri         => 'a-blog-post',
        teaser      => 'This is a blog post karble warble snarble',
        content     => 'This is a blog post',
        topics      => [qw/blogs posts this/],
    });

    my $new_post_request = $cb->(
        POST '/blog.json/admin/post/new',
        'Content-Type'  => 'application/json',
        Content         => $blog_post,
    );
    ok( !$new_post_request->is_success, "Cannot create blog post without login" );

    $new_post_request = $cb->(
        POST '/blog.json/admin/post/new',
        'Content-Type'  => 'application/json',
        Cookie          => $admin_cookie_header,
        Content         => $blog_post,
    );
    ok( $new_post_request->is_success, "Admin user can create blog post" );
};

done_testing;
