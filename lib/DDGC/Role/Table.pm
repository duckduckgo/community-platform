package DDGC::Role::Table;
# ABSTRACT: Role for managing tabular data without a database

use Moose::Role;
use DDGC::Role::Table::Field;
use URI;

# The arrayref of field descriptors
requires 'attributes';

has data => (
	is => 'ro',
	isa => 'HashRef',
	lazy => 1,
	default => sub {{}},
);

sub export {
	my ( $self ) = @_;
	my %export;
	my %errors;
	for (keys %{$self->attribute_fields}) {
		next if $self->field($_)->no_export;
		$export{$_} = $self->field($_)->export_value;
		$errors{$_} = $self->field($_)->errors if $self->field($_)->error_count;
	}
	$export{errors} = \%errors if %errors;
	return \%export;
}

has attribute_fields => (
	is => 'ro',
	isa => 'HashRef[DDGC::Role::Table::Field]',
	lazy_build => 1,
);

sub field {
	my ( $self, $name ) = @_;
	return $self->attribute_fields->{$name};
}

sub _build_attribute_fields {
	my ( $self ) = @_;
	my %fields;
	my @attrs = @{$self->attributes};
	while (@attrs) {
		my $name = shift @attrs;
		my $desc = shift @attrs;
		my %extra = %{shift @attrs};
		my $value = defined $self->data->{$name}
			? $self->data->{$name}
			: '';
		$fields{$name} = DDGC::Role::Table::Field->new(
			table => $self,
			name => $name,
			description => $desc,
			value => $value,
			%extra,
		);
	}
	return \%fields;
}

sub update_data {
	my ( $self, $data ) = @_;
	my $error_count;
	for (keys %{$data}) {
		my $key = $_;
		my $value = $data->{$_};
		my $field = $self->field($_);
		if ($field) {
			$field->value($value);
			if ($field->error_count) {
				$error_count += $field->error_count;
			} else {
				$self->data->{$key} = $value;
			}
		}
	}
	return $error_count;
}

sub has_value_for {
	my ( $self, @fields ) = @_;
	for (@fields) {
		return 1 if $self->field($_)->value;
	}
	return 0;
}

1;

__DATA__

=pod

=encoding UTF-8

=head1 SYNOPSIS

    sub attributes {[
        field_name => 'A human-readable description' => {}, # a simple one-line text field
        email      => 'Your email address' => { type => 'email' }, # nicely validated email field
        cpan_id    => 'Your CPAN username' => {
            # account-link style field with a custom validator
            type => 'remote',
            validators => [sub {
                m/^[A-Z]{4,9}$/ ? () : ("Invalid CPAN ID")
            }],
            params => {
                url_prefix => 'http://metacpan.org/author/',
                user_suffix => ' on CPAN',
                icon => 'cpan',
            },
        },
    ]}
    with 'DDGC::Role::Table';

    sub new_from_user {
        my ($class, $user) = @_;
        $class->new(
            data => $user->data,
        );
    }

=head1 DESCRIPTION

This describes a database-like table which can be encoded to JSON, stored
in a real database, printed on the moon, etc. It provides extensive field
validation, as well as a variety of convenient methods for displaying/editing
data on the web, and storing it or exporting it somehow.

It is currently used by L<DDGC::User::Page> for custom user page data, as well
as L<DDGC::GitHub> and friends for managing pull requests and the variety of
data they can hold.

=head1 ATTRIBUTES

=over 4

=item B<data>

This is usually the input data. It is a hashref of C<field => value>, where
field is the first parameter in each field descriptor--the machine-readable
name.

=back

=head1 METHODS

=over 4

=item B<export>

B<Arguments:>

B<Return Value:> \%export

Export the contents of the table to a plain HashRef, ready for storing
somewhere else. If there is an error in validation, $$export{errors} will
contain a hashref of C<field => error message>.

=back

=cut
