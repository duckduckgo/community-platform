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
            #push @devs, $dev;
            #my $dev_name = lc $dev->{name};
            #my $dev_url = lc $dev->{url};
            #$names{$dev_name} = 1;
            #$locs{$dev_url} = 1;
        }
        
        if ($attribution) {
            while (my ($name, $urls) = each %{$attribution}) {
                my $url = chooseUrl(@{$urls});
                my $temp_name = lc $name;
                my $temp_url = lc $url;
                if (!exists($names{$temp_name}) && (!exists($locs{$temp_url}))
                    && (!exists($names{$temp_url})) && (!exists($locs{$temp_name}))) {
                    $names{$temp_name} = 1;
                    $locs{$temp_url} = 1;
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
    my $github_url = 'https://github.com/';
    my $twitter_url = 'https://twitter.com/';

    for my $url (@urls) {
        my $type = lc $url->{type};
        
        if ($type eq 'github') {
            if ($url->{loc} !~ $github_url) {
                return $github_url.$url->{loc};
            } else {
                return $url->{loc};
            }
        } elsif ($type eq 'web') {
            $web_url = $url->{loc};
        }
    }

    if ($web_url) {
        return $web_url;
    } else {
        my %last_url = $urls[@urls];

        if (($last_url{type} eq 'twitter') && ($last_url{loc} !~ $twitter_url)) {
            return $twitter_url.$last_url{loc};
        } else {
            return $last_url{loc};
        }
    }
}
