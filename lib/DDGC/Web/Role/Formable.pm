package DDGC::Web::Role::Formable;
# ABSTRACT: TODO - dont use

use Moose::Role;

sub get_form { 
  my $self = shift;
  my $c = shift;
  $self->meta->get_form($c,$self,@_);
}

1;