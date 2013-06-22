package DDGC::Web::Controller::My::Notifications;
# ABSTRACT: Notifications editor

use Moose;
BEGIN {extends 'Catalyst::Controller'; }

use DateTime;
use namespace::autoclean;

sub base :Chained('/my/logged_in') :PathPart('notifications') :CaptureArgs(0) {
	my ( $self, $c ) = @_;
	$c->add_bc('Notifications', $c->chained_uri('My::Notifications','index'));
	if ($c->req->param('save_notifications')) {
		my @context = $c->req->param('context');
		my @context_id = $c->req->param('context_id');
		my @sub_context = $c->req->param('sub_context');
		my @cycle = $c->req->param('cycle');
		my $count = (scalar @context);
		my $i = 0;
		my @notifications;
		while ($i < $count) {
			push @notifications, {
				context => $context[$i],
				context_id => $context_id[$i] || undef,
				sub_context => $sub_context[$i] || undef,
				cycle => $cycle[$i],
			};
			$i++;
		}
		$c->user->save_notifications(@notifications);
	}
	$c->stash->{user_notifications} = [$c->user->user_notifications];
}

sub edit :Chained('base') :Args(0) {
	my ( $self, $c ) = @_;
	$c->add_bc('Editor');
	$c->stash->{notification_cycle_options} = [
		{
			value => 0,
			name => "Not activated",
		},
		{
			value => 2,
			name => "Hourly",
		},
		{
			value => 3,
			name => "Daily",
		},
		{
			value => 4,
			name => "Weekly",
		},
	];
	$c->stash->{base_notifications} = [$self->add_user_cycle_and_cycle_time($c,
		{
			description => 'new tokens',
			context => 'DDGC::DB::Result::Token',
			context_id => undef,
			sub_context => undef,
		},
		{
			description => 'new comments related to my languages',
			context => 'DDGC::DB::Result::Comment',
			context_id => undef,
			sub_context => undef,
		},
		{
			description => 'new translations in my languages',
			context => 'DDGC::DB::Result::Token::Language::Translation',
			context_id => undef,
			sub_context => undef,
		},
	)];
}

sub add_user_cycle_and_cycle_time {
	my ( $self, $c, @notifications ) = @_;
	for my $notification (@notifications) {
		my %query = (
			context => $notification->{context},
			context_id => $notification->{context_id},
			sub_context => $notification->{sub_context},
		);
		my $result = $c->user->search_related('user_notifications',{ %query })->first;
		if ($result) {
			$notification->{cycle} = $result->cycle;
			$notification->{cycle_time} = $result->cycle_time;
			$notification->{id} = $result->id;
		}
	}
	return @notifications;
}

our %context_map = (
	comments => 'DDGC::DB::Result::Comment',
	tokens => 'DDGC::DB::Result::Token',
	translations => 'DDGC::DB::Result::Token::Language::Translation',
);

sub index :Chained('base') :PathPart('') :Args(0) {
	my ( $self, $c ) = @_;
	$c->bc_index;
    $c->pager_init($c->action,20);
    for (qw( comments tokens translations )) {
		$c->stash->{'undone_notifications_'.$_} = $c->user->search_related('event_notifications',{
			"event.context" => $context_map{$_},
			"me.done" => 0,
		},{
			join => 'event',
		})->count;
    }
	if ($c->req->param('all_event_notifications_done')) {
		$c->user->search_related('event_notifications')->update({ done => 1, sent => 1 });
	}
}

sub comments :Chained('base') :Args(0) {
	my ( $self, $c ) = @_;
	$c->add_bc('Comments');
	$self->notifications($c,'comments');
}

sub tokens :Chained('base') :Args(0) {
	my ( $self, $c ) = @_;
	$c->add_bc('Tokens');
	$self->notifications($c,'tokens');
}

sub translations :Chained('base') :Args(0) {
	my ( $self, $c ) = @_;
	$c->add_bc('Translations');
	$self->notifications($c,'translations');
}

sub notifications {
	my ( $self, $c, $action ) = @_;
	my $result = $context_map{$action};
	$c->stash->{notification_action} = $action;
	my $rs = $c->user->search_related('event_notifications',{
		"event.context" => $result,
	},{
		join => 'event',
	});
	$c->pager_init($c->action,10);
	if (my $done = $c->req->param('event_notification_done')) {
		my ( $first ) = $rs->search({ "me.id" => $done });
		if ($first && $first->users_id eq $c->user->id && $first->id eq $done) {
			$first->done(1);
			$first->sent(1);
			$first->update;
		}
	}
	if ($c->req->param('these_event_notifications_done')) {
		$rs->update({
			"done" => 1,
			"sent" => 1,
		});
	}
	$c->stash->{event_notifications} = $rs->search({},{
		order_by => { -desc => 'me.created' },
		page => $c->stash->{page},
		rows => $c->stash->{pagesize},
	});
}

# sub json :Chained('base') :Args(0) {
# 	my ( $self, $c ) = @_;
# 	$c->stash->{x} = map { $_->export } $c->stash->{user_notifications};
# 	$c->forward('View::JSON');
# }

no Moose;
__PACKAGE__->meta->make_immutable;
