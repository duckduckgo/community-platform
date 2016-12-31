package DDGC::Schema::Result::Comment;
# ABSTRACT: Comment result class

use Moo;
extends 'DDGC::Schema::Result';
use DBIx::Class::Candy;
use DDGC::Util::DateTime qw/ dur /;

table 'comment';

column id => {
    data_type => 'bigint',
    is_auto_increment => 1,
};
primary_key 'id';

column users_id => {
    data_type => 'bigint',
    is_nullable => 1,
};

column content => {
    data_type => 'text',
    is_nullable => 0,
};

column deleted => {
    data_type => 'int',
    default_value => 0,
};

column readonly => {
    data_type => 'int',
    default_value => 0,
};

column is_html => {
    data_type => 'int',
    default_value => 0,
};

column data => {
    data_type => 'text',
    is_nullable => 0,
    serializer_class => 'JSON',
    default_value => '{}',
};

column created => {
    data_type => 'timestamp with time zone',
    set_on_create => 1,
};

column updated => {
    data_type => 'timestamp with time zone',
    set_on_create => 1,
    set_on_update => 1,
};

column parent_id => {
    data_type => 'bigint',
    is_nullable => 1,
};

column context => {
    data_type => 'text',
    is_nullable => 0,
};

column context_id => {
    data_type => 'bigint',
    is_nullable => 0,
};

column ghosted => {
    data_type => 'int',
};

belongs_to 'user',     'DDGC::Schema::Result::User',    'users_id';
has_many   'children', 'DDGC::Schema::Result::Comment', 'parent_id';
belongs_to 'parent',   'DDGC::Schema::Result::Comment', 'parent_id';

sub html {
    my ( $self ) = @_;
    return $self->app->markup->html( $self->content ) if $self->is_html;
    return $self->app->markup->bbcode( $self->content );
}

sub TO_JSON {
    my ( $self ) = @_;
    +{
        id      => $self->id,
        user    => $self->user->TO_JSON,
        content => $self->html,
        path    => "/forum/comment/" . $self->id,
        dur     => dur( $self->created ),
        parent_id => $self->parent_id,
    };
}

1;
