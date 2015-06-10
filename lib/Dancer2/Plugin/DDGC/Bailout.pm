package Dancer2::Plugin::DDGC::Bailout;

# ABSTRACT: Bailing out of DDGC service request with errors

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

__END__

=pod

=head1 NAME

Dancer2::Plugin::DDGC::Bailout - Bailing out of DDGC service requests with
errors

=head1 SYNOPSIS

    use Dancer2;
    use Dancer2::Plugin::DDGC::Bailout;

    get '/' => sub {
        my $user = rset('User')->find( param('id') );
        if ( !$user ) {
            bailout 404, sprintf "User %s not found", param('id');
        }
    };

=head1 DESCRIPTION

Dancer2::Plugin::DDGC::Bailout provides C<bailout>, which will exit the current
route handler with the specified HTTP status code and errors.

This module returns Perl data structures so should only be used by services
which have a serializer configured.

=head1 FUNCTIONS

=head2 bailout

Takes two parameters, a HTTP status code and a string or arrayref containing
error messages.

Assuming we are using the JSON serializer, bailing out on validator errors
would look something like this:

    if (scalar $v->errors) {
        bailout( 400, [ $v->errors ] );
    }

This call would return the following JSON with a 400 Bad Request HTTP status:

    {
        "ok": 0,
        "errors":
        [
            "bad value 'abc' for 'id': must be an integer"
        ],
        "status": 400
    }

=cut
