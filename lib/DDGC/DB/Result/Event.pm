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

has_many 'event_notifications', 'DDGC::DB::Result::Event::Notification', 'event_id';
has_many 'event_relates', 'DDGC::DB::Result::Event::Relate', 'event_id';

__PACKAGE__->indices(
	event_context_idx => 'context',
	event_context_id_idx => 'context_id',
	event_created_idx => 'created',
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
		$self->schema->txn_do(sub {
			my %notified_user_ids;
			for my $user_notification (@user_notifications) {
				next if defined $notified_user_ids{$user_notification->users_id};
				next if $self->users_id && $user_notification->users_id eq $self->users_id;
				if ($user_notification->user_notification_group->filter) {
					next unless $user_notification->user_notification_group->filter->(
						$user_notification->user_notification_group->sub_context eq ''
							? $self->get_context_obj
							: $self->get_related($user_notification->user_notification_group->context),
						$self
					);
				}
				if ($user_notification->user_notification_group->filter_by_language) {
					next unless $language_id;
					my $has_language = 0;
					for ($user_notification->user->user_languages) {
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
			$self->notified(1);
			$self->update;
		});
	} else {
		$self->notified(1);
		$self->update;
	}
}

	# my @language_results = $self->ddgc->rs('Language')->search_rs({})->all;
	# my ( $english ) = grep { $_->locale eq 'en_US'} @language_results;
	# my %languages = map { $_->id => $_->locale } @language_results;
	# for my $event (@events) {
	# 	my $own_context = $event->context;
	# 	my $own_context_id = $event->context_id;
	# 	my @related = $event->related ? @{$event->related} : ();
	# 	my @language_ids;
	# 	my @queries = (
	# 		{
	# 			'me.context' => $own_context,
	# 			'me.context_id' => { '=' => [ $own_context_id, undef ] },
	# 			'me.sub_context' => undef
	# 		},
	# 		map {
	# 			my ( $context, $context_id ) = @{$_};
	# 			if ($context eq 'DDGC::DB::Result::Language') {
	# 				push @language_ids, $context_id unless $context_id != $english->id;
	# 			}
	# 			{
	# 				'me.context' => $context,
	# 				'me.context_id' => { '=' => [ $context_id, undef ] },
	# 				'me.sub_context' => $own_context
	# 			},
	# 			{
	# 				'me.context' => $context,
	# 				'me.context_id' => { '=' => [ $context_id, undef ] },
	# 				'me.sub_context' => undef
	# 			},
	# 		} @related
	# 	);
	# 	my @user_notifications = $self->ddgc->db->resultset('User::Notification')->search_rs({
	# 		-or => [@queries],
	# 	})->all;
	# 	for my $un (@user_notifications) {
	# 		if (@language_ids) {
	# 			next unless grep { $un->user->can_speak($languages{$_}) } @language_ids;
	# 		}
	# 		next unless !$event->users_id || $un->users_id != $event->users_id;
	# 		$event->create_related('event_notifications',{
	# 			users_id => $un->users_id,
	# 			cycle => $un->cycle,
	# 			cycle_time => $un->cycle_time,
	# 		});
	# 	}
	# 	$event->language_ids(\@language_ids);
	# 	$event->notified(1);
	# 	$event->update;
	# }

no Moose;
1;
# will get method modified in deploy case
#__PACKAGE__->meta->make_immutable;
