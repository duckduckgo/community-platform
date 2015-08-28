package DDGC::Schema::Role::Result::User::ToJSON;
use strict;
use warnings;

use Moo::Role;

sub TO_JSON {
    my ( $self ) = @_;
    my $current_user = $self->schema->current_user;
    return []
      if ( !$self->public
        && !( $current_user && ( $current_user->is('admin')
        || $current_user->id == $self->id ))
      );

    +{
        id          => $self->id,
        username    => $self->username,
        avatar16    => $self->avatar(16),
        avatar32    => $self->avatar(32),
        avatar48    => $self->avatar(48),
        public      => $self->public,
        badge       => $self->badge,
    };
}

1;
