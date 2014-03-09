package DDGC::Role::Table::Field;
# ABSTRACT: One field of a table

use Moose;
use Email::Valid;
use Data::Validate::URI qw(is_uri);
use Locale::Country;
use Digest::MD5 'md5_hex';

#######################################################

my %types = (
	email => {
		view => 'email',
		validators => ['email'],
		export => 'email',
	},
	email_md5 => { # Validate as email, export as md5sum of email
		view => 'email',
		validators => ['email'],
		export => 'md5',
	},
	url => {
		view => 'url',
		validators => ['url'],
	},
	text => {},
	textarea => {
		edit => 'textarea',
	},
	select => {
		view => 'select',
		edit => 'select',
		validators => ['select'],
		export => 'select',
	},
	country => {
		view => 'select',
		edit => 'select',
		validators => ['select'],
		params => {
			options => [
				'' => 'Pick a country',
				map { country2code($_) => $_ } all_country_names(),
			],
		},
		export => 'select',
	},
	noyes => {
		view => 'select',
		edit => 'select',
		validators => ['select'],
		params => {
			options => [
				'' => 'No',
				'1' => 'Yes',
			],
		},
		export => 'select',
	},
	remote => {
		view => 'remote',
		edit => 'remote',
		export => 'remote',
	},
);

########################################################

has table => (
	is => 'ro',
	does => 'DDGC::Role::Table',
	required => 1,
);

has type => (
	is => 'ro',
	isa => 'Str',
	lazy => 1,
	default => sub { 'text' },
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

has export => (
	is => 'ro',
	isa => 'Undef|Str|CodeRef',
	lazy => 1,
	default => sub {
		my ( $self ) = @_;
		defined $types{$self->type} && defined $types{$self->type}->{export}
			? $types{$self->type}->{export}
			: undef
	},
);

has no_export => (
	is => 'ro',
	isa => 'Bool',
	lazy => 1,
	default => sub { 0 },
);

has params => (
	is => 'ro',
	isa => 'HashRef',
	lazy => 1,
	default => sub {
		my ( $self ) = @_;
		defined $types{$self->type} && defined $types{$self->type}->{params}
			? $types{$self->type}->{params}
			: {}
	},
);

sub options {
        my $self = shift;
	my @opts = @_ || @{$self->params->{options}};
	my @options;
	while (@opts) {
		my $value = shift @opts;
		my $name = shift @opts;
		push @options, {
			value => $value,
			name => $name,
		}
	}
	return \@options;
}

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

sub validator_select {
	my ( $self ) = @_;
	my $value = $_;
	for (@{$self->options}) {
		return () if $_->{value} eq $value;
	}
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

sub export_select {
	my ( $self ) = @_;
	return "" unless $self->value;
	for (@{$self->options}) {
		return $_->{name} if $_->{value} eq $self->value;
	}
	return $self->value;
}

sub export_email {
	my ( $self ) = @_;
	my $val = $self->value;
	$val =~ s/@/ at /;
	return $val;
}

sub export_md5 {
	my ( $self ) = @_;
	my $val = $self->value;
        return '' unless length($val);
	$val = md5_hex($val);
	return $val;
}

sub export_remote {
	my ( $self ) = @_;
	return "" unless $self->value;
	my $url_prefix = defined $self->params->{url_prefix}
		? $self->params->{url_prefix} : '';
	my $url_suffix = defined $self->params->{url_suffix}
		? $self->params->{url_suffix} : '';
	return $url_prefix.$self->value.$url_suffix;
}

sub export_function {
	my ( $self ) = @_;
	if ($self->export) {
		if (ref $self->export eq 'CODE') {
			return $self->export;
		} else {
			my $funcname = 'export_'.$self->export;
			my $func = $self->can($funcname);
			return $func if $func;
			die __PACKAGE__." cant find export function ".$funcname;
		}
	} else {
		return sub { shift->value };
	}
}

sub export_value {
	my ( $self ) = @_;
	$self->export_function->($self);
}


sub i { 'table_field' }

1;

__DATA__

=pod

=encoding UTF-8

=head1 SYNOPSIS

    # ... in a DDGC::Role::Table-consuming class' attributes
    'field_name' => 'Human-readable field name' => {%attrs},

=head1 DESCRIPTION

This represents a single field in a L<DDGC::Role::Table>, handling validation,
exporting, errors, etc. for any field type and properties you throw at it.
B<Note:> This is not a role, it is merely under DDGC::Role to live with its
parent.

=head1 SEE ALSO

=over 4

=item L<DDGC::Role::Table>

=back

=cut
