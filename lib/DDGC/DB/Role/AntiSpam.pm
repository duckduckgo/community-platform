package DDGC::DB::Role::AntiSpam;
# ABSTRACT: A role for classes which have anti spam functionality

use Moose::Role;
use DateTime;

requires qw(
  ghosted
  checked
);

before insert => sub {
  my ( $self ) = @_;
  unless (defined $self->ghosted) {
    if ($self->user->ghosted) {
      $self->ghosted(1);
    } else {
      $self->ghosted(0);
    }
  }
};

sub add_report {
  my ( $self, $user, %data ) = @_;
  $user->add_report($self->i_context,$self->i_context_id,%data);
}

sub delete_report {
  my ( $self, $id ) = @_;
  return unless defined $id;
  $self->reported([grep { $_->{id} ne $id } @{$self->reported}]);
}

sub ghosted_checked_by {
  my ( $self, $user, $ghosted ) = @_;
  die __PACKAGE__."->checked_by needs new ghosted state" unless defined $ghosted;
  $self->checked($user->id);
  $self->ghosted($ghosted ? 1 : 0);
}

1;
