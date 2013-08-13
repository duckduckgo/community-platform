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

has optional => (
  is => 'ro',
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
