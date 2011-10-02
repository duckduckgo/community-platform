package DDGC::XMPP;

use Moose;
use DDGC::Config;
use DDGC::User;

use Prosody::Storage::SQL;

has prosody_driver => (
	isa => 'Str',
	is => 'ro',
	lazy_build => 1,
);
sub _build_prosody_driver { DDGC::Config::prosody_db_driver }

has prosody_database => (
	isa => 'Str',
	is => 'ro',
	lazy_build => 1,
);
sub _build_prosody_database { DDGC::Config::prosody_db_database }

has prosody_userhost => (
	isa => 'Str',
	is => 'ro',
	lazy_build => 1,
);
sub _build_prosody_userhost { DDGC::Config::prosody_userhost }

has _prosody => (
	isa => 'Prosody::Storage::SQL',
	is => 'ro',
	lazy_build => 1,
);

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

1;