package DDGC::Schema::ResultSet;

# ABSTRACT: DBIC ResultSet base class

use Carp;
use Moo;
extends 'DBIx::Class::ResultSet';

sub app { $_[0]->result_source->schema->app };
sub current_user {
    my ( $self ) = @_;
    return if !$self->app->can('var');
    return $self->app->var('user');
}

__PACKAGE__->load_components(qw/
    Helper::ResultSet::Me
    Helper::ResultSet::Shortcut
/);

1;
