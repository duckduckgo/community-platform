package DDGC::DB::ResultSet::User::Notification::Group;
# ABSTRACT: Resultset class for idea entries

use Moose;
extends 'DDGC::DB::Base::ResultSet';
use namespace::autoclean;

sub update_group_types {
  my ( $self ) = @_;
  my @ids;
  for ($self->result_class->default_types) {
    push @ids, $self->update_or_create($_,{
      key => 'user_notification_group_unique_key',
    })->id;
  }
  return $self->search({
    id => { -not_in => \@ids },
  })->delete;
}

no Moose;
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );
