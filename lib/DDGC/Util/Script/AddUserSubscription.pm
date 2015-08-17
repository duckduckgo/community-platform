use strict;
use warnings;
package DDGC::Util::Script::AddUserSubscription;

use Carp;
use Moo;

with 'DDGC::Util::Script::Base::Service';

has subscriptions => (
    is      => 'ro',
    lazy    => 1,
    builder => '_build_subscriptions',
);

sub _build_subscriptions {
    $_[0]->ddgc_config->subscriptions;
}

has user => (
    is      => 'ro',
    lazy    => 1,
    builder => '_build_user',
    isa     => sub {
        croak "Invalid user or user not found"
          if ref $_[0] ne 'DDGC::Schema::Result::User';
    }
);
sub _build_user {
    my ( $self ) = @_;
    rset('User')->find_by_username( $self->sub->{user} );
}

has sub => (
    is  => 'ro',
    isa     => sub {
        croak "'sub' should be a hashref"
          if ref $_[0] ne 'HASH';
    }
);

sub add_user_subscription {
    my ( $self ) = @_;
    my $sub = $self->sub->{sub};

    $self->user->find_or_create_related( 'subscriptions',
         $self->subscriptions->$sub({
            meta1 => $self->sub->{meta1},
            meta2 => $self->sub->{meta2},
            meta3 => $self->sub->{meta3},
        })
    );
}

sub execute {
    my ( $self ) = @_;

    croak sprintf( "Unknown subscription type %s", $self->sub->{sub} // "" )
      if !$self->subscriptions->can( $self->sub->{sub} );
    return $self->add_user_subscription;
}

1;
