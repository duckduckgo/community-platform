package DDGC::Web::Controller::My::Notifications;
# ABSTRACT: Notifications editor

use Moose;
BEGIN {extends 'Catalyst::Controller'; }

use DateTime;
use namespace::autoclean;

sub base :Chained('/my/logged_in') :PathPart('notifications') :CaptureArgs(0) {
	my ( $self, $c ) = @_;
	$c->add_bc('Notifications', $c->chained_uri('My::Notifications','index'));
	$c->stash->{user_notifications} = [$c->user->user_notifications];
}

sub index :Chained('base') :PathPart('') :Args(0) {
	my ( $self, $c ) = @_;
	unless ($c->user->search_related('user_notifications')->count) {
    $c->response->redirect($c->chained_uri('My::Notifications','edit',{ first_time => 1 }));
    return $c->detach;
	}
	$c->bc_index;
}

sub edit :Chained('base') :Args(0) {
	my ( $self, $c ) = @_;
	$c->add_bc('Configuration');
	$c->stash->{notification_cycle_options} = [
		{ value => 0, name => "No, thanks!" },
		{ value => 2, name => "Hourly" },
		{ value => 3, name => "Daily" },
		{ value => 4, name => "Weekly" },
	];
	if ($c->req->param('save_notifications')) {
		$c->require_action_token;
		my @types = $c->req->param('type');
		my @cycles = $c->req->param('cycle');
		my @context_ids = $c->req->param('context_id');
		while (@types) {
			my $type = shift @types;
			my $cycle = shift @cycles;
			my $context_id = shift @context_ids;
			my @user_notification_groups = $c->d->rs('User::Notification::Group')->search({
				with_context_id => $context_id eq '*' ? 1 : 0,
				type => $type,
			})->all;
			for my $user_notification_group (@user_notification_groups) {
				$c->d->rs('User::Notification')->update_or_create({
					users_id => $c->user->id,
					user_notification_group_id => $user_notification_group->id,
					context_id => undef,
					cycle => $cycle,
				},{
					key => 'user_notification_user_notification_group_id_context_id_users_id',
				});
				if ($context_id eq '*') {
					$c->d->rs('User::Notification')->search({
						users_id => $c->user->id,
						user_notification_group_id => $user_notification_group->id,
						context_id => { '!=' => undef },
					})->update({
						cycle => $cycle,
					});
				}
			}
		}
	}
	$c->stash->{user_notification_group_values} = $c->user->user_notification_group_values;
}

sub following :Chained('base') :Args(0) {
	my ( $self, $c ) = @_;
}

no Moose;
__PACKAGE__->meta->make_immutable;
