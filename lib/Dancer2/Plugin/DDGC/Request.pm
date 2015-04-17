package Dancer2::Plugin::DDGC::Request;

use strict;
use warnings;

use LWP::Protocol::Net::Curl;
use LWP::UserAgent;
use HTTP::Request;
use JSON;
use Dancer2::Plugin;

my $ua = LWP::UserAgent->new( timeout => 5 );

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
            Cookie => 'plack_session=' . $dsl->session->id,
        );
    }
}
on_plugin_import {
    my ( $dsl ) = @_;
    die "Need to load Dancer2::Plugin::RootURIFor before Dancer2::Plugin::DDGC::Request" if !($dsl->can('root_uri_for'));
};

register ddgcr_get => sub {
    my ( $dsl, $route, $params ) = @_;

    my $req = HTTP::Request->new(
        GET => _uri_for( $dsl, $route, $params )
    );
    _apply_session_to_req( $dsl, $req );

    my $res = $ua->request( $req );
    $res->{ddgcr} = ( $res->is_success )
        ? JSON::from_json( $res->decoded_content )
        : undef;
    return $res;
};

register ddgcr_post => sub {
    my ( $dsl, $route, $data ) = @_;

    $data = to_json($data, { convert_blessed => 1 }) if ref $data;
    my $req = HTTP::Request->new(
        POST => _uri_for( $dsl, $route )
    );
    $req->content_type( 'application/json' );
    $req->content( $data );
    _apply_session_to_req( $dsl, $req );

    $ua->request( $req );
};

register_plugin;

1;
