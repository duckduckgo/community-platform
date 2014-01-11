package DDGC::DB::ResultSet::User::Report;
# ABSTRACT: Resultset class

use Moose;
extends 'DDGC::DB::Base::ResultSet';
use namespace::autoclean;

sub prefetch_all {
  my ( $self ) = @_;
  $self->search_rs({},{
    prefetch => [qw( user ), $self->prefetch_context_config],
  });
}

1;