package Dancer2::Plugin::DDGC::Request;

# ABSTRACT: HTTP Request handling functions for DDGC

use strict;
use warnings;

use LWP::UserAgent;
use HTTP::Request;
use JSON;
use Dancer2::Plugin;

my $ua = LWP::UserAgent->new(
    timeout => 5,
    (!$ENV{DANCER_ENVIRONMENT} || $ENV{DANCER_ENVIRONMENT} ne 'production')
        ? ( ssl_opts => { verify_hostname => 0 } )
        : (),
);

sub _uri_for {
    my ( $dsl, $route, $params ) = @_;
    return ( $route =~ m{^//} )
        ? $dsl->root_uri_for( $route, $params )
        : $dsl->uri_for( $route, $params );
}

sub _apply_session_to_req {
    my ( $dsl, $req ) = @_;
    if ( $dsl->can('session') && $dsl->session->id ) {
        $req->header(
            Cookie => 'ddgc_session=' . $dsl->request->env->{'psgix.session.options'}->{id},
        );
    }
}

sub _ref_to_uri {
    my ( $route ) = @_;
    my $service = '//' . lc( shift @{$route} ) . '.json';
    my ( $uri ) = join  '/', @{$route};
    return "$service/$uri";
}

on_plugin_import {
    my ( $dsl ) = @_;
    die "Need to load Dancer2::Plugin::RootURIFor before Dancer2::Plugin::DDGC::Request" if !($dsl->can('root_uri_for'));
};

register ddgcr_get => sub {
    my ( $dsl, $route, $params ) = @_;
    $route = _ref_to_uri( $route  ) if ( ref $route eq 'ARRAY' );

    my $req = HTTP::Request->new(
        GET => _uri_for( $dsl, $route, $params )
    );
    _apply_session_to_req( $dsl, $req );

    my $res = $ua->request( $req );
    $res->{ddgcr} = JSON::from_json( $res->content, { utf8 => 1 } );
    return $res;
};

register ddgcr_post => sub {
    my ( $dsl, $route, $data ) = @_;
    $route = _ref_to_uri( $route  ) if ( ref $route eq 'ARRAY' );

    $data = JSON::to_json($data, { convert_blessed => 1, utf8 => 1 }) if ref $data;
    my $req = HTTP::Request->new(
        POST => _uri_for( $dsl, $route )
    );
    $req->content_type( 'application/json' );
    $req->content( $data );
    _apply_session_to_req( $dsl, $req );

    my $res = $ua->request( $req );
    $res->{ddgcr} = JSON::from_json( $res->content, { utf8 => 1 } );
    return $res;
};

register_plugin;

1;

__END__

=pod

=head1 NAME

Dancer2::Plugin::DDGC::Request - HTTP Request handling functions for DDGC

=head1 SYNOPSIS

    use Dancer2;
    use Dancer2::Plugin::DDGC::Request;

    my $response = ddgcr_get [ 'Blog' ], { page => 1 };

    if ( $response->is_success ) {
        template 'blog', $response->{ddgcr};
    }

=head1 DESCRIPTION

Dancer2::Plugin::DDGC::Request provides convenience functions for serialising
and sending requests to DDGC JSON service components.

The Cookie header is forwarded in the request, so requested services can work
as part of the same auth realm.

Incoming JSON data is deserialised to Perl data and made available in the
response at key C<ddgcr>.

For POST requests, request parameters are serialised to JSON.

=head1 FUNCTIONS

=head2 ddgcr_get

Make a GET request to a service. Returns a L<HTTP::Response> instance. Returned
Perl data is available at key C<ddgcr>.

    my $response = ddgcr_get [ 'Blog', 'post', 'by_url' ], { url => $url };

or

    my $response = ddgcr_get [ qw/ Blog post by_url / ], { url => $url };

or

    my $response = ddgcr_get [ 'Blog', 'post/by_url' ], { url => $url };

or

    my $response = ddgcr_get '/blog.json/post/by_url', { url => $url };

then

    if ( $response->is_success ) {
        template 'blog', { post => $response->{ddgcr}->{post} }
    }

=head2 ddgcr_post

Make a POST request to a service. Returns a L<HTTP::Response> instance. Returned
Perl data is available by key ddgcr.

    my $response = ddgcr_post [ qw/ Blog admin post new / ], {
        title => params('body')->{title},
        tags  => params('body')->{tags},
        ...
    };
    if ( !$response->is_success ) {
        send error $response->message, $response->code;
    }

Request parameters are serialised to JSON. Perl data is available by key C<ddgcr>.

=cut
