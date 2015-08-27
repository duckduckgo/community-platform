package DDGC::Schema::ResultSet::User::Subscription;

# ABSTRACT: Resultset class for user subscriptions

use Moo;
extends 'DDGC::Schema::ResultSet';
use List::MoreUtils qw( uniq );

sub activity {
    my ( $self ) = @_;
    map { $_->activity } $self->all;
}

1;
