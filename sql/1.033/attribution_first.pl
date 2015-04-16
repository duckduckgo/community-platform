#!/usr/bin/env perl

use FindBin;
use lib "$FindBin::Dir/../../lib";
use strict;
use DDGC;
use JSON;

my $d  = DDGC->new;
my $ias = $d->rs('InstantAnswer');

while (my $ia = $ias->next) {
        my $attribution = $ia->attribution? from_json($ia->attribution) : undef;
        my @devs;
        my %names;
        my %locs;
        my $dev = $ia->developer? from_json($ia->developer) : undef;

        if ($dev) {
            push @devs, $dev;
            $names{lc $dev->{name}} = 1;
            $locs{lc $dev->{url}} = 1;
        }
        
        if ($attribution) {
            while (my ($name, $urls) = each %{$attribution}) {
                my $url = chooseUrl(@{$urls});
                if (!exists($names{lc $name}) && (!exists($locs{lc $url}))
                    && (!exists($names{lc $url})) && (!exists($locs{lc $name}))) {
                    $names{lc $name} = 1;
                    $locs{lc $url} = 1;
                    my %temp_dev = (
                        name => $name,
                        url => $url
                    );

                    push @devs, \%temp_dev;
                }
            }
        }

        if (@devs) {
            my $dev_json = to_json \@devs;
            $ia->update({developer => $dev_json});
        }
}

sub chooseUrl {
    my (@urls) = @_;

    my $web_url;
    for my $url (@urls) {
        my $type = lc $url->{type};
        
        if ($type eq 'github') {
            return $url->{loc};
        } elsif ($type eq 'web') {
            $web_url = $url->{loc};
        }
    }

    if ($web_url) {
        return $web_url;
    } else {
        return $urls[@urls]{loc};
    }
}
