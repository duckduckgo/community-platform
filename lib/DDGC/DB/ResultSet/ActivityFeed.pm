package DDGC::DB::ResultSet::ActivityFeed;
# ABSTRACT: ResultSet class for activity feed, notifications

use Moo;
extends 'DDGC::DB::Base::ResultSet';

sub updated_ia {
    my ( $self, $params ) = @_;

    $self->create(
        $self->ddgc->config->subscriptions->updated_ia_page(
            $params
        )
    );
}

sub created_ia {
    my ( $self, $params ) = @_;

    $self->create(
        $self->ddgc->config->subscriptions->created_ia_page(
            $params
        )
    );
}

1;
