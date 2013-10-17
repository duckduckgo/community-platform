package DDGC::XMPP;
# ABSTRACT: Access to the XMPP server

use Moose;
use DDGC::Config;
use DDGC::User;

use Prosody::Storage::SQL;
use Prosody::Storage::SQL::DB;
use Prosody::Mod::Data::Access;

has ddgc => (
	isa => 'DDGC',
	is => 'ro',
	required => 1,
	weak_ref => 1,
);

has prosody_driver => (
	isa => 'Str',
	is => 'ro',
	lazy_build => 1,
);
sub _build_prosody_driver { shift->ddgc->config->prosody_db_driver }

has prosody_database => (
	isa => 'Str',
	is => 'ro',
	lazy_build => 1,
);
sub _build_prosody_database { shift->ddgc->config->prosody_db_database }

has prosody_userhost => (
	isa => 'Str',
	is => 'ro',
	lazy_build => 1,
);
sub _build_prosody_userhost { shift->ddgc->config->prosody_userhost }

has _prosody => (
	isa => 'Prosody::Storage::SQL',
	is => 'ro',
	lazy_build => 1,
);

has admin_data_access => (
	isa => 'Prosody::Mod::Data::Access',
	is => 'ro',
	lazy_build => 1,
);
sub _build_admin_data_access {
	my $self = shift;
	Prosody::Mod::Data::Access->new(
		jid => $self->ddgc->config->prosody_admin_username.'@'.$self->ddgc->config->prosody_userhost,
		password => $self->ddgc->config->prosody_admin_password,
	);
}

sub prosody_dsn {
	my ( $self ) = @_;
	my $driver;
	$driver = 'SQLite' if $self->ddgc->config->prosody_db_driver eq "SQLite3";
	$driver = 'mysql' if $self->ddgc->config->prosody_db_driver eq "MySQL";
	$driver = 'Pg' if $self->ddgc->config->prosody_db_driver eq "PostgreSQL";
	return 'dbi:'.$driver.':dbname='.$self->ddgc->config->prosody_database.( $self->ddgc->config->prosody_host ? ';host='.$self->ddgc->config->prosody_host : '' )
}

sub _build__prosody {
	my ( $self ) = @_;
	my $prosody_storage = Prosody::Storage::SQL->new({
		database => $self->ddgc->config->prosody_db_database,
		driver => $self->ddgc->config->prosody_db_driver,
		_db => Prosody::Storage::SQL::DB->connect(@{$self->ddgc->config->prosody_connect_info}),
	});
	$prosody_storage->_db->default_resultset_attributes({
		cache_object => $self->ddgc->cache,
	});
	return $prosody_storage;
}

sub user {
	my ( $self, $username ) = @_;
	return unless $username;
	die "Do not use @, only give your username" if $username =~ m/@/g;
	my $data = $self->_prosody->user(lc($username).'@'.$self->prosody_userhost);
	return %{$data};
}

no Moose;
__PACKAGE__->meta->make_immutable;
