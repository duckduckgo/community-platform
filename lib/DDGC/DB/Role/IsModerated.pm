package DDGC::DB::Role::IsModerated;
# ABSTRACT: A role for classes who are moderated (requires AntiSpam functionality)

use Moose::Role;

requires qw(
  ghosted
);

before insert => sub {
  my ( $self ) = @_;
  return unless $self->can('user');
  $self->ghosted($self->user->ghosted ? 1 : 0);
};

1;