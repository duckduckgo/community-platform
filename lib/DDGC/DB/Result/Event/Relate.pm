package DDGC::DB::Result::Event::Relate;
# ABSTRACT: A context relation of an event

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'event_relate';

column id => {
  data_type => 'bigint',
  is_auto_increment => 1,
};
primary_key 'id';

column event_id => {
  data_type => 'bigint',
  is_nullable => 0,
};
belongs_to 'event', 'DDGC::DB::Result::Event', 'event_id';

###########
column context => {
  data_type => 'text',
  is_nullable => 0,
};
column context_id => {
  data_type => 'bigint',
  is_nullable => 0,
};
with 'DDGC::DB::Role::HasContext';
###########

__PACKAGE__->add_context_relations;

column created => {
  data_type => 'timestamp with time zone',
  set_on_create => 1,
};

###############################

no Moose;
__PACKAGE__->meta->make_immutable;
