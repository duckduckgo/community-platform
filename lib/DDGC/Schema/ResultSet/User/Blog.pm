package DDGC::Schema::ResultSet::User::Blog;

# ABSTRACT: Resultset class for blog posts

use Moo;
extends 'DDGC::Schema::ResultSet';
use List::MoreUtils qw( uniq );
use POSIX;

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

sub total {
    my ( $self, $topic ) = @_;
    my $rs = $self->rs('User::Blog')->company_blog;
    $rs = $rs->filter_by_topic( $topic ) if $topic;
    return $rs->count;
}

sub all_topics {
    $_[0]->rs('User::Blog')->company_blog->topics;
}

sub single_page_ref {
    my ( $self, $page, $topic ) = @_;
    $page ||= 1;

    my $posts = $self
        ->company_blog
        ->prefetch( [qw/ user comments /] )
        ->order_by( { -desc => \'coalesce( me.fixed_date, me.created )' } )
        ->rows( 20 )
        ->page( $page );

    $posts = $posts->filter_by_topic( $topic ) if $topic;

    return +{
        posts  => $posts->TO_JSON,
        topics => [ $self->all_topics ],
        page   => $page,
        pages  => ceil( $self->total( $topic ) / 20 ),
    };
}

sub single_post_rs {
    $_[0]->company_blog
         ->prefetch( { user => 'roles'} )
         ;
}

sub post_to_ref {
    my ( $self, $post ) = @_;
    return {} unless $post;
    +{
        post     => $post->TO_JSON,
        comments => $post->comments->prefetch('user')
                    ->order_by({ -desc => 'me.created' })
                    ->threaded
                    ->TO_JSON,
        topics   => [ $self->all_topics ],
    }
}

sub single_post_ref {
    my ( $self, $id ) = @_;
    my $post = $self->single_post_rs->find( $id );
    $self->post_to_ref( $post );
}

sub single_post_by_uri_ref {
    my ( $self, $uri ) = @_;
    my $post = $self->single_post_rs->search({
        uri => $uri
    })->one_row;
    $self->post_to_ref( $post );
}

sub TO_JSON {
    my ( $self ) = @_;
    [ map { $_->TO_JSON } $self->all ];
}

1;
