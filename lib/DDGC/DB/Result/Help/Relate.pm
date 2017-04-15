package DDGC::DB::Result::Help::Relate;
# ABSTRACT: Help related informations

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'help_related';

column id => {
  data_type => 'bigint',
  is_auto_increment => 1,
};
primary_key 'id';

column on_help_id => {
  data_type => 'bigint',
  is_nullable => 0,
};

belongs_to 'on_help', 'DDGC::DB::Result::Help', 'on_help_id', {
  on_delete => 'cascade',
};

column show_help_id => {
  data_type => 'bigint',
  is_nullable => 0,
};

#belongs_to 'show_help', 'DDGC::DB::Result::Help', 'show_help_id', {
#  on_delete => 'cascade',
#};

column created => {
  data_type => 'timestamp with time zone',
  set_on_create => 1,
};

no Moose;
__PACKAGE__->meta->make_immutable ( inline_constructor => 0 );
