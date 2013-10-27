package DDGC::Web::Controller::My::Notifications;
# ABSTRACT: Notifications editor

use Moose;
BEGIN {extends 'Catalyst::Controller'; }

use DateTime;
use namespace::autoclean;

sub base :Chained('/my/logged_in') :PathPart('notifications') :CaptureArgs(0) {
	my ( $self, $c ) = @_;
	$c->add_bc('Notifications', $c->chained_uri('My::Notifications','index'));
	$c->stash->{notification_cycle_options} = [
		{ value => 0, name => "No, thanks!" },
		#{ value => 1, name => "Instant" },
		{ value => 2, name => "Hourly" },
		{ value => 3, name => "Daily" },
		{ value => 4, name => "Weekly" },
	];
	$c->stash->{default_types_def} = $c->d->rs('User::Notification::Group')->result_class->default_types_def;
}

sub index :Chained('base') :PathPart('') :Args(0) {
	my ( $self, $c ) = @_;
	unless ($c->user->search_related('user_notifications')->count) {
    $c->response->redirect($c->chained_uri('My::Notifications','edit',{ first_time => 1 }));
    return $c->detach;
	}
	my $limit = $c->req->param('all') && $c->user->admin
		? undef : 40;
	$c->stash->{undone_notifications} = $c->user->undone_notifications($limit);
	$c->stash->{undone_notifications_count} = $c->user->undone_notifications_count;
	$c->bc_index;
}

sub edit :Chained('base') :Args(0) {
	my ( $self, $c ) = @_;
	$c->add_bc('Configuration');
	if ($c->req->param('save_notifications')) {
		$c->require_action_token;
		my @types = $c->req->param('type');
		my @cycles = $c->req->param('cycle');
		my @context_ids = $c->req->param('context_id');
		while (@types) {
			my $type = shift @types;
			my $cycle = shift @cycles;
			my $context_id = shift @context_ids;
			my $with_context_id = $context_id eq '*' ? 1 : 0;
			$c->user->add_type_notification($type,$cycle,$with_context_id);
		}
	}
	$c->stash->{user_notification_group_values} = $c->user->user_notification_group_values;
}

sub following :Chained('base') :Args(0) {
	my ( $self, $c ) = @_;
	$c->add_bc('Following');
	$c->stash->{user_notifications} = $c->user->search_related('user_notifications',{
		context_id => { '!=' => undef },
	},{
		join => [qw( user_notification_group )],
	});
}

sub all_done :Chained('base') :Args(0) {
	my ( $self, $c ) = @_;
	$c->stash->{delete_count} = $c->d->rs('Event::Notification')->search({
		'user_notification.users_id' => $c->user->id,
	},{
		prefetch => [qw( user_notification )],
	})->delete;
  $c->response->redirect($c->chained_uri('My::Notifications','index',{
  	all_notifications_done => $c->stash->{delete_count},
  }));
  return $c->detach;
}

sub done_base :Chained('base') :PathPart("") :CaptureArgs(1) {
	my ( $self, $c, $id ) = @_;
	$c->stash->{event_notification_group_id} = $id+0;
	return $c->detach unless $c->stash->{event_notification_group_id};
	$c->stash->{delete_count} = $c->d->rs('Event::Notification')->search({
		'user_notification.users_id' => $c->user->id,
		'event_notification_group.id' => $c->stash->{event_notification_group_id},
	},{
		prefetch => [qw( user_notification event_notification_group )],
	})->delete;
}

sub done :Chained('done_base') :Args(0) {
	my ( $self, $c ) = @_;
	$c->response->body('OK '.$c->stash->{delete_count});
  return $c->detach;
}

sub done_goto :Chained('done_base') :Args(0) {
	my ( $self, $c ) = @_;
	my $event_notification_group = $c->d->rs('Event::Notification::Group')->find($c->stash->{event_notification_group_id});
	my $redirect = $event_notification_group->u
		? $c->chained_uri(@{$event_notification_group->u})
		: $c->chained_uri('My::Notification','index');
  $c->response->redirect($redirect);
  return $c->detach;
}

sub unfollow :Chained('base') :Args(1) {
	my ( $self, $c, $id ) = @_;
	my $user_notification = $c->user->search_related('user_notifications',{
		id => $id
	})->first;
	if ($user_notification) {
		$user_notification->delete;
	}
  $c->response->redirect($c->chained_uri('My::Notifications','following'));
  return $c->detach;
}

no Moose;
__PACKAGE__->meta->make_immutable;
