package DDGC::Web::Authentication::Store::DDGC;

use Moose;
use Scalar::Util qw( blessed );
use DDGC::Config;
use DDGC::User;

use Prosody::Storage::SQL;

has prosody_driver => (
	isa => 'Str',
	is => 'ro',
	lazy_build => 1,
);

has prosody_database => (
	isa => 'Str',
	is => 'ro',
	lazy_build => 1,
);

has prosody_host => (
	isa => 'Str',
	is => 'ro',
	lazy_build => 1,
);

sub _build_prosody_driver { DDGC::Config::prosody_db_driver }
sub _build_prosody_database { DDGC::Config::prosody_db_database }

has prosody_userhost => (
	isa => 'Str',
	is => 'ro',
	lazy_build => 1,
);
sub _build_prosody_userhost { DDGC::Config::prosody_userhost }

has username => (
	isa => 'Str',
	is => 'ro',
	predicate => 'has_username',
);

has host => (
	isa => 'Str',
	is => 'ro',
	predicate => 'has_host',
);

has password => (
	isa => 'Str',
	is => 'ro',
	predicate => 'has_password',
);

has _prosody => (
	isa => 'Prosody::Storage::SQL',
	is => 'ro',
	lazy_build => 1,
);

has _app => (
	is => 'rw',
);
sub c { shift->_app }

sub _build__prosody {
	my ( $self ) = @_;
	my %options;
	$options{driver} = $self->prosody_driver;
	$options{database} = $self->prosody_database;
	$options{username} = $self->username if $self->has_username;
	$options{password} = $self->password if $self->has_password;
	$options{host} = $self->host if $self->has_host;
	Prosody::Storage::SQL->new(\%options);
}

sub BUILDARGS {
    my ( $class, $config, $app, $realm ) = @_;

	my %options;
	
	$options{_app} = $app;
	
	$options{driver} = delete $config->{driver} if defined $config->{driver};
	$options{database} = delete $config->{database} if defined $config->{database};
	$options{username} = delete $config->{username} if defined $config->{username};
	$options{password} = delete $config->{password} if defined $config->{password};
	$options{host} = delete $config->{host} if defined $config->{host};

	$options{username} = DDGC::Config::prosody_db_username if !defined $config->{username} && defined DDGC::Config::prosody_db_username;
	$options{password} = DDGC::Config::prosody_db_password if !defined $config->{password} && defined DDGC::Config::prosody_db_password;
	$options{host} = DDGC::Config::prosody_db_host if !defined $config->{host} && DDGC::Config::prosody_db_host;

	$options{userhost} = $config->{userhost};

	return \%options;
}

sub from_session {
    my ( $self, $c, $username ) = @_;

    return $username if ref $username;

    $self->find_user({
		username => $username
	});
}

sub find_user {
    my ( $self, $userinfo ) = @_;

    my $username = delete $userinfo->{'username'};
	
	warn "can't handle other user attributes so far" if %{$userinfo};

	my $prosody_user = $self->_prosody->user($username.'@'.DDGC::Config::prosody_userhost);
	
	return if !%{$prosody_user};

	my $db_user = $self->c->model('DB::User')->find_or_create({
		username => $username,
		notes => 'Generated automatically via DDGC::Web based on prosody account',
	});

	return DDGC::User->new({
		username => $username,
		db => $db_user,
		prosody => $prosody_user,
	});
}

sub get_user {
    my ( $self, $username ) = @_;
    $self->find_user({ username => $username });
}

1;
