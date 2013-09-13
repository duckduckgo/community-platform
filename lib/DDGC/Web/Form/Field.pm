package DDGC::Web::Form::Field;

use Moose;

sub i { 'DDGC::Web::Form::Field' }

has form => (
  is => 'ro',
  does => 'DDGC::Web::Role::Form',
  required => 1,
);

has name => (
  is => 'ro',
  isa => 'Str',
  required => 1,
);

has label => (
  is => 'ro',
  isa => 'Str',
  required => 1,
);

# cant empty
has notempty => (
  is => 'ro',
  isa => 'Bool',
  default => sub { 0 },
);

# is a hidden field
has hidden => (
  is => 'ro',
  isa => 'Bool',
  default => sub { 0 },
);
sub visible { shift->hidden ? 0 : 1 }

has type => (
  is => 'ro',
  isa => 'Str',
  lazy => 1,
  default => sub {
    my ( $self ) = @_;
    my $type = $self->meta->name;
    die "You can't use DDGC::Web::Form::Field as Form Field... haha irony"
      if $type eq __PACKAGE__;
    if ($type =~ m/^DDGC::Web::Form::Field::(.*)$/) {
      $type = $1;
    }
    $type =~ s/::/_/g;
    return lc($type);
  }
}

1;