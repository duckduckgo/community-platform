package DDGC::Schema::ResultSet;

# ABSTRACT: DBIC ResultSet base class

use Carp;
use Moo;
extends 'DBIx::Class::ResultSet';

sub schema { $_[0]->result_source->schema };
sub app { $_[0]->schema->app };
sub ddgc_config { $_[0]->schema->ddgc_config };


sub current_user {
    my ( $self ) = @_;
    return if !$self->app->can('var');
    return $self->app->var('user');
}

sub format_datetime {
    my $self = shift;
    $self->result_source->schema->storage->datetime_parser->format_datetime(@_);
}

sub all_ref {
  [ $_[0]->all ];
}

sub having { shift->search_rs( undef, { having => shift } ) }

__PACKAGE__->load_components(qw/
    Helper::ResultSet::Me
    Helper::ResultSet::Shortcut
    Helper::ResultSet::OneRow
/);

1;
