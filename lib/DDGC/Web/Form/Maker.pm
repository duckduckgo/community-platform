package DDGC::Web::Form::Maker;
# ABSTRACT: Webform maker

use Moose ();
use Moose::Exporter;
use Class::Load ':all';

my ( $import, $unimport, $init_meta ) = Moose::Exporter->setup_import_methods(
  with_meta       => [qw(

    field
    default_field_class
    form_class

    f_text
    f_textarea
    f_upload
    f_select
    f_hidden

  )],
  install         => [qw(
    import
    unimport
  )],
  class_metaroles => {
    class       => ['DDGC::Web::Role::Meta::Form'],
  },
  base_class_roles => ['DDGC::Web::Role::Formable'],
);

sub form_class {
  my ( $meta, $default ) = @_;
  $meta->form_class($default);
}

sub default_field_class {
  my ( $meta, $default ) = @_;
  $meta->default_form_field_class($default);
}

sub field {
  my ( $meta, $name, %args ) = @_;
  $args{name} = $name;
  $args{class} = $meta->default_form_field_class unless defined $args{class};
  $meta->add_form_field_definition(\%args);
  return $name;
}

sub f_text { field(shift,shift, class => 'Text', @_) }
sub f_textarea { field(shift,shift, class => 'Textarea', @_) }
sub f_upload { field(shift,shift, class => 'Upload', @_) }
sub f_select { field(shift,shift, class => 'Select', @_) }
sub f_hidden { field(shift,shift, class => 'Hidden', @_) }

1;