package DDGC::DB::Base::Result;

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
	$event{data} = \%args if %args;
	$self->result_source->schema->resultset('Event')->create({ %event });
}

sub has_context {
	my ( $self ) = @_;
	return $self->does('DDGC::DB::Role::HasContext');
}

# sub description {
# 	my ( $self ) = @_;
# 	join(" ",map { $self->text_description_list($_) } $self->description_list);
# }

# sub sub_description {
# 	my ( $self ) = @_;
# 	join(" ",map { $self->text_description_list($_) } $self->sub_description_list);
# }

# sub text_description_list {
# 	my ( $self, $item ) = @_;
# 	my $ref = ref $item;
# 	if ($ref eq 'HASH') {
# 		die (ref $self)." hashref in description list, not supported yet";
# 	} elsif ($ref eq 'HASH') {
# 		die (ref $self)." arrayref in description list, not supported yet";
# 	} elsif ($ref) {
# 		return $item->sub_description_list;
# 	} else {
# 		return $item;
# 	}
# }

# sub description_list {
# 	my ( $self ) = @_;
# 	return ("$self");
# }

# sub sub_description_list { shift->description_list }

use overload '""' => sub {
	my $self = shift;
	return (ref $self).' #'.$self->id;
}, fallback => 1;

no Moose;
__PACKAGE__->meta->make_immutable;
