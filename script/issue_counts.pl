#!/usr/bin/env perl

use strict;
use warnings;

$ENV{DDGC_IA_AUTOUPDATES} = 0;

use FindBin;
use lib $FindBin::Dir . "/../lib";

use JSON::MaybeXS;
use HTTP::Tiny;
use DDGC;
use Carp;

my $d = DDGC->new;
my $h = HTTP::Tiny->new;
my $r = $h->get('https://duck.co/ia/repo/all/json?all_milestones=1');

croak sprintf("GET failed, %s: %s", $r->{status}, $r->{reason}) if !$r->{success};

my $data = decode_json( $r->{content} );

open my $fh, '>:encoding(UTF-8)', "./ias.json" or die();
for my $ia_id (keys $data) {

    if ( my @issues = $d->rs('InstantAnswer::Issues')->search({ instant_answer_id => $ia_id, is_pr => 0 }) ) {
        $data->{$ia_id}->{issues_count} = scalar @issues;
    }
    
    if ( my @pulls = $d->rs('InstantAnswer::Issues')->search({ instant_answer_id => $ia_id, is_pr => 1 }) ) {
        $data->{$ia_id}->{prs_count} = scalar @pulls;
    }

    print $fh encode_json( $data->{$ia_id} );
}

close $fh;

