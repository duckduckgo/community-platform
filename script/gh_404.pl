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

open my $fh, '>:encoding(UTF-8)', "../maintainer_404_list.txt" or die();
for my $ia_id (keys $data) {
    my $maintainer = $data->{$ia_id}->{maintainer};

    if (my $gh_username = $maintainer->{github}) {
        print $fh "Username: " . $gh_username . " for IA: " . $ia_id unless check_github($gh_username);
    }
}
close $fh;

sub check_github {
    my ($username) = @_;

    my $result = 0;
    my $token = $ENV{DDGC_GITHUB_TOKEN} || $ENV{DDG_GITHUB_BASIC_OAUTH_TOKEN};
    my $gh = Net::GitHub->new(access_token => $token);

    try {
        my $user_info = $gh->user->show($username);

        if ($user_info) {
            return 1;
        } else {
            return 0;
        }
    } catch {
        return 0;
    };
}
