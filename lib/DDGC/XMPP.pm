package DDGC::XMPP;
# ABSTRACT: Access to the XMPP server

use Moose;
use DDGC::Config;
use DDGC::User;

use Prosody::Storage::SQL;
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

sub _build__prosody {
	my ( $self ) = @_;
	my %options;
	$options{driver} = $self->prosody_driver;
	$options{database} = $self->prosody_database;
#	$options{username} = $self->username if $self->has_username;
#	$options{password} = $self->password if $self->has_password;
#	$options{host} = $self->host if $self->has_host;
	Prosody::Storage::SQL->new(\%options);
}

sub user {
	my ( $self, $username ) = @_;
	return unless $username;
	my $data = $self->_prosody->user($username.'@'.$self->prosody_userhost);
	return %{$data};
}

no Moose;
__PACKAGE__->meta->make_immutable;
