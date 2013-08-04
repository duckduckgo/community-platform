package DDGC::DB::Result::Event::Group;
# ABSTRACT: A visual group for an event

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'event_group';

column id => {
  data_type => 'bigint',
  is_auto_increment => 1,
};
primary_key 'id';

unique_column key => {
  data_type => 'text',
  is_nullable => 0,
};

column data => {
  data_type => 'text',
  is_nullable => 1,
  serializer_class => 'JSON',
};

column notes => {
  data_type => 'text',
  is_nullable => 1,
};

column created => {
  data_type => 'timestamp with time zone',
  set_on_create => 1,
};

has_many 'events', 'DDGC::DB::Result::Event', 'event_group_id';

###############################

no Moose;
__PACKAGE__->meta->make_immutable;
