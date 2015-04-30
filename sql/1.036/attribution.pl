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
        
        if ($dev && $dev eq 'HASHREF') {
            my $dev_name = lc $dev->{name};
            my $dev_url = lc $dev->{url};
            my $dev_type;
            
            if ($dev_url =~ "github") {
                $dev_type = "github";
            } else {
                $dev_type = "duck.co";
            }

            my %temp_dev = (
                name => $dev_name,
                url => $dev_url,
                type => $dev_type
            );

            push @devs, \%temp_dev;
            
            $names{$dev_name} = 1;
            $locs{$dev_url} = 1;
        }
        
        if ($attribution) {
            while (my ($name, $urls) = each %{$attribution}) {
                my %temp_dev = chooseUrl(@{$urls});
                my $temp_name = lc $name;
                my $temp_url = lc $temp_dev{url};
                if ((!exists($names{$temp_name})) && (!exists($locs{$temp_url}))
                    && (!exists($names{$temp_url})) && (!exists($locs{$temp_name}))) {
                    $names{$temp_name} = 1;
                    $locs{$temp_url} = 1;
                    
                    $temp_dev{name} = $name;

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

    my $github_url = 'https://github.com/';
    my $twitter_url = 'https://twitter.com/';
    my %result;

    for my $url (@urls) {
        my $type = lc $url->{type};
        
        if ($type eq 'github') {
            %result = (
                type => $type
            );
            
            if ($url->{loc} !~ $github_url) {
                $result{url} = $github_url.$url->{loc};
            } else {
                $result{url} = $url->{loc};
            }
            
            return %result;
        } else {
            %result = (
                type => "legacy",
                url => $url->{loc}
            );

            if (($type eq 'twitter') && ($url->{loc} !~ $twitter_url)) {
                $result{url} = $twitter_url.$url->{loc};
            }
        }
    }

    return %result;
}
