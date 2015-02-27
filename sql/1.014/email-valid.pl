#!/usr/bin/env perl

use strict;
use warnings;

use Email::Valid;
use FindBin;
use lib "$FindBin::Dir/../../lib";

use DDGC;

my $d = DDGC->new;
my $users = $d->rs('User');

while (my $user = $users->next) {
    if ($user->data && $user->data->{email}) {
        $user->data->{email} = Email::Valid->address($user->data->{email});
        $user->update( { data => $user->data } );
    }
}

