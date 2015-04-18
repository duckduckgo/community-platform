package DDGC::Schema::ResultSet;

use Carp;
use Moo;
extends 'DBIx::Class::ResultSet';

has current_user => (
    is  => 'rw',
    isa => sub {
        confess "Not a user" if ref $_[0] ne 'DDGC::Schema::Result::User';
    },
);

sub for_user {
    my ( $self, $user ) = @_;
    $self->current_user($user) if ( $user );
    return $self;
}

__PACKAGE__->load_components('Helper::ResultSet::Me');

1;
