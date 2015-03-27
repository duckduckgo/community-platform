#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Dir/../../lib";

use DDGC;

my $d = DDGC->new;

my $users = $d->rs('User');

while (my $user = $users->next) {
    if ($user->data && $user->data->{email}) {
        $user->update( {
            email => $user->data->{email},
            email_verified => 1,
        } );
    }
}

