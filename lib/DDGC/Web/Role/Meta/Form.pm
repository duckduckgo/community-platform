package DDGC::Web::Role::Meta::Form;

use Moose::Role;
use Class::Load;

has form_name => (
  is => 'rw',
  isa => 'Str',
  default => sub {
    use DDP; p($_[0]);
    p($_[0]->linearized_isa);
    exit 1;
    my $form_name = $_[0]->name;
    $form_name =~ s/::/_/g;
    return lc($form_name);
  },
);

has form_class => (
  is => 'rw',
  isa => 'Str',
  default => sub { 'DDGC::Web::Form' },
);

has default_form_field_class => (
  is => 'rw',
  isa => 'Str',
  default => sub { 'Text' },
);

has form_field_definitions => (
  traits  => ['Array'],
  is => 'ro',
  isa => 'ArrayRef[HashRef]',
  default => sub { [] },
  handles => {
    add_form_field_definition => 'push',
    map_form_field_definitions => 'map',
    has_form_field_definitions => 'count',
  },
);

sub get_form {
  my ( $self, $c, $with, %args ) = @_;
  my @field_definitions;
  for my $field_definition (@{$self->form_field_definitions}) {
    my $add = 1;
    if (defined $field_definition->{condition}) {
      my $cond = delete $field_definition->{condition};
      $add = $cond->($c,$with,%args) for ($field_definition);
    }
    if ($add) {
      push @field_definitions, $field_definition;
    }
  }
  $args{obj} = $with if ref $with;
  $args{obj} = $with->new if defined $INC{$with} and $with->can('new');
  my $form_name = defined $args{form_name}
    ? delete $args{form_name}
    : $self->form_name;
  my $form_class = defined $args{form_class}
    ? delete $args{form_class}
    : $self->form_class;
  Class::Load::load_class($form_class);
  $form_class->new_via_definitions($c, $form_name, \@field_definitions);
}

1;
