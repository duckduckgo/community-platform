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

sub nest {
    my ( $list, $level, $parent_id ) = @_;
    my $tree = [];
    $level //= 1;
    $parent_id //= min map { $_->{parent_id} // 0 } @{ $list };

    for my $comment ( @{ $list } ) {
        if ( ( $comment->{parent_id} // 0 ) == $parent_id ) {
            $comment->{level} = $level;
            $comment->{children} = nest (
                $list,
                $level + 1,
                $comment->{id},
            );
            push @{$tree}, $comment;
        }
    }
    return $tree;
}

sub TO_JSON {
    my ( $self ) = @_;
    my $JSON = [ map { $_->TO_JSON } $self->all ];
    return $JSON if !$self->nest_comments;
    return nest( $JSON );
}

1;
