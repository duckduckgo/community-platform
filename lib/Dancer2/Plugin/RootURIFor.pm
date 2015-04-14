package Dancer2::Plugin::RootURIFor;

use strict;
use warnings;

use URI::Escape;
use Dancer2::Plugin;

register root_uri_for => sub {
    my ( $dsl, $part, $params, $dont_escape ) = @_;
    my $request = $dsl->app->request;
    my $uri     = $request->base;

    $part =~ s{^/*}{/};
    $uri->path("$part");

    $uri->query_form($params) if $params;

    return $dont_escape
      ? uri_unescape( ${ $uri->canonical } )
      : ${ $uri->canonical };
};

register_plugin;

1;
