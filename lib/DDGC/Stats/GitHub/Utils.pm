package DDGC::Stats::GitHub::Utils;
# ABSTRACT: Utilities for displaying datetimes to humans
use Moo;

use v5.16.0;
use DDP;
use Number::Format qw/format_number/;
use Exporter::Shiny qw/duration_to_minutes human_duration/;

=head1 SYNOPSIS

    # Takes a DateTime::Duration object and returns the number of minutes as an
    # integer
    my $minutes = duration_to_minutes($duration); 

    # Takes an integer and returns a human readable formatted string which
    # tells the duration in days, hours, and minutes
    my $string  = human_duration($minutes);

=cut

# WARNING: Bad date math! you can't reliably convert days to hours because of
# leap years and leap hours and daylight savings.  But whatever.  Close enough.
sub duration_to_minutes {
    my ($duration) = @_;
    my ($months, $dys, $mins) = $duration->in_units(qw/months days minutes/);
    $mins += $dys    * 60 * 24;
    $mins += $months * 60 * 24 * 30;
    return $mins;
}

# WARNING: Bad date math! you can't reliably convert hours to days because of
# leap years and leap hours and daylight savings.  But whatever.  Close enough.
sub human_duration {
    my ($minutes) = @_;

    my $hrsPerDy  = 24;
    my $minsPerHr = 60;
    my ($mins, $minsLabel);
    my ($hrs,  $hrsLabel);
    my ($dys,  $dysLabel);

    $minsLabel = $minutes > 1 ? "mins" : "min";
    return format_number($minutes, 0) . $minsLabel if $minutes < $minsPerHr;

    $hrs  = int($minutes / $minsPerHr);
    $mins = $minutes % $minsPerHr;
    $hrsLabel  = $hrs  > 1 ? "hrs " : "hr ";
    $minsLabel = $mins > 1 ? "mins" : "min";
    return $hrs . $hrsLabel . $mins . $minsLabel if $hrs < $hrsPerDy;

    $dys = int($hrs / $hrsPerDy);
    $hrs = $hrs % $hrsPerDy;
    $dysLabel = $dys > 1 ? "dys " : "dy ";
    $hrsLabel = $hrs > 1 ? "hrs " : "hr ";
    return $dys . $dysLabel . $hrs . $hrsLabel . $mins . $minsLabel;
}

1;
