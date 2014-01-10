package DDGC::DB::Role::AntiSpam;
# ABSTRACT: A role for classes which have anti spam functionality

use Moose::Role;
use DateTime;

requires qw(
  ghosted
  reported
  checked
  seen_live
);

before reported => sub {
  my ( $self ) = @_;
  $self->set_column('reported','[]') unless $self->get_column('reported');
};

before insert => sub {
  my ( $self ) = @_;
  unless (defined $self->ghosted) {
    if ($self->user->ghosted) {
      $self->ghosted(1);
    } else {
      $self->ghosted(0); $self->seen_live(1);
    }
  }
};

after insert => sub {
  my ( $self ) = @_;
  $self->add_event('create');
  unless ($self->ghosted) {
    $self->add_event('live');
  }
};

sub ghosted_changed {
  my ( $self, $old_value, $new_value ) = @_;
  if ($old_value == 1 && $new_value == 0 && !$self->seen_live) {
    $self->add_event('live');
    $self->seen_live(1);
    $self->update;
  }
}

sub add_report {
  my ( $self, $user, %data ) = @_;
  my $highest_id = 0;
  for (@{$self->reported}) {
    $highest_id = $_->{id} if $_->{id} > $highest_id;
  }
  my $report_data = {
    users_id => $user->id,
    time => DateTime->now->epoch,
    id => $highest_id + 1,
    %data,
  };
  push @{$self->reported}, $report_data;
  $self->make_column_dirty('reported');
  $self->add_event('report',%{$report_data});
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