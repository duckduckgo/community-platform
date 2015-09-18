package DDGC::Schema::Role::Result::User::Subscription;
use strict;
use warnings;

use Moo::Role;

# 'subscriptions' would refer to the User::Subscriptions rs
has subscription_types => (
    is => 'ro',
    lazy => 1,
    builder => '_build_subscriptions',
);
sub _build_subscriptions {
    $_[0]->app->config->{ddgc_config}->subscriptions;
}

sub subscribe_to_instant_answer {
    my ( $self, $ia_id ) = @_;

    return 0 if ( !$ia_id );
    $self->find_or_create_related( 'subscriptions',
        $self->subscription_types->ia_page( $ia_id ),
    );
}

sub unsubscribe_from_instant_answer {
    my ( $self, $ia_id ) = @_;

    return 0 if ( !$ia_id );
    my $sub = $self->subscriptions->search(
        $self->subscription_types->ia_page( $ia_id ),
    )->one_row;
    return 0 if ( !$sub );
    return $sub->delete;
}

1;
