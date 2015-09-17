use strict;
use warnings;
package DDGC::Config::Subscriptions;
# ABSTRACT: SQL::Abstract stanzas for DBIC to retrieve / generate Activity

use Moo;

sub _subscription {
    my ( $self, $category, $action, $meta ) = @_;
    +{
        category     => $category,
        action       => $action,
        meta1        => $meta->{meta1} // undef,
        meta2        => $meta->{meta2} // undef,
        meta3        => $meta->{meta3} // undef,
        ( $meta->{description} )
            ? ( description  => $meta->{description} )
            : (),
    };
}

sub created_ia_page {
    my ( $self, $meta ) = @_;
    $self->_subscription(
        'instant_answer',
        'created',
        $meta,
    );
}

sub updated_ia_page {
    my ( $self, $meta ) = @_;
    $self->_subscription(
        'instant_answer',
        'updated',
        $meta,
    );
}

sub ia_page {
    my ( $self, $id ) = @_;
    $self->updated_ia_page( { meta1 => $id } );
}

1;
