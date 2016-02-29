#!/usr/bin/env perl

use FindBin;
use lib "$FindBin::Dir/../../lib";
use strict;
use Try::Tiny;
use JSON;
use DDGC;

my $d  = DDGC->new;
my $ias = $d->rs('InstantAnswer');
my $is_live = $d->is_live;

while (my $ia = $ias->next) {
    if (my $maintainer = $ia->maintainer) {
        try {
            my $temp_maintainer = from_json($maintainer);
        } 
        catch {
            my %updated_maintainer;
            my $duckco_user = $d->rs('User')->find({username => $maintainer});

            if ($duckco_user || (!$is_live)) {
                %updated_maintainer = ( duckco => $maintainer );

                if ($is_live && $duckco_user->github_id) {
                    $updated_maintainer{github} = $d->rs('GitHub::User')->find({github_id => $duckco_user->github_id})->login;
                }
            } else {
                die "Maintainer '$maintainer' is not a duck.co user!";
            }

            if (%updated_maintainer) {
                $maintainer = to_json \%updated_maintainer;
                $ia->update({maintainer => $maintainer});
            }
        };
    }
}
