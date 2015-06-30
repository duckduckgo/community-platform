package DDGC::DB::ResultSet::GitHub::Repo;
# ABSTRACT: Resultset class for GitHub Repos

use Moose;
extends 'DDGC::DB::Base::ResultSet';
use namespace::autoclean;

sub latest_issue {
}

no Moose;
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );
