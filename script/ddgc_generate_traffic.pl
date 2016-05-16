#!/usr/bin/env perl

use strict;
use warnings;

$ENV{DDGC_IA_AUTOUPDATES} = 0;

use FindBin;
use lib $FindBin::Dir . "/../lib";

use DDGC;
use Carp;
use Data::Printer;
use List::MoreUtils qw(zip);
use List::Util qw(pairs);
use DateTime;

my $d = DDGC->new;

my @ids = $d->rs('InstantAnswer')->get_column('meta_id')->all;

my $today = DateTime->now();
my $last_month = $today->clone()->subtract(days => 31);

my @days = map { $last_month->clone->add(days => $_)->strftime('%F') } (1..31);
my @counts = (1..31);
my $days = \@days;
my $counts = \@counts;

foreach my $id (@ids) {
    foreach (pairs zip @days, @counts) {
        my ($day, $count) = @$_;
        $d->rs('InstantAnswer::Traffic')->update_or_create({
            answer_id  => $id,
            date       => $day,
            count      => $count,
            pixel_type => 'iaoi',
        });
    }
}
