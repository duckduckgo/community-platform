package DDGC::User;

use Moose;
use DDGC::XMPP;
use DDGC::DB;

has username => (
	isa => 'Str',
	is => 'ro',
	required => 1,
);

has db => (
	isa => 'DDGC::DB::Result::User',
	is => 'ro',
	required => 1,
	handles => [qw(
		public
		created
		updated
		update
		admin
		user_languages
		screens
		token_language_translations
	)],
);

sub password { shift->xmpp->{accounts}->{password} }

has xmpp => (
	isa => 'HashRef',
	is => 'ro',
	required => 1,
);

sub create {
	my ( $class, $username, $password ) = @_;
	
	return unless $username and $password;
	
	my %xmpp_user_find = DDGC::XMPP->new->user($username);
	
	die "user exists" if %xmpp_user_find;
	
	my $prosody_user;
	my $db_user;

	$prosody_user = DDGC::XMPP->new->_prosody->_db->resultset('Prosody')->create({
		host => DDGC::Config::prosody_userhost(),
		user => $username,
		store => 'accounts',
		key => 'password',
		type => 'string',
		value => $password,
	});

	if ($prosody_user) {
		$db_user = DDGC::DB->connect->resultset('User')->create({
			username => $username,
			notes => 'Created account',
		});
	}

	return unless $db_user;
	
	my %xmpp_user = DDGC::XMPP->new->user($username);
	
	return $class->new({
		username => $username,
		db => $db_user,
		xmpp => \%xmpp_user,
	});
}

sub find {
	my ( $class, $username ) = @_;

	return unless $username;

	my %xmpp_user = DDGC::XMPP->new->user($username);

	return unless %xmpp_user;

	my $db_user = DDGC::DB->connect->resultset('User')->find_or_create({
		username => $username,
		notes => 'Generated automatically based on prosody account',
	});

	return $class->new({
		username => $username,
		db => $db_user,
		xmpp => \%xmpp_user,
	});
}

# Store given by Catalyst
has store => (
	is => 'rw',
);

# Auth Realm given by Catalyst
has auth_realm => (
	is => 'rw',
);

# For Catalyst
sub supports {{}}

sub for_session {
	return shift->username;
}

sub get_object {
	return shift;
}
 
sub obj {
	my $self = shift;
	return $self->get_object(@_);
}

sub get {
	my ($self, $field) = @_;

	my $object;
	if ($object = $self->get_object and $object->can($field)) {
		return $object->$field();
	} else {
		return undef;
	}
}
### END

1;