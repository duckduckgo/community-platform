package DDGC::Schema::ResultSet::Comment;

# ABSTRACT: Resultset class for blog posts

use Moo;
extends 'DDGC::Schema::ResultSet';
use List::Util qw/ min /;

has nest_comments => (
    is  => 'rw',
    default => sub { 1 },
);

sub flat {
    my ( $self ) = @_;
    $self->nest_comments(0);
    return $self;
}

sub threaded {
    my ( $self ) = @_;
    $self->nest_comments(1);
    return $self;
}

# Build a nested data structure using adjacency list data (parent / child links)
# TODO: This hits the database more than is strictly necessary. It could maybe
# be a virtual view with a postgres WITH RECURSIVE... function.
#
# Difference between requesting nested vs flat data in dev is ~60ms
sub nest {
    my ( $self, $level ) = @_;
    my $tree = [];
    $level //= 1;
    my $toplevel = min map { $_ // 0 } $self->get_column('parent_id')->all;

    while ( my $comment = $self->next ) {
        if ( ( $comment->parent_id // 0 ) == $toplevel ) {
            my $comment_JSON = $comment->TO_JSON;
            $comment_JSON->{level} = $level;
            $comment_JSON->{children} = ( $comment->children )
                ? $comment->children->nest( $level + 1 )
                : [];
            push @{$tree}, $comment_JSON;
        }
    }
    return $tree;
}

sub TO_JSON {
    my ( $self ) = @_;
    return [ map { $_->TO_JSON } $self->all ] if !$self->nest_comments;
    return $self->nest;
}

1;
