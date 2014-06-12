#!/usr/bin/env perl

$|=1;

use strict;
use warnings;

use FindBin;
use lib $FindBin::Dir . "/../lib"; 

use DDGC;

my $ddgc = DDGC->new;

for (@{$ddgc->rs("Token::Language::Translation")->search({},{
  prefetch => [qw( user )],
})->all}) {
  $_->users_id($_->user->id);
}

for (@{$ddgc->rs("User::Language")->search({},{
  prefetch => [qw( user )],
})->all}) {
  $_->users_id($_->user->id);
}

if ($ddgc->config->prosody_running) {
  for (@{$ddgc->rs("User")->search({},{})->all}) {
    my %xmpp_user_find = $ddgc->xmpp->user($_->lc_username);
    unless (%xmpp_user_find) {
      print "Can't find user ".$_->lc_username." on XMPP\n";
    }
  }
}

exit 0;
