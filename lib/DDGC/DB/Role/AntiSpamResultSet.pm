package DDGC::DB::Role::AntiSpamResultSet;
# ABSTRACT: A role for resultsets which have anti spam functionality

use Moose::Role;

sub ghostbusted {
  my ( $self ) = @_;
  $self->search_rs([
    { $self->me.'ghosted' => 0 },
    { $self->me.'ghosted' => 1,
      $self->me.'checked', { '!=' => undef }
    },
    $self->schema->ddgc->current_user() ? ({
      $self->me.'ghosted' => 1,
      $self->me.'users_id' => $self->schema->ddgc->current_user()->id
    }) : ()
  ]);
}

1;
