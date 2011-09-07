package DDGC::Web::Authentication::Store::Prosody;

use Moose;
use Scalar::Util qw( blessed );
use DDGC::Config;

use Prosody::Storage::SQL;

use Catalyst::Authentication::User::Hash;

has driver => (
	isa => 'Str',
	is => 'ro',
	lazy_build => 1,
);

has database => (
	isa => 'Str',
	is => 'ro',
	lazy_build => 1,
);

sub _build_driver { DDGC::Config::prosody_db_driver }
sub _build_database { DDGC::Config::prosody_db_database }

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

has userhost => (
	isa => 'Str',
	is => 'ro',
	required => 1,
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

sub _build__prosody {
	my ( $self ) = @_;
	my %options;
	$options{driver} = $self->driver;
	$options{database} = $self->database;
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
    my ( $self, $userinfo, $c ) = @_;

    my $username = $userinfo->{'username'};

	my $user = $self->_prosody->user($username.'@'.$self->userhost);
	
	return if !$user;
	
	$user->{password} = $user->{accounts}->{password};
	$user->{username} = $username;
	
    if ( ref($user) eq "HASH") {
        return bless $user, "Catalyst::Authentication::User::Hash";
    } elsif ( ref($user) && blessed($user) && $user->isa('Catalyst::Authentication::User::Hash')) {
        return $user;
    } else {
        Catalyst::Exception->throw( "The user '$username' must be a hash reference or an " .
                "object of class Catalyst::Authentication::User::Hash");
    }
    return $user;
}


# sub user_supports {
    # my $self = shift;

    # scalar keys %{ $self->userhash };
    # ( undef, my $user ) = each %{ $self->userhash };

    # $user->supports(@_);
# }

sub get_user {
    my ( $self, $username ) = @_;
    $self->find_user({ username => $username });
}

1;
