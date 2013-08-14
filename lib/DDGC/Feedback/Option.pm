package DDGC::Feedback::Option;

use Moose;
use MooseX::Storage;
with Storage('format' => 'Storable');

has description => (
  is => 'ro',
  isa => 'Str',
  predicate => 'has_description',
);

has type => (
  is => 'ro',
  isa => 'Str',
  default => sub { 'next' },
);

has name => (
  is => 'ro',
  isa => 'Str',
  predicate => 'has_name',
);

has placeholder => (
  is => 'ro',
  isa => 'Str',
  predicate => 'has_placeholder',
);

has icon => (
  is => 'ro',
  isa => 'Str',
  default => sub { 'arrow-right' },
);

has cssclass => (
  is => 'ro',
  isa => 'Str',
  default => sub { '' },
);

has optional => (
  is => 'ro',
  isa => 'Bool',
  default => sub { 0 },
);
sub required { !shift->optional }

has missing => (
  is => 'rw',
  isa => 'Bool',
  default => sub { 0 },
);

has target => (
  is => 'ro',
  isa => 'DDGC::Feedback::Step',
  predicate => 'has_target',
);

sub new_from_config {
  my ( $class, $config_value, $target ) = @_;
  my $values;
  my $ref = ref $config_value;
  if ($ref eq 'HASH') {
    $values = $config_value;
    $values->{icon} = 'user' unless defined $values->{icon} ||
      ( defined $values->{type} && $values->{type} eq 'next' );
  } elsif (!$ref) {
    $values = { description => $config_value };
  } else {
    die __PACKAGE__."->new_from_config Don't know how to handle ".$ref;
  }
  if (defined $target) {
    $values->{target} = $target;
  }
  return $class->new($values);
}

no Moose;
__PACKAGE__->meta->make_immutable;
