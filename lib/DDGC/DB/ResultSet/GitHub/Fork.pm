package DDGC::DB::ResultSet::GitHub::Fork;
# ABSTRACT: Resultset class for GitHub Forks

use Moose;
extends 'DDGC::DB::Base::ResultSet';
use namespace::autoclean;

sub with_created_at {
    my ($self, $operator, $date) = @_;
	$self->search({ 'me.created_at' => { $operator => $date } });
}

no Moose;
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );
