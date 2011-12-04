package DDGC::User;

use Moose;
use DDGC::XMPP;
use DDGC::DB;
use Prosody::Mod::Data::Access;

has ddgc => (
	isa => 'DDGC',
	is => 'ro',
	weak_ref => 1,
	required => 1,
);

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
		id
		public
		created
		updated
		admin
		user_languages
		languages
		screens
		notes
		data
		token_language_translations
	),qw(
		create_related
		find_related
		update
	)],
);

has locales => (
	isa => 'HashRef[DDGC::DB::Result::User::Language]',
	is => 'ro',
	lazy_build => 1,
);

sub _build_locales {
	my ( $self ) = @_;
	my %locs;
	for ($self->db->search_related('user_languages',{},{ prefetch => 'language' })->all) {
		$locs{$_->language->locale} = $_;
	}
	return \%locs;
}

has xmpp => (
	isa => 'HashRef',
	is => 'ro',
	required => 1,
);

sub BUILD {
	my ( $self ) = @_;
	die "username of database is not username of DDGC::User" if $self->username ne $self->db->username;
}

sub check_password {
	my ( $self, $password ) = @_;
	my $mod_data_access = Prosody::Mod::Data::Access->new(
		jid => $self->username.'@'.$self->ddgc->config->prosody_userhost,
		password => $password,
	);
	my $data;
	eval {
		$data = $mod_data_access->get($self->username);
	};
	return $data ? 1 : 0;
}

sub public_username {
	my ( $self ) = @_;
	if ($self->public) {
		return $self->username;
	}
	return 'not public';
}

# For Catalyst

# Store given by Catalyst
has store => (
	is => 'rw',
);

# Auth Realm given by Catalyst
has auth_realm => (
	is => 'rw',
);

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