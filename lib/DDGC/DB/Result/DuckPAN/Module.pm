package DDGC::DB::Result::DuckPAN::Module;
# ABSTRACT: Modules of releases made on DuckPAN

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'duckpan_module';

column id => {
  data_type => 'bigint',
  is_auto_increment => 1,
};
primary_key 'id';

unique_column name => {
  data_type => 'text',
  is_nullable => 0,
};

column duckpan_release_id => {
  data_type => 'bigint',
  is_nullable => 0,
};

column filename => {
  data_type => 'text',
  is_nullable => 1,
};

column filename_pod => {
  data_type => 'text',
  is_nullable => 1,
};

column duckpan_meta => {
  data_type => 'text',
  is_nullable => 0,
  serializer_class => 'JSON',
  default_value => '{}',
};

column created => {
  data_type => 'timestamp with time zone',
  set_on_create => 1,
};

column updated => {
  data_type => 'timestamp with time zone',
  set_on_create => 1,
  set_on_update => 1,
};

belongs_to 'duckpan_release', 'DDGC::DB::Result::DuckPAN::Release', 'duckpan_release_id', {
  on_delete => 'cascade',
  on_update => 'cascade',
};

no Moose;
__PACKAGE__->meta->make_immutable;
