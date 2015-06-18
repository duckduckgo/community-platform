package Dancer2::Plugin::Params::HashMultiValue;

# ABSTRACT: Run incoming request parameters through Hash::MultiValue

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

__END__

=pod

=head1 NAME

Dancer2::Plugin::Params::HashMultiValue - Run incoming request parameters
through L<Hash::MultiValue>

=head1 SYNOPSIS

   use Dancer2;
   use Dancer2::Plugin::Params::HashMultiValue;

   get '/user' => sub {
      my $username = param_hmv('user');
      ...
   };

   get '/settings' => sub {
      my $params = params_hmv;
      ...
   };

=head1 DESCRIPTION

Dancer2::Plugin::Params::HashMultiValue deals with multiple instances of the same
named request parameter. Where ordinarily they would be inflated to an array ref,
here we pick the last single value and suplpy that.

e.g. If we get a request with id specified twice:

   '/foo?id=1&id=2'

Inside the /foo handler:

   get '/foo' => sub {
      my $id = param('id'); # This is an arrayref
   }

=head1 FUNCTIONS

=head2 params_hmv

Returns a Hash::MultiValue instance containing single values taken from request
parameters.

   my $params = params_hmv;
   $params->{id};          # For a single value
   $params->get_all('id'); # If you want the array of values

=head2 param_hmv

Passed a parameter name, will return a single value for that parameter:

    my $id = param_hmv('id');

=cut
