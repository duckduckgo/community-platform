package DDGC::DB::ResultSet::Thread;
# ABSTRACT: Resultset class for thread entries

use Moose;
extends 'DDGC::DB::Base::ResultSet';
use namespace::autoclean;



no Moose;
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );
