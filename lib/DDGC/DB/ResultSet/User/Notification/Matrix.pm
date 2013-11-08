package DDGC::DB::ResultSet::User::Notification::Matrix;
# ABSTRACT: Resultset class for idea entries

use Moose;
extends 'DDGC::DB::Base::ResultSet';
use namespace::autoclean;

sub prefetch_all {
  my ( $self ) = @_;
  $self->search_rs({},{
    prefetch => [qw( user ), $self->prefetch_context_config(
      'DDGC::DB::Result::User::Notification::Matrix',
      comment_prefetch => $self->prefetch_context_config('DDGC::DB::Result::Comment'),
    )],
  });
}

no Moose;
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );
