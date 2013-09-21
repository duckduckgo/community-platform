package DDGC::DB;
# ABSTRACT: DBIx::Class schema

use Moose;
use MooseX::NonMoose;
extends 'DBIx::Class::Schema';
__PACKAGE__->load_namespaces();
use Cache::FileCache;

use namespace::autoclean;

has _ddgc => (
	isa => 'DDGC',
	is => 'rw',
);
sub ddgc { shift->_ddgc }

sub connect {
	my ( $self, $ddgc ) = @_;
	$ddgc = $self->ddgc if ref $self;
	my $schema = $self->next::method(
		$ddgc->config->db_dsn(),
		$ddgc->config->db_user(),
		$ddgc->config->db_password(),
		$ddgc->config->db_params(),
	);
	$schema->_ddgc($ddgc);
	$schema->default_resultset_attributes({
		cache_object => Cache::FileCache->new({
			namespace => __PACKAGE__
		})
	});
	return $schema;
}

no Moose;
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );
