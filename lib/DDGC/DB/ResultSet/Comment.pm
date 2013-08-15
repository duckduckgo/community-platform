package DDGC::DB::ResultSet::Comment;
# ABSTRACT: Resultset class for comment entries

use Moose;
extends 'DBIx::Class::ResultSet';
use namespace::autoclean;



no Moose;
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );
