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
  isa => 'Object|HashRef',
  predicate => 'has_obj',
);

has finish_code => (
  is => 'ro',
  isa => 'CodeRef',
  predicate => 'has_finish_code',
);

has errors => (
  is => 'ro',
  isa => 'ArrayRef[Str]',
  default => sub {[]},
  lazy => 1,
);
sub has_errors { scalar @{$_[0]->errors} }

sub error {
  my ( $self, $error_string ) = @_;
  push @{$self->errors}, $error_string;
  return 0;
}

sub session {
  my ( $self ) = @_;
  $self->c->session->{web_forms} = {} unless defined $self->form->session->{web_forms};
  $self->c->session->{web_forms}->{$self->id} = {} unless defined $self->c->session->{web_forms}->{$self->id};
  return $self->c->session->{web_forms}->{$self->id};
}

sub clear_session {
  my ( $self ) = @_;
  return unless defined $self->form->session->{web_forms};
  delete $self->c->session->{web_forms}->{$self->id} if defined $self->c->session->{web_forms}->{$self->id};
}

has id => (
  is => 'ro',
  isa => 'Str',
  default => sub {
    my ( $self ) = @_;
    my $id = $self->name;
    if ($self->has_no) {
      $id .= $self->no;
    }
    if ($self->has_obj) {
      my $obj_id;
      if (ref $self->obj eq 'HASH') {
        $obj_id = $self->obj->{id} if defined $self->obj->{id};
      } else {
        if ($self->obj->can('id') && $self->obj->id) {
          $obj_id = $self->obj->id;
        }
      }
      if ($obj_id) {
        $id .= '_'.$obj_id;
      }
    }
  },
);

has name => (
  is => 'ro',
  isa => 'Str',
  required => 1,
);

has no => (
  is => 'ro',
  isa => 'Int',
  predicate => 'has_no',
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
      push @fields, $class->new( form => $self, %{$field_definition});
    }
    return \@fields;
  },
);

has visible_fields => (
  is => 'ro',
  isa => 'ArrayRef[DDGC::Web::Form::Field]',
  lazy => 1,
  default => sub {
    my ( $self ) = @_;
    return [grep { $self->visible } @{$self->fields}];
  },
);

has hidden_fields => (
  is => 'ro',
  isa => 'ArrayRef[DDGC::Web::Form::Field]',
  lazy => 1,
  default => sub {
    my ( $self ) = @_;
    return [grep { $self->hidden } @{$self->fields}];
  },
);

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
    field_definitions => $field_definitions,
    %args,
  );
}

has valid => (
  is => 'ro',
  isa => 'Bool',
  lazy => 1,
  default => sub {
    my $self = shift;
    my $valid = 1;
    for (@{$self->fields}) {
      unless ($_->valid) {
        $valid = 0;
      }
    }
    return $valid;
  },
);

sub submitted {
  my ( $self ) = @_;
  return 1 if defined $self->c->req->params->{$self->id};
  return 0;
}

sub update_obj {
  my ( $self ) = @_;
  die "can't update without an obj" unless $self->has_obj;
  return 0 unless $self->valid;
  return 0 if $self->no_update;
  my $i = 0;
  for (@{$self->fields}) {
    $_->update_obj;
    $i++;
  }
  return $i;
}

sub finish {
  my ( $self ) = @_;
  return undef unless $self->submitted;
  return undef unless $self->valid;
  if ($self->has_obj && !$self->has_finish_code) {
    $self->update_obj;
    return $self->obj;
  } else {
    my %values;
    for (@{$self->fields}) {
      $values{$_->name} = $_->new_value if $_->has_new_value;
    }
    if ($self->has_finish_code) {
      return $self->finish_code->($self,\%values);
    } else {
      return \%values;
    }
  }
}

no Moose;
__PACKAGE__->meta->make_immutable;
