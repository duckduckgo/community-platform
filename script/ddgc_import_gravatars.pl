#!/usr/bin/env perl

use FindBin;
use lib $FindBin::Dir . "/../lib"; 

use strict;
use warnings;
use DDGC;
use DDGC::DB;

my $ddgc = DDGC->new;
my $users = $ddgc->rs('User');
while (my $user = $users->next) {
    $user->gravatar_to_avatar;
}

