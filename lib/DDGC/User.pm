package DDGC::User;

use Moose;

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

has prosody => (
	isa => 'HashRef',
	is => 'ro',
	required => 1,
);

# Store given by Catalyst
has store => (
	is => 'rw',
);

# Auth Realm given by Catalyst
has auth_realm => (
	is => 'rw',
);

sub password { shift->prosody->{accounts}->{password} }

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