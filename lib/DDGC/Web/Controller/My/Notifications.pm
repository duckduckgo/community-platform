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
		{ value => 0, name => "NEVER!!" },
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
	$c->stash->{undone_notifications} = [ $c->user->undone_notifications($limit)->all ];
	$c->stash->{undone_notifications_count} = $c->user->undone_notifications_count;
	$c->bc_index;
}

sub edit :Chained('base') :Args(0) {
	my ( $self, $c ) = @_;
	$c->add_bc('Configuration');
	if ($c->req->param('save_notifications')) {
		$c->require_action_token;
		for (keys %{$c->req->params}) {
			if ($_ =~ m/^([a-zA-Z_]+)(\d)$/) {
				my $type = $1;
				my $with_context_id = $2;
				my $cycle = $c->req->param($_);
				$c->user->add_type_notification($type,$cycle,$with_context_id);
			}
		}
		if (defined $c->req->param('email_notification_content')) {
			$c->user->email_notification_content($c->req->param('email_notification_content') ? 1 : 0);
		}
		$c->user->update;
	}
	$c->stash->{user_notification_group_values} = $c->user->user_notification_group_values;
}

sub following :Chained('base') :Args(0) {
	my ( $self, $c ) = @_;
	$c->add_bc('Following');
	$c->pager_init($c->action,'30');
	$c->stash->{user_notification_matrixes} = $c->user->search_related('user_notification_matrixes',{
		'me.context_id' => { '!=' => undef },
	},{
		order_by => { -desc => 'me.created' },
	})->prefetch_all->paging($c->stash->{page},$c->stash->{pagesize});
}

sub all_done :Chained('base') :Args(0) {
	my ( $self, $c ) = @_;
	$c->stash->{delete_count} = $c->d->rs('Event::Notification')->search({
		'user_notification.users_id' => $c->user->id,
	},{
		prefetch => [qw( user_notification )],
	})->delete;
	$c->user->undone_notifications->cursor->clear_cache;
	$c->user->undone_notifications_count_resultset->cursor->clear_cache;
  $c->response->redirect($c->chained_uri('My::Notifications','index',{
  	all_notifications_done => $c->stash->{delete_count},
  }));
  return $c->detach;
}

sub done_base :Chained('base') :PathPart("") :CaptureArgs(1) {
	my ( $self, $c, $id ) = @_;
	$c->stash->{event_notification_group_id} = $id+0;
	return $c->detach unless $c->stash->{event_notification_group_id};
}

sub done_resultset {
	my ( $self, $c, $event_notification_group_id ) = @_;
	$c->d->rs('Event::Notification')->search_rs({
		'user_notification.users_id' => $c->user->id,
		'event_notification_group.id' => $event_notification_group_id,
	},{
		prefetch => [qw( user_notification event_notification_group )],
	});
}

sub done :Chained('done_base') :Args(0) {
	my ( $self, $c ) = @_;
	my $count = $self->done_resultset($c,$c->stash->{event_notification_group_id})->delete;
	$c->response->body('OK '.$count);
	$c->user->undone_notifications->cursor->clear_cache;
	$c->user->undone_notifications_count_resultset->cursor->clear_cache;
  return $c->detach;
}

sub done_goto :Chained('done_base') :Args(0) {
	my ( $self, $c ) = @_;
	my $event_notification_group = $c->d->rs('Event::Notification::Group')->find($c->stash->{event_notification_group_id});
	my $redirect = $event_notification_group->u
		? $c->chained_uri(@{$event_notification_group->u})
		: $c->chained_uri('My::Notification','index');
	$self->done_resultset($c,$c->stash->{event_notification_group_id})->delete;
  $c->response->redirect($redirect);
	$c->user->undone_notifications->cursor->clear_cache;
	$c->user->undone_notifications_count_resultset->cursor->clear_cache;
  return $c->detach;
}

sub unfollow :Chained('base') :Args(1) {
	my ( $self, $c, $id ) = @_;
	$c->require_action_token;
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
