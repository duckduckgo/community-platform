package DDGC::DB;
# ABSTRACT: DBIx::Class schema

use Moose;
use MooseX::NonMoose;
extends 'DBIx::Class::Schema';
__PACKAGE__->load_namespaces(
  default_resultset_class => 'Base::ResultSet',
);
use Cache::FileCache;
use Carp;

use namespace::autoclean;

$ENV{DBIC_NULLABLE_KEY_NOWARN} = 1;

has _ddgc => (
	isa => 'DDGC',
	is => 'rw',
);

sub ddgc { $_[0]->_ddgc }
sub ddgc_config { $_[0]->ddgc->ddgc_config; }
sub app { $_[0]->ddgc }

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
		cache_object => $ddgc->cache,
	});
	return $schema;
}

has no_events => (
	isa => 'Bool',
	is => 'rw',
	default => sub { 0 },
);

sub without_events {
	my ( $self, $code ) = @_;
	die "without_events need coderef" unless ref $code eq 'CODE';
	my $change_it = $self->no_events ? 0 : 1;
	$self->no_events(1) if $change_it;
	eval {
		$code->();
	};
	$self->no_events(0) if $change_it;
	croak $@ if $@;
	return;
}

sub get_by_i_param {
	my ( $self, $i_param ) = @_;
	my ( $class, $id ) = split(/\|/, $i_param);
	my $resultset = $class;
	$resultset =~ s/DDGC::DB::Result:://g;
	return $self->resultset($resultset)->find($id);
}

sub format_datetime { shift->storage->datetime_parser->format_datetime(shift) }

sub rs { shift->resultset(@_) }

no Moose;
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );
