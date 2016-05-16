#!/usr/bin/env perl

use strict;
use warnings;

$ENV{DDGC_IA_AUTOUPDATES} = 0;

use FindBin;
use lib $FindBin::Dir . "/../lib";

use DDGC;
use List::MoreUtils qw(zip);
use List::Util qw(pairs);
use DateTime;

my $d = DDGC->new;

my @ids = $d->rs('InstantAnswer')
    ->search({dev_milestone => 'live'})
    ->get_column('meta_id')
    ->all;

my $today = DateTime->now();
my $last_month = $today->clone()->subtract(days => 31);

my @days = map { $last_month->clone->add(days => $_)->strftime('%F') } (1..31);
my $days = \@days;

sub generate_bounded_counts {
    my ($min, $max) = @_;
    map { int(rand($max+$min)) + $min } (1..31);
}

my %bounds = (
    small => [0, 3_000],
    large => [1_000, 100_000],
);

# Returns a month's worth of counts
sub get_random_counts {
    generate_bounded_counts(int(rand())
        ? @{$bounds{small}} : @{$bounds{large}}
    );
}

foreach my $id (@ids) {
    my @counts = get_random_counts();
    $d->rs('InstantAnswer::Traffic')->populate([
        [qw( answer_id pixel_type date count )],
        map { my ($date, $count) = @$_; [$id, 'iaoi', $date, $count] } pairs zip (@days, @counts),
    ]);
}
