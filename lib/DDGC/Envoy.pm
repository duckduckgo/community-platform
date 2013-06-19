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
	for my $event (@events) {
		my $own_context = $event->context;
		my $own_context_id = $event->context_id;
		my @related = $event->related ? @{$event->related} : ();
		my @queries = (
			{ context => $own_context, context_id => { '=' => [ $own_context_id, undef ] }, sub_context => undef },
			map {
				my ( $context, $context_id ) = @{$_};
				{ context => $context, context_id => { '=' => [ $context_id, undef ] }, sub_context => $own_context },
			} @related
		);
		my @user_notifications = $self->ddgc->db->resultset('User::Notification')->search({
			-or => [@queries],
		})->all;
		for (@user_notifications) {
			$event->create_related('event_notifications',{
				users_id => $_->users_id,
				cycle => $_->cycle,
				cycle_time => $_->cycle_time,
			});
		}
		$event->notified(1);
		$event->update;
	}
}

no Moose;
__PACKAGE__->meta->make_immutable;
