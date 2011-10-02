package DDGCTest::Database;

use Moose;
use DDGC::DB;
use Try::Tiny;

has _ddgc => (
	is => 'ro',
	required => 1,
);

sub BUILDARGS {
    my ( $class, $ddgc ) = @_;
	my %options;
	$options{_ddgc} = $ddgc;
	return \%options;
}

sub deploy {
	my ( $self ) = @_;
	$self->_ddgc->deploy_fresh;
}

1;
