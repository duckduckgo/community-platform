package DDGC::DB::ResultSet::GitHub::Repo;
# ABSTRACT: Resultset class for GitHub Repos

use Moose;
extends 'DDGC::DB::Base::ResultSet';
use namespace::autoclean;

no Moose;
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );
