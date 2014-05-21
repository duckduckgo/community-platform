package DDGC::Web::Form::Field;
# ABSTRACT:

use Moose;

sub i { 'DDGC::Web::Form::Field' }

has form => (
  is => 'ro',
  isa => 'DDGC::Web::Form',
  required => 1,
);
sub c { shift->form->c }
sub has_obj { shift->form->has_obj }
sub obj { shift->form->obj }

has id => (
  is => 'ro',
  isa => 'Str',
  default => sub {
    my ( $self ) = @_;
    my $id = $self->form->id;
    $id .= '_'.$self->name;
  },
);

has name => (
  is => 'ro',
  isa => 'Str',
  required => 1,
);

has label => (
  is => 'ro',
  isa => 'Str',
  predicate => 'has_label',
);

has description => (
  is => 'ro',
  isa => 'Str',
  predicate => 'has_description',
);

# own full row visualization
has full => (
  is => 'ro',
  isa => 'Bool',
  lazy => 1,
  default => sub { 0 },
);

# cant empty
has notempty => (
  is => 'ro',
  isa => 'Bool',
  lazy => 1,
  default => sub { 0 },
);

sub new_is_notempty {
  my ( $self ) = @_;
  my $new_value = $self->new_value;
  return length($new_value) > 0;
}

# is a hidden field
has hidden => (
  is => 'ro',
  isa => 'Bool',
  lazy => 1,
  default => sub { 0 },
);
sub visible { shift->hidden ? 0 : 1 }

has type => (
  is => 'ro',
  isa => 'Str',
  lazy => 1,
  default => sub { 'text' },
);

has base_validators => (
  is => 'ro',
  isa => 'ArrayRef[CodeRef|RegexpRef|Str]',
  lazy => 1,
  default => sub {[]},
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

has validators => (
  is => 'ro',
  isa => 'ArrayRef[CodeRef|RegexpRef|Str]',
  lazy => 1,
  default => sub {[]},
);

has all_validators => (
  is => 'ro',
  isa => 'ArrayRef[CodeRef|RegexpRef]',
  lazy => 1,
  default => sub {
    my ( $self ) = @_;
    my @defined_validators = (@{$self->base_validators}, @{$self->validators});
    my @all_validators = ();
    for my $validator (@defined_validators) {
      if (ref $validator eq '') {
        my $function = 'validate_'.$validator;
        push @all_validators, sub {
          return $self->$function($self->new_value);
        };
      } else {
        push @all_validators, $validator;
      }
    }
  },
);

has has_obj_value => (
  is => 'ro',
  isa => 'Bool',
  lazy => 1,
  default => sub {
    my ( $self ) = @_;
    if ($self->has_obj) {
      if (ref $self->obj eq 'HASH') {
        return exists $self->obj->{$self->name};
      } elsif ($self->obj->can('has_'.$self->name)) {
        my $has_func = 'has_'.$self->name;
        return $self->obj->$has_func;
      } elsif ($self->obj->can($self->name)) {
        my $func = $self->name;
        return defined $self->obj->$func;
      }
    }
    return 0;
  },
);

sub session {
  my ( $self ) = @_;
  $self->form->session->{$self->id} = {} unless defined $self->form->session->{$self->id};
  return $self->form->session->{$self->id};
}

has obj_value => (
  is => 'ro',
  lazy => 1,
  default => sub {
    my ( $self ) = @_;
    return undef unless $self->has_obj;
    if (ref $self->obj eq 'HASH') {
      return $self->obj->{$self->name};
    } elsif ($self->obj->can($self->name)) {
      my $func = $self->name;
      return $self->obj->$func;
    }
    die "cant fetch obj_value";
  },
);

sub has_param_value {
  my ( $self ) = @_;
  defined $self->c->req->params->{$self->id};
}

sub param_value {
  my ( $self ) = @_;
  $self->c->req->params->{$self->id};
}

sub has_field_value {
  my ( $self ) = @_;
  return 1 if $self->has_param_value;
  return 1 if $self->has_obj_value;
  return 0;
}

sub field_value {
  my ( $self ) = @_;
  return $self->param_value if $self->has_param_value;
  return $self->obj_value if $self->has_obj_value;
  return undef;
}

sub has_new_value {
  my ( $self ) = @_;
  return 1 if $self->has_param_value;
  return 0;
}

sub new_value {
  my ( $self ) = @_;
  return $self->param_value if $self->has_param_value;
  return undef;
}

sub update_obj {
  my ( $self ) = @_;
  if ($self->has_obj) {
    if (ref $self->obj eq 'HASH') {
      $self->obj->{$self->name} = $self->new_value;
    } else {
      my $update_func = 'form_update_'.$self->name;
      if ($self->obj->can($update_func)) {
        return $self->obj->$update_func($self->new_value);
      }
      return $self->obj->$update_func($self->new_value);
    }
  }
  die "can't update value without an obj";
}

has valid => (
  is => 'ro',
  isa => 'Bool',
  default => sub {
    my ( $self ) = @_;
    my $valid = 1;
    if ($self->has_new_value) {
      if ($self->new_is_notempty) {
        for my $validator (@{$self->all_validators}) {
          if (ref $validator eq 'Regexp') {
            unless ($self->new_value =~ $validator) {
              $valid = $self->error('Invalid value');
            }
          } elsif (ref $validator eq 'CODE') {
            for ($self->new_value) {
              my $code_valid = $validator->($self,$self->c);
              unless ($code_valid) {
                $valid = 0;
              }
            }
          }
        }
      } elsif ($self->notempty) {
        $valid = $self->error('May not be empty');
      }
      if ($self->new_is_notempty && $self->notempty) {
        $valid = $self->new_is_notempty;
      }
    } else {
      $valid = 0;
    }
    return $valid;
  },
);

1;
