package DDGC::DB::Role::AntiSpamResultSet;
# ABSTRACT: A role for resultsets which have anti spam functionality

use Moose::Role;

sub ghostbusted {
  $_[0]->search_rs([
    { ghosted => undef },
    $_[0]->d->cur_user() ? () : ({
      ghosted => 1,
      users_id => cur_user()->id
    })
  ]);
}

1;