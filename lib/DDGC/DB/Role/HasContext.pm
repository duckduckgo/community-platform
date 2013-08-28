package DDGC::DB::Role::HasContext;
# ABSTRACT: A role for classes which uses the context / context_id concept

use Moose::Role;

requires qw(
	context
	context_id
);

sub context_resultset {
	my ( $self ) = @_;
	return $self->context =~ m/^DDGC::DB::Result::(.*)$/ ? $1 : '';
}

sub get_context_obj {
	my ( $self ) = @_;
  my $context_config = $self->context_config;
  if (defined $self->context_config->{$self->context}->{relation}) {
    my $function = $self->context_config->{$self->context}->{relation};
    return $self->$function;
  }
	if ( $self->context_resultset ) {
		return $self->result_source->schema->resultset($self->context_resultset)->find($self->context_id);
	}
	return;
}

1;