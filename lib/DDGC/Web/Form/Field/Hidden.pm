package DDGC::Web::Form::Field::Hidden;

use Moose;
extends 'DDGC::Web::Form::Field';

has '+hidden' => (
  default => sub { 1 },
);

1;