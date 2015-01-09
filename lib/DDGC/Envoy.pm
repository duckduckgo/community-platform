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

sub notify_events {
	my ( $self, @events ) = @_;
	return;
}

no Moose;
__PACKAGE__->meta->make_immutable;
