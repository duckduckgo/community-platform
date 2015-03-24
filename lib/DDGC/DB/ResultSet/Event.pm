package DDGC::DB::ResultSet::Event;
# ABSTRACT: Resultset class for user

use Moose;
extends 'DDGC::DB::Base::ResultSet';
use namespace::autoclean;

no Moose;
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );
