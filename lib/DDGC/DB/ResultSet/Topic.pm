package DDGC::DB::ResultSet::Topic;
# ABSTRACT: Resultset class for topic

use Moose;
extends 'DDGC::DB::Base::ResultSet';
use namespace::autoclean;

no Moose;
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );

