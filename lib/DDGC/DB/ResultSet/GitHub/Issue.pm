package DDGC::DB::ResultSet::GitHub::Issue;
# ABSTRACT: Resultset class for GitHub Issues

use Moose;
extends 'DDGC::DB::Base::ResultSet';
use namespace::autoclean;

#sub with_author_date {
#    my ($self, $operator, $date) = @_;
#	$self->search({ author_date => { $operator => $date } });
#}

no Moose;
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );
