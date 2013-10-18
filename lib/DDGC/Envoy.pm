package DDGC::Envoy;
# ABSTRACT: Notification component

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
	$self->_resultset_update_notifications($self->ddgc->rs('Event')->search_rs({
		notified => 0,
		pid => $self->ddgc->config->pid,
		nid => $self->ddgc->config->nid,
		created => { ">=" => $self->format_datetime(
			DateTime->now - DateTime::Duration->new( minutes => 2 )
		) },
	}));
}

sub update_notifications {
	my ( $self ) = @_;
	$self->_resultset_update_notifications($self->ddgc->rs('Event')->search_rs({
		notified => 0,
		created => { "<" => $self->format_datetime(
			DateTime->now - DateTime::Duration->new( minutes => 2 )
		) },
	}));
}

# shortcut for deploy and test runs
sub update_all_notifications {
	my ( $self ) = @_;
	$self->_resultset_update_notifications($self->ddgc->rs('Event')->search_rs({}));
}

sub _resultset_update_notifications {
	my ( $self, $event_rs ) = @_;
	return;
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
}

no Moose;
__PACKAGE__->meta->make_immutable;
