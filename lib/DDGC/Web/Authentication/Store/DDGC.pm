package DDGC::Web::Authentication::Store::DDGC;

use Moose;
use Scalar::Util qw( blessed );
use DDGC::Config;
use DDGC::User;

has _app => (
	is => 'rw',
);
sub c { shift->_app }

sub BUILDARGS {
    my ( $class, $config, $app, $realm ) = @_;

	my %options;
	
	$options{_app} = $app;

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
	
	return unless $username;
	
	return DDGC::User->find($username);
}

sub get_user {
    my ( $self, $username ) = @_;
    $self->find_user({ username => $username });
}

1;
