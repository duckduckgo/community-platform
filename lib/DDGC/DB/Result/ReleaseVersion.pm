package DDGC::DB::Result::ReleaseVersion;
# ABSTRACT: Screenshot

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'release_version';

primary_column id => {
  data_type => 'bigserial',
  is_auto_increment => 1,
};

column instant_answer_id => {
  data_type => 'text',
  is_nullable => 0,
};

column release_version => {
  data_type => 'numeric',
  is_nullable => 0,
};

column status => {
  data_type => 'varchar',
  size => 20,
  is_nullable => 0,
};

column updated => {
    data_type => 'timestamp with time zone',
    set_on_create => 1,
    set_on_update => 1,
};

has_one 'permanent_id', 'DDGC::DB::Result::InstantAnswer', 'id';

no Moose;
__PACKAGE__->meta->make_immutable ( inline_constructor => 0 );
