package DDGC::Schema::Result;

# ABSTRACT: DBIC Result base class

use Carp;
use Moo;
extends 'DBIx::Class::Core';

sub schema { $_[0]->result_source->schema; }
sub app { $_[0]->schema->app }
sub ddgc_config { $_[0]->schema->ddgc_config }

sub current_user {
    my ( $self ) = @_;
    return if !$self->app->can('var');
    return $self->app->var('user');
}

__PACKAGE__->load_components(qw/
    InflateColumn::Serializer
    TimeStamp
/);

1;
