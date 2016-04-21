#!/usr/bin/env perl

use strict;
use FindBin;
use lib $FindBin::Dir . "/../../lib";
use DDGC;
use Data::Dumper;
use JSON;
use Try::Tiny;
use DDP;

my $d = DDGC->new;

my @ias= $d->rs('InstantAnswer')->all;

for my $ia ( @ias ) {
    
    warn "IA Page: " . $ia->meta_id;
    warn "JSON dev column before update: " . $ia->developer;
    
    try {
        if ( $ia->developer && ( $ia->developer ne '[]' ) ) {
         
            my $developers = from_json($ia->developer);
            my $new_devs;

            for my $dev ( @{ $developers } ) {
               
                if ( ( ref $dev eq 'HASH' ) && $dev->{type} && ( $dev->{type} eq 'duck.co' ) ) {

                    warn "HASH";
                    p $dev;
                    if ( my $complat_user = $d->rs('User')->find({ username => $dev->{name} }) ) {

                        my $gh_user = $complat_user->github_id ? $d->rs('GitHub::User')->find({ github_id => $complat_user->github_id }) : undef;

                        if ( my $login = $gh_user ? $gh_user->login : $complat_user->github_user_plaintext ) {

                            warn $login;

                            my $new_dev = {
                                name => $login,
                                type => 'github',
                                url => 'https://github.com/' . $login
                            };

                            push(@{ $new_devs }, $new_dev);
                        }
                    }
                } elsif ( $dev ) {
                    warn "dev as it is";
                    push(@{ $new_devs }, $dev);
                }
            }
            
            if ( $new_devs ) { 
                $developers = to_json($new_devs);

                warn "JSON dev column updated: " . $developers;
                $ia->update({ developer => $developers });
            }
        }
    } catch {
        warn "error updating developers: " . $_;
    };
}
