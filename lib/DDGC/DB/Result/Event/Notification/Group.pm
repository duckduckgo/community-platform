package DDGC::DB::Result::Event::Notification::Group;
# ABSTRACT: A visual group for an event

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'event_notification_group';

column id => {
	data_type => 'bigint',
	is_auto_increment => 1,
};
primary_key 'id';

column user_notification_group_id => {
	data_type => 'bigint',
	is_nullable => 0,
};

sub group_context { $_[0]->user_notification_group->group_context }

column group_context_id => {
	data_type => 'bigint',
	is_nullable => 0,
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

has_many 'event_notifications', 'DDGC::DB::Result::Event::Notification', 'event_notification_group_id', {
	cascade_delete => 1,
};
belongs_to 'user_notification_group', 'DDGC::DB::Result::User::Notification::Group', 'user_notification_group_id', {
	on_delete => 'cascade',
};

unique_constraint [qw/ user_notification_group_id group_context_id /];

__PACKAGE__->indices(
	event_notification_group_group_context_id_idx => 'group_context_id',
);

sub first_event_notification {
	my ( $self ) = @_;
	my @event_notifications = $self->event_notifications;
	return scalar @event_notifications
		? $event_notifications[0]
		: undef;
}

sub icon { $_[0]->user_notification_group->icon }

sub u {
	my ( $self, @args ) = @_;
	my $ung_u = $self->user_notification_group->u;
	if ($ung_u) {
		return $ung_u->($self,@args);
	}
	my $group_object = $self->group_object;
	if ($group_object) {
		return $group_object->u(@args) if ($group_object && $group_object->can('u'));;
	}
	return ['Root','index',{ notification_link_error => 1 }]
}

sub group_object {
	my ( $self ) = @_;
	my $event_notification = $self->event_notifications->one_row;
	if ($self->user_notification_group->sub_context eq '') {
		return $event_notification->event->get_context_obj;
	}
	return $event_notification->event->get_related($self->group_context);
}

###############################

no Moose;
__PACKAGE__->meta->make_immutable ( inline_constructor => 0 );
