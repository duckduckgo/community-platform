package DDGC::DB::Role::AntiSpam;
# ABSTRACT: A role for classes which have anti spam functionality

use Moose::Role;
use DateTime;

requires qw(
  ghosted
  reported
  checked
);

before reported => sub {
  my ( $self ) = @_;
  $self->set_column('reported','[]') unless $self->get_column('reported');
};

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