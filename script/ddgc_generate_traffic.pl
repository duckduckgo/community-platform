#!/usr/bin/env perl
package DDGC::Cmd::GenerateTraffic;

use strict;
use warnings;

$ENV{DDGC_IA_AUTOUPDATES} = 0;

use FindBin;
use lib $FindBin::Dir . "/../lib";

use DDGC;
use List::MoreUtils qw(zip);
use List::Util qw(pairs);
use DateTime;

use Moo;
use MooX::Options;

my $default_days = 31;

option days => (
    is      => 'ro',
    format  => 'i',
    doc     => "number of days of data to generate (default $default_days)",
    default => $default_days,
);

my $opt = DDGC::Cmd::GenerateTraffic->new_with_options;

my $num_days = $opt->{days};
die 'number of days must be positive!' unless $num_days >= 0;

my $start_date = DateTime->now->subtract(days => $num_days);

my @days = map { $start_date->clone->add(days => $_)->strftime('%F') } (0..$num_days);

my $d = DDGC->new;

my @ids = $d->rs('InstantAnswer')
    ->search({dev_milestone => 'live'})
    ->get_column('meta_id')
    ->all;

my @bounds = (10, 100, 1_000, 10_000);

# Generate a set of counts, bounded in sections (small, large etc)
sub get_random_counts {
    my $max = $bounds[int(rand($#bounds))];
    map { int(rand($max)) } (0..$num_days);
}

foreach my $id (@ids) {
    my @counts = get_random_counts();
    $d->rs('InstantAnswer::Traffic')->populate([
        [qw( answer_id pixel_type date count )],
        map { my ($date, $count) = @$_; [$id, 'iaoi', $date, $count] } pairs zip (@days, @counts),
    ]);
}
