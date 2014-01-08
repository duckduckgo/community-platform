package DDGC::DB::ResultSet::Thread;
# ABSTRACT: Resultset class for thread entries

use Moose;
extends 'DDGC::DB::Base::ResultSet';
use namespace::autoclean;

sub prefetch_all {
  my ( $self ) = @_;
  $self->search_rs({},{
    prefetch => [qw( user )],
  });
}

1;