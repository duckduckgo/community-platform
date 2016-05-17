#!/usr/bin/env perl
package DDGC::Cmd::GenerateTraffic;

use strict;
use warnings;

$ENV{DDGC_IA_AUTOUPDATES} = 0;

use FindBin;
use lib $FindBin::Dir . "/../lib";

use DDGC;
use List::MoreUtils qw(zip);
use List::Util qw(any pairs);
use DateTime;

use Moo;
use MooX::Options
    description => 'generate random traffic data',
    authors     => 'Ben Moon <guiltydolphin@gmail.com>',
    synopsis    => '

    To generate a week of traffic for the calculator, with each
    day having a maximum count of 10:

    ddgc_generate_traffic.pl --id=calculator --days=7 --max=10
';

my $default_days = 31;

option days => (
    is      => 'ro',
    format  => 'i',
    doc     => "number of days of data to generate (default $default_days)",
    default => $default_days,
);

my $d = DDGC->new;

option id => (
    is        => 'ro',
    format    => 's@',
    autosplit => ',',
    doc       => 'IDs of Instant Answers to generate traffic for',
    default   => sub {
        my @ids = $d->rs('InstantAnswer')
                    ->search({dev_milestone => 'live'})
                    ->get_column('meta_id')
                    ->all;
        return \@ids;
    },
);

option max => (
    is        => 'ro',
    format    => 'i@',
    autosplit => ',',
    default   => sub { [0, 10, 100, 1_000, 10_000] },
    doc       => 'maximum counts to randomly choose between;' .
        " a maximum of 0 implies there wasn't enough traffic data",
);

option clear => (
    is      => 'ro',
    default => 0,
    doc     => 'delete all traffic data and exit',
);

my $opt = DDGC::Cmd::GenerateTraffic->new_with_options;

my $num_days = $opt->{days};
die 'number of days must be positive!' unless $num_days >= 0;

my $start_date = DateTime->now->subtract(days => $num_days);

my @days = map { $start_date->clone->add(days => $_)->strftime('%F') } (0..$num_days);

my @ids = @{$opt->id};

my @bounds = @{$opt->max};
die 'cannot have a negative maximum!' if any { $_ < 0 } @bounds;

# Generate a set of counts, bounded in sections (small, large etc)
sub get_random_counts {
    my $max = $bounds[int(rand($#bounds))];
    return () if $max == 0;
    map { int(rand($max)) } (0..$num_days);
}

$d->rs('InstantAnswer::Traffic')->delete();
exit if $opt->{clear};

foreach my $id (@ids) {
    my @counts = get_random_counts() or next;
    $d->rs('InstantAnswer::Traffic')->populate([
        [qw( answer_id pixel_type date count )],
        map { my ($date, $count) = @$_; [$id, 'iaoi', $date, $count] } pairs zip (@days, @counts),
    ]);
}

1;
