package DDGC::Schema::ResultSet::User::Blog;

# ABSTRACT: Resultset class for blog posts

use Moo;
extends 'DDGC::Schema::ResultSet';
use List::MoreUtils qw( uniq );

sub live {
    my ($self) = @_;
    $self->search(
        {
            live => 1,
        }
    );
}

sub company_blog {
    my ( $self ) = @_;
    return $self->search(
        {
            $self->me . 'company_blog' => 1,
            ( $self->current_user && $self->current_user->is('admin') )
            ? ()
            : ( $self->me . 'live' => 1 ),
        }
    );
}

sub filter_by_topic {
    my ( $self, $topic ) = @_;
    return $self->search(
        {
            $self->me . 'topics' => { like => sprintf( '%%%s%%', $topic ) }
        }
    );
}

# This is an attempt to get the full set of topics efficiently with distinct
# TODO: many-to-many rel with a topics entity
sub topics {
    my ( $self ) = @_;
    uniq sort map { $_->topics ? @{$_->topics} : () } $self->search({}, {
        columns => [qw/ topics /],
        distinct => 1,
    })->all;
}

sub TO_JSON {
    my ( $self ) = @_;
    [ map { $_->TO_JSON } $self->all ];
}

1;
