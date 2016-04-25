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
use HTML::TreeBuilder::LibXML;

use DDGC;
use DDGC::Web::App::Blog;
use DDGC::Web::Service::Blog;

my $d = DDGC->new;
t::lib::DDGC::TestUtils::deploy( { drop => 1 }, $d->db );

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
        live        => 1,
        company_blog => 1,
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

    my $new_post = decode_json( $new_post_request->decoded_content );
    my $new_post_uri = sprintf( '/blog/post/%s/%s', $new_post->{post}->{id}, $new_post->{post}->{uri} );
    my $new_post_rendered = $cb->( GET $new_post_uri );
    ok( $new_post_rendered->is_success, 'New blog post found' );

    my $tree = HTML::TreeBuilder::LibXML->new;
    $tree->parse( $new_post_rendered->decoded_content );
    $tree->eof;
    is( $tree->findvalue('/html/head/title'), 'DuckDuckGo Blog : A blog post', 'Blog post title in page title' );
};

done_testing;
