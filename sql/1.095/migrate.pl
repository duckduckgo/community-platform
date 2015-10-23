#!/usr/bin/env perl

use strict;
use warnings;
use DDGC;

my $ddgc = DDGC->new;

for my $user ($ddgc->rs('User')->all) {
    $user->update({ github_user => $user->data->{github} }) if  $user->data->{github};
    if ( my $gh_user = $ddgc->rs('Github::UserLink')->search({ users_id => $user->id })->one_row ) {
        $user->update({ github_user => $gh_user->data->{login} });
    }
}

