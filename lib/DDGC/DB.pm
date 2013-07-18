package DDGC::DB;
# ABSTRACT: DBIx::Class schema

use Moose;
extends 'DBIx::Class::Schema';

use DDGC::Config;

__PACKAGE__->load_namespaces();

has _ddgc => (
	isa => 'DDGC',
	is => 'rw',
);
sub ddgc { shift->_ddgc }

sub connect {
	my ( $self, $ddgc ) = @_;
	$ddgc = $self->ddgc if ref $self;
	my $schema = $self->next::method(
		$ddgc->config->db_dsn,
		$ddgc->config->db_user,
		$ddgc->config->db_password,
		$ddgc->config->db_params,
	);
	$schema->_ddgc($ddgc);
	return $schema;
}

1;