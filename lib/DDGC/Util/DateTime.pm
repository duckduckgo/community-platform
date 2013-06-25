package DDGC::Util::DateTime;

use strict;
use warnings;
use Exporter 'import';

our @EXPORT = qw(
	dur
	dur_precise
);

use DateTime;
use DateTime::Format::Human::Duration;

sub dur {
	my ( $date ) = @_;
	$date = DateTime->from_epoch( epoch => $date ) unless ref $date;
	return DateTime::Format::Human::Duration->new->format_duration(
		DateTime->now - $date,
		'units' => [qw/years months days/],
		'past' => '%s ago',
		'future' => 'in %s will be',
		'no_time' => 'today',
	);
}

sub dur_precise {
	my ( $date ) = @_;
	$date = DateTime->from_epoch( epoch => $date ) unless ref $date;
	return DateTime::Format::Human::Duration->new->format_duration(
		DateTime->now - $date,
		'units' => [qw/years months days hours minutes/],
		'past' => '%s ago',
		'future' => 'in %s will be',
		'no_time' => 'just now',
	);
}

1;