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
belongs_to 'event', 'DDGC::DB::Result::Event', 'event_id', {
  on_delete => 'cascade',
};

__PACKAGE__->add_context_relations;

column created => {
  data_type => 'timestamp with time zone',
  set_on_create => 1,
};

__PACKAGE__->indices(
  event_related_context_idx => 'context',
  event_related_context_id_idx => 'context_id',
);

###############################

no Moose;
__PACKAGE__->meta->make_immutable ( inline_constructor => 0 );
