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
		{ value => 1, name => "Instant" },
		{ value => 2, name => "Hourly" },
		{ value => 3, name => "Daily" },
		{ value => 4, name => "Weekly" },
	];
}

sub index :Chained('base') :PathPart('') :Args(0) {
	my ( $self, $c ) = @_;
	unless ($c->user->search_related('user_notifications')->count) {
    $c->response->redirect($c->chained_uri('My::Notifications','edit',{ first_time => 1 }));
    return $c->detach;
	}
	$c->pager_init($c->action,20);
	$c->stash->{undone_notifications} = $c->user->undone_notifications($c->stash->{page},$c->stash->{pagesize});
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

sub done :Chained('base') :Args(1) {
	my ( $self, $c, $id ) = @_;
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
