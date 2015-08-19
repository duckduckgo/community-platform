package DDGC::DB::Result::Event;
# ABSTRACT: Result class of an event

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'event';

column id => {
	data_type => 'bigint',
	is_auto_increment => 1,
};
primary_key 'id';

column users_id => {
	data_type => 'bigint',
	is_nullable => 1,
};

column action => {
	data_type => 'text',
	is_nullable => 0,
};

__PACKAGE__->add_context_relations;

column notified => {
	data_type => 'int',
	is_nullable => 0,
	default_value => 0,
};

column data => {
	data_type => 'text',
	is_nullable => 1,
	serializer_class => 'JSON',
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

# node id
column nid => {
	data_type => 'int',
	is_nullable => 0,
};

# process id on node
column pid => {
	data_type => 'int',
	is_nullable => 0,
};

belongs_to 'user', 'DDGC::DB::Result::User', 'users_id', { join_type => 'left' };

has_many 'event_notifications', 'DDGC::DB::Result::Event::Notification', 'event_id', {
	cascade_delete => 1,
};

has_many 'event_relates', 'DDGC::DB::Result::Event::Relate', 'event_id', {
	cascade_delete => 1,
};

__PACKAGE__->indices(
	event_context_idx => 'context',
	event_context_id_idx => 'context_id',
	event_created_idx => 'created',
	event_nid_idx => 'nid',
	event_pid_idx => 'pid',
);

before insert => sub {
	my ( $self ) = @_;
	$self->nid($self->ddgc->config->nid);
	$self->pid($self->ddgc->config->pid);
};

sub get_related {
	my ( $self, $context ) = @_;
	for ($self->event_relates) {
		if ($_->context eq $context) {
			return $_->get_context_obj;
		}
	}
}

sub notify {
	my ( $self ) = @_;
	return if $self->notified;
	$self->schema->txn_do(sub {
		my $own_context = $self->context;
		my $own_context_id = $self->context_id;
		my $action = $self->action;
		my @related;
		my $language_id;
		for ($self->event_relates) {
			push @related, [ $_->context, $_->context_id ];
			$language_id = $_->context_id if $_->context eq 'DDGC::DB::Result::Language';
		}
		my @queries = ({
			'user_notification_group.context' => $own_context,
			'me.context_id' => $own_context_id,
			'user_notification_group.sub_context' => '',
			'user_notification_group.action' => $action,
			'user_notification_group.with_context_id' => 1,
		},{
			'user_notification_group.context' => $own_context,
			'user_notification_group.sub_context' => '',
			'user_notification_group.action' => $action,
			'user_notification_group.with_context_id' => 0,
		});
		push @queries, map {{
			'user_notification_group.context' => $_->[0],
			'me.context_id' => $_->[1],
			'user_notification_group.sub_context' => $own_context,
			'user_notification_group.action' => $action,
			'user_notification_group.with_context_id' => 1,
		},{
			'user_notification_group.context' => $_->[0],
			'user_notification_group.sub_context' => $own_context,
			'user_notification_group.action' => $action,
			'user_notification_group.with_context_id' => 0,
		}} @related;
		my @user_notifications = $self->schema->resultset('User::Notification')->search({
			-or => \@queries,
		},{
			prefetch => [qw( user_notification_group ),{
				user => [qw( user_languages )],
			}],
			order_by => { -desc => 'user_notification_group.priority' },
		})->all;
		if (@user_notifications) {
			my %notified_user_ids;
			for my $user_notification (@user_notifications) {
				next if defined $notified_user_ids{$user_notification->users_id};
				next if $self->users_id && $user_notification->users_id eq $self->users_id;
				next unless defined $self->get_context_obj;
				my $current_user = $user_notification->user;
				next if ( !$current_user->has_access_to_notification( $self->get_context_obj ) );
				next if ( !$current_user->is_subscribed_and_notification_is_special( $self->get_context_obj ) );
				if ($user_notification->user_notification_group->filter) {
					next if 
						$user_notification->user_notification_group->sub_context ne ''
						&& !defined $self->get_related($user_notification->user_notification_group->context);
					next unless $user_notification->user_notification_group->filter->(
						$user_notification->user_notification_group->sub_context eq ''
							? $self->get_context_obj
							: $self->get_related($user_notification->user_notification_group->context),
						$current_user,
						$self
					);
				}
				if ($user_notification->user_notification_group->filter_by_language) {
					next unless $language_id;
					my $has_language = 0;
					for ($current_user->user_languages) {
						$has_language = 1 if $_->language_id eq $language_id;
					}
					next unless $has_language;
				}
				my $group_context_id = $user_notification->user_notification_group->group_context_id
					? $user_notification->user_notification_group->group_context_id->(
							$self->get_context_obj,
							$self
						)
					: $user_notification->user_notification_group->sub_context eq ''
						?	$self->get_context_obj->id
						: $self->get_related($user_notification->user_notification_group->context)->id;
				my $event_notification_group = $self->schema->resultset('Event::Notification::Group')->find_or_create({
					user_notification_group_id => $user_notification->user_notification_group->id,
					group_context_id => $group_context_id,
				},{
					key => 'event_notification_group_user_notification_group_id_group_context_id',
				});
				$self->create_related('event_notifications',{
					event_notification_group_id => $event_notification_group->id,
					user_notification_id => $user_notification->id,
				});
				$notified_user_ids{$user_notification->users_id} = 1;
			}
		}
		if ($self->result_source->resultset->find($self->id)->notified) {
			$self->schema->txn_rollback;
		} else {
			$self->notified(1);
			$self->update;
		}
	});
}

no Moose;
1;
# will get method modified in deploy case
#__PACKAGE__->meta->make_immutable ( inline_constructor => 0 );
