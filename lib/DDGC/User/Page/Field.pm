package DDGC::User::Page::Field;

use Moose;
use Email::Valid;
use Data::Validate::URI qw(is_uri);

#######################################################

my %types = (
	email => {
		view => 'email',
		validators => ['email'],
	},
	url => {
		view => 'url',
		validators => ['url'],
	},
	text => {},
	textarea => { edit => 'textarea' },
);

########################################################

has page => (
	is => 'ro',
	isa => 'DDGC::User::Page',
	required => 1,
);

has type => (
	is => 'ro',
	isa => 'Str',
	lazy => 1,
	default => sub { 'text' }
);

has name => (
	is => 'ro',
	isa => 'Str',
	required => 1,
);

has description => (
	is => 'ro',
	isa => 'Str',
	required => 1,
);

has view => (
	is => 'ro',
	isa => 'Str',
	lazy => 1,
	default => sub {
		my ( $self ) = @_;
		defined $types{$self->type} && defined $types{$self->type}->{view}
			? $types{$self->type}->{view}
			: 'text'
	},
);

has edit => (
	is => 'ro',
	isa => 'Str',
	lazy => 1,
	default => sub {
		my ( $self ) = @_;
		defined $types{$self->type} && defined $types{$self->type}->{edit}
			? $types{$self->type}->{edit}
			: 'text'
	},
);

has validators => (
	is => 'ro',
	isa => 'ArrayRef[Str|CodeRef]',
	lazy => 1,
	default => sub {[]},
);

has all_validators_coderef => (
	is => 'ro',
	isa => 'ArrayRef[CodeRef]',
	lazy_build => 1,
);

sub _build_all_validators_coderef {
	my ( $self ) = @_;
	[map {
		if (ref $_ eq 'CODE') {
			$_
		} else {
			my $func = 'validator_'.$_;
			\&$func;
		}
	} @{$self->validators},
		defined $types{$self->type} && defined $types{$self->type}->{validators}
			? @{$types{$self->type}->{validators}}
			: ()];
}

sub validator_email {
	Email::Valid->address($_) ? () : ("Invalid email address")
}

sub validator_url {
	is_uri($_) ? () : ("Not an URI")
}

has value => (
	is => 'rw',
	trigger => sub {
		my ( $self ) = @_;
		$self->clear_errors;
	},
	predicate => 'has_value',
);

has errors => (
	is => 'ro',
	isa => 'ArrayRef[Str]',
	lazy_build => 1,
	clearer => 'clear_errors',
);

sub _build_errors {
	my ( $self ) = @_;
	return [] unless $self->has_value && $self->value ne '';
	my @errors;
	for my $validator (@{$self->all_validators_coderef}) {
		local $_ = $self->value;
		push @errors, $validator->($self);
	}
	# filter out simple false validators
	[map {
		$_ ? $_ : "Invalid value"
	} @errors]
}

sub valid { shift->error_count ? 0 : 1 }

sub error_count {
	my ( $self ) = @_;
	return scalar @{$self->errors};
}

1;