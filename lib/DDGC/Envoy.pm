package DDGC::Envoy;
# ABSTRACT: Notification functions

use Moose;

has ddgc => (
	isa => 'DDGC',
	is => 'ro',
	required => 1,
	weak_ref => 1,
);

sub update_notifications {
	my ( $self ) = @_;
	my @events = $self->ddgc->rs('Event')->search({
		notified => 0,
	})->all;
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

sub notify_cycle {
	my ( $self, $cycle ) = @_;
	my @event_notifications = $self->ddgc->db->resultset('Event::Notification')->search({
		cycle => $cycle,
		done => 0,
	})->all;
	for (@event_notifications) {

	}
}

no Moose;
__PACKAGE__->meta->make_immutable;
