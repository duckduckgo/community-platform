package Dancer2::Plugin::DDGC::Bailout;

use strict;
use warnings;

use Dancer2::Plugin;

register bailout => sub {
    my ( $dsl, $status, $errors ) = @_;
    my $request = $dsl->request;
    $errors = [ $errors ] if !(ref $errors eq 'ARRAY');

    $dsl->status( $status );

    $dsl->app->response->content({
        ok      => 0,
        status  => $status,
        errors  => $errors,
    });

    $dsl->halt;
};

register_plugin;

1;

