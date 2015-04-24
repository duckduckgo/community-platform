package Dancer2::Plugin::DDGC::Bailout;

use strict;
use warnings;

use Dancer2::Plugin;

register bailout => sub {
    my ( $dsl, $status, $errors ) = @_;
    my $request = $dsl->request;
    $errors = [ $errors ] if !(ref $errors eq 'ARRAY');

    $dsl->status( $status );
    +{
        ok      => 0,
        status  => $status,
        errors  => $errors,
    }
};

register_plugin;

1;

