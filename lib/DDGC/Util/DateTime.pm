package DDGC::Util::DateTime;
# ABSTRACT: Utility functions for DateTime visualization

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
		'past' => '%s ago',
		'future' => 'in %s will be',
		'no_time' => 'just now',
                'precision' => 'minutes',
                'significant_units' => 2,
	);
}

sub dur_precise {
	my ( $date ) = @_;
	$date = DateTime->from_epoch( epoch => $date ) unless ref $date;
	my $diff = DateTime->now - $date;
	my $units = [qw/ hours minutes /];

	$units = [qw/ days hours /]    if ($diff->days > 1);
	$units = [qw/ months days /]   if ($diff->months > 1);
	$units = [qw/ years months /]  if ($diff->years > 1);

	return DateTime::Format::Human::Duration->new->format_duration(
		$diff,
		'units' => $units,
		'past' => '%s ago',
		'future' => 'in %s will be',
		'no_time' => 'just now',
	);
}

1;
