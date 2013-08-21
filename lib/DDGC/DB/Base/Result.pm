package DDGC::DB::Base::Result;
# ABSTRACT: Base class for all DBIx::Class Result base classes of the project

use Moose;
use MooseX::NonMoose;
extends 'DBIx::Class::Core';
use namespace::autoclean;

__PACKAGE__->load_components(qw/
    TimeStamp
    InflateColumn::DateTime
    InflateColumn::Serializer
    EncodedColumn
/);

sub default_result_namespace { 'DDGC::DB::Result' }

sub ddgc { shift->result_source->schema->ddgc }
sub schema { shift->result_source->schema }

sub add_event {
	my ( $self, $action, %args ) = @_;
	my %event;
	$event{context} = ref $self;
	$event{context_id} = $self->id;
	my $users_id;
	if ($self->can('users_id')) {
		$users_id = $self->users_id;
	} elsif ($self->can('user')) {
		$users_id = $self->user->id
	}
	$users_id = delete $args{users_id} if defined $args{users_id};
	if ($users_id) {
		$event{users_id} = $users_id;
	}
	$event{action} = $action;
	if ($self->can('event_related')) {
		$event{related} = [$self->event_related, defined $args{related} ? @{delete $args{related}} : ()];
	}
	if ($args{related}) {
		$event{related} = [] unless defined $event{related};
		my $related = delete $args{related};
		push @{$event{related}}, @{$related};
	}
	$event{data} = \%args if %args;
	my $event_result = $self->result_source->schema->resultset('Event')->create({ %event });
	for (@{$event{related}}) {
		$event_result->create_related('event_relates',{
			context => $_->[0],
			context_id => $_->[1],
		});
	}
}

sub has_context {
	my ( $self ) = @_;
	return $self->does('DDGC::DB::Role::HasContext');
}

sub comments {
	my ( $self ) = @_;
	return $self->schema->resultset('Comment')->search({
		context => $self->i_context,
		context_id => $self->i_context_id,
		parent_id => undef,
	});
}

sub i_context {
	my ( $self ) = @_;
	my $ref = ref $self;
	return $ref;
}

sub i_context_id {
	my ( $self ) = @_;
	return $self->id;
}

sub belongs_to {
	my ($self, @args) = @_;

	$args[3] = {
		is_foreign => 1,
		on_update => 'cascade',
		on_delete => 'restrict',
		%{$args[3]||{}}
	};

	$self->next::method(@args);
}

use overload '""' => sub {
	my $self = shift;
	return (ref $self).' #'.$self->id;
}, fallback => 1;

no Moose;
__PACKAGE__->meta->make_immutable;
