package Dancer2::Plugin::Params::HashMultiValue;

use strict;
use warnings;

use Hash::MultiValue;
use Dancer2::Plugin;

register params_hmv => sub {
    my ( $dsl ) = @_;
    my $request = $dsl->request;

    if ( !$request->var('plugin_params_hmv') ) {
       $request->var('plugin_params_hmv' =>
            Hash::MultiValue->from_mixed( $dsl->params )
        );
   }

    return $request->var('plugin_params_hmv');
};

register param_hmv => sub {
    my ( $dsl, $param ) = @_;
    $dsl->params_hmv->{$param};
};

register_plugin;

1;
