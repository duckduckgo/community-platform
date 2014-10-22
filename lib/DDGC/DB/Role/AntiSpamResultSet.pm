package DDGC::DB::Role::AntiSpamResultSet;
# ABSTRACT: A role for resultsets which have anti spam functionality

use Moose::Role;

sub ghostbusted {
  $_[0]->search_rs([
    { $_[0]->me.'ghosted', 0 },
    $_[0]->schema->ddgc->current_user() ? ({
      $_[0]->me.'ghosted', 1,
      $_[0]->me.'users_id', $_[0]->schema->ddgc->current_user()->id
    }) : ()
  ]);
}

1;
