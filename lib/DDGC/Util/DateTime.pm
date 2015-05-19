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
    my ($date) = @_;
    $date = DateTime->from_epoch( epoch => $date ) unless ref $date;
    my $diff = DateTime->now - $date;

    return DateTime::Format::Human::Duration->new->format_duration(
        $diff,
        units             => [qw/ years months days hours minutes /],
        significant_units => 2,
        past              => '%s ago',
        future            => 'in %s will be',
        no_time           => 'just now',
    );
}

sub dur_precise {
    my ($date) = @_;
    dur($date);
}

1;
