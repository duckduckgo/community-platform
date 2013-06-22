package DDGC::Envoy;
# ABSTRACT: Notification functions

use Moose;
use DateTime;
use DateTime::Duration;

has ddgc => (
	isa => 'DDGC',
	is => 'ro',
	required => 1,
	weak_ref => 1,
);

sub format_datetime { shift->ddgc->db->storage->datetime_parser->format_datetime(shift) }

sub update_own_notifications {
	my ( $self ) = @_;
	$self->_resultset_update_notifications($self->ddgc->rs('Event')->search({
		notified => 0,
		pid => $self->ddgc->config->pid,
		nid => $self->ddgc->config->nid,
		created => { ">=" => $self->format_datetime(
			DateTime->now - DateTime::Duration->new( minutes => 2 )
		) },
	})->all);
}

sub update_notifications {
	my ( $self ) = @_;
	$self->_resultset_update_notifications($self->ddgc->rs('Event')->search({
		notified => 0,
		created => { "<" => $self->format_datetime(
			DateTime->now - DateTime::Duration->new( minutes => 2 )
		) },
	})->all);
}

sub _resultset_update_notifications {
	my ( $self, @events ) = @_;
	return unless @events;
	my %languages = map { $_->id => $_->locale } $self->ddgc->rs('Language')->search({})->all;
	for my $event (@events) {
		my $own_context = $event->context;
		my $own_context_id = $event->context_id;
		my @related = $event->related ? @{$event->related} : ();
		my @language_ids;
		my @queries = (
			{ context => $own_context, context_id => { '=' => [ $own_context_id, undef ] }, sub_context => undef },
			map {
				my ( $context, $context_id ) = @{$_};
				push @language_ids, $context_id if $context eq 'DDGC::DB::Result::Language';
				{ context => $context, context_id => { '=' => [ $context_id, undef ] }, sub_context => $own_context },
			} @related
		);
		my @user_notifications = $self->ddgc->db->resultset('User::Notification')->search({
			-or => [@queries],
		})->all;
		for my $un (@user_notifications) {
			if (@language_ids) {
				next unless grep { $un->user->can_speak($languages{$_}) } @language_ids;
			}
			next unless $un->users_id != $event->users_id;
			$event->create_related('event_notifications',{
				users_id => $un->users_id,
				cycle => $un->cycle,
				cycle_time => $un->cycle_time,
			});
		}
		$event->language_ids(\@language_ids);
		$event->notified(1);
		$event->update;
	}
}

my %templates = (
	'comments' => {
		template => 'email/notifications/comments.tx',
		subject => 'New comments for you',
	},
	'translations' => {
		template => 'email/notifications/translations.tx',
		subject => 'New translations to vote on in your languages',
	},
	'tokens' => {
		template => 'email/notifications/tokens.tx',
		subject => 'New tokens for translation in your languages',
	},
);

my %mapping = (

);

sub notify_cycle {
	my ( $self, $cycle ) = @_;
	my @event_notifications = $self->ddgc->db->resultset('Event::Notification')->search({
		cycle => $cycle,
		done => 0,
	})->all;
	my %users;
	for (@event_notifications) {
		$users{$_->user->id} = [] unless defined $users{$_->user->id};
		push @{$users{$_->user->id}}, $_;
	}
	for (keys %users) {
		my @notifications = @{$users{$_}};
		my $user = $notifications[0]->user;

	}
}

no Moose;
__PACKAGE__->meta->make_immutable;
