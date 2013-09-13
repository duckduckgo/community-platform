package DDGC::Web::Form;
# ABSTRACT: Webform importer

use Moose;
use Class::Load;

has c => (
  is => 'ro',
  isa => 'DDGC::Web',
  required => 1,
);
sub d { shift->c->d }

has obj => (
  is => 'ro',
  predicate => 'has_obj',
);

has name => (
  is => 'ro',
  isa => 'Str',
  required => 1,
);

has fields => (
  is => 'ro',
  isa => 'ArrayRef[DDGC::Web::Form::Field]',
  lazy => 1,
  default => sub {
    my ( $self ) = @_;
    my @fields;
    for my $field_definition (@{$self->field_definitions}) {
      my $class = delete $field_definition->{class};
      Class::Load::load_class($class);
      push @fields, $class->new(%{$field_definition});
    }
    return \@fields;
  },
);

sub visible_fields {
  my ( $self ) = @_;
  return [grep { $self->visible } @{$self->fields}];
}

has field_definitions => (
  is => 'ro',
  isa => 'ArrayRef[HashRef]',
  required => 1,
);

has fields_hash => (
  is => 'ro',
  isa => 'HashRef[DDGC::Web::Form::Field]',
  lazy => 1,
  default => sub {
    my $self = shift;
    my %hash;
    for (@{$self->fields}) {
      $hash{$_->name} = $_;
    }
    return \%hash,
  },
);

sub get_field { shift->fields_hash->{shift} }

sub new_via_definitions {
  my ( $class, $c, $name, $field_definitions, %args ) = @_;
  return $class->new(
    c => $c,
    name => $name,
    defined $args{obj} ? ( obj => delete $args{obj} ) : (),
    field_definitions => field_definitions,
    %args,
  );
}

sub is_submitted {
  my ( $self ) = @_;
  if (defined $self->c->req->params->{$self->id}) {
    return 1;
  }
  return 0;
}

no Moose;
__PACKAGE__->meta->make_immutable;
