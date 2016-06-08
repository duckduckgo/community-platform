package DDGC::Schema::Role::Result::User::Profile;
use strict;
use warnings;

use Moo::Role;
use File::Spec::Functions;

sub verified_userpage {
    my ( $self ) = @_;
    return if !$self->github_id;
    return if !$self->github_user;
    my $d = catdir( '/home/ddgc/ddgc/ddh-userpages', lc( $self->github_user ) );
    return if ( ! -d $d );
    return URI->new(
        sprintf( 'https://duckduckhack.com/u/%s#tutorial', lc( $self->github_user ) )
    )->canonical;
}

1;
