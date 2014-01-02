package DDGC::DB::Role::AntiSpam;
# ABSTRACT: A role for classes which have anti spam functionality

use Moose::Role;
use DateTime;

requires qw(
  ghosted
  reported
  checked
);

sub report {
  my ( $self, $user, %data ) = @_;
  push @{$self->reported}, {
    users_id => $user->id,
    time => DateTime->now->epoch,
    %data,
  };
  $self->make_column_dirty('reported');
}

1;