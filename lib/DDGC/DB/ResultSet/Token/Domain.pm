package DDGC::DB::ResultSet::Token::Domain;
# ABSTRACT: Resultset class for the token domains

use Moose;
extends 'DDGC::DB::Base::ResultSet';
use namespace::autoclean;

sub sorted {
	my ( $self ) = @_;
	$self->search({}, {
		order_by => { -asc => $self->me.'sorting' },
	});
}

no Moose;
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );
