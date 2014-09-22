#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use lib $FindBin::Dir . "/../lib";
use Scalar::Util qw/ looks_like_number /;
use DDGC;
use feature qw/ say /;
use autodie;

sub usage {
    say "Usage :";
    say "$0 campaign-id coupon-file\n";
}

my $campaign_id = shift @ARGV;
if (!looks_like_number($campaign_id)) {
    usage;
    die ("Campaign id $campaign_id does not appear to be numeric");
}

my $coupon_file = shift @ARGV;
if (!-f $coupon_file) {
    usage;
    die ("File $coupon_file does not exist");
}

my $ddgc = DDGC->new;
open my $fh, '<', $coupon_file;

while ( my $coupon = <$fh> ) {
    next if !$coupon;
    chomp($coupon);
    $ddgc->db->resultset('User::Coupon')->create({
        campaign_id => $campaign_id,
        coupon => $coupon,
    });
}

