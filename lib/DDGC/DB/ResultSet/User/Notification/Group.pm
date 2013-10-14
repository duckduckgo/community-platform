package DDGC::DB::ResultSet::User::Notification::Group;
# ABSTRACT: Resultset class for idea entries

use Moose;
extends 'DDGC::DB::Base::ResultSet';
use namespace::autoclean;

sub deploy_group_types {
  my ( $self ) = @_;
  die "You can't redeploy group types (yet)" if $self->search({})->count;
  for ($self->result_class->default_types) {
    $self->create($_);
  }
}

no Moose;
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );
