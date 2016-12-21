package DDGC::Schema::Result;

# ABSTRACT: DBIC Result base class

use Carp;
use DateTime;
use Moo;
extends 'DBIx::Class::Core';

sub app { $_[0]->result_source->schema->app };
sub current_user {
    my ( $self ) = @_;
    return if !$self->app->can('var');
    return $self->app->var('user');
}

sub format_datetime {
    my $self = shift;
    $self->result_source->schema->storage->datetime_parser->format_datetime(@_);
}

sub now { $_[0]->format_datetime( DateTime->now ) }

__PACKAGE__->load_components(qw/
    InflateColumn::Serializer
    TimeStamp
/);

1;
