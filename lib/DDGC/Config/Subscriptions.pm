use strict;
use warnings;
package DDGC::Config::Subscriptions;
# ABSTRACT: SQL::Abstract stanzas for DBIC to retrieve / generate Activity

use Moo;

sub created_ia_pages {
    my ( $self ) = @_;
    +{
        category     => 'instant_answer',
        action       => 'created',
        meta1        => undef,
        meta2        => undef,
        meta3        => undef,
    };
}

sub created_ia_page {
    my ( $self, $meta ) = @_;
    +{
        category     => 'instant_answer',
        action       => 'created',
        meta1        => $meta->{1} // undef,
        meta2        => $meta->{2} // undef,
        meta3        => $meta->{3} // undef,
        ( $meta->{description} )
            ? ( description  => $meta->{description} )
            : (),
    };
}

sub updated_ia_pages {
    my ( $self ) = @_;
    +{
        category     => 'instant_answer',
        action       => 'updated',
        meta1        => undef,
        meta2        => undef,
        meta3        => undef,
    };
}

sub updated_ia_page {
    my ( $self, $meta ) = @_;
    +{
        category     => 'instant_answer',
        action       => 'updated',
        meta1        => $meta->{1} // undef,
        meta2        => $meta->{2} // undef,
        meta3        => $meta->{3} // undef,
        ( $meta->{description} )
            ? ( description  => $meta->{description} )
            : (),
    };
}

1;