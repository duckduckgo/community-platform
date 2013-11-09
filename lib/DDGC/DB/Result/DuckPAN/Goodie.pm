package DDGC::DB::Result::DuckPAN::Goodie;
# ABSTRACT:

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

__PACKAGE__->table_class('DBIx::Class::ResultSource::View');

table('duckpan_goodies');

__PACKAGE__->result_source_instance->is_virtual(1);
__PACKAGE__->result_source_instance->view_definition(q{

SELECT
  "me"."id",
  "me"."name",
  "me"."duckpan_release_id",
  "me"."filename",
  "me"."filename_pod",
  "duckpan_release"."name" || '/' || "me"."filename"
    AS "latest_filename",
  "duckpan_release"."name" AS "duckpan_release_name",
  "duckpan_release"."version" AS "duckpan_release_version",
  "duckpan_release"."current",
  "me"."created",
  "me"."updated"

FROM "duckpan_module" "me"
JOIN "duckpan_release" "duckpan_release"
  ON "duckpan_release"."id" = "me"."duckpan_release_id"

WHERE
  ( "me"."name" LIKE 'DDG::Goodie::%'
    OR "me"."name" LIKE 'DDG::Spice::%'
    OR "me"."name" LIKE 'DDG::Fathead::%'
    OR "me"."name" LIKE 'DDG::Longtail::%' )
  AND "duckpan_release"."current" = '1'
  AND "me"."filename" IS NOT NULL

});

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

column latest_filename => {
  data_type => 'text',
  is_nullable => 1,
};

column duckpan_release_name => {
  data_type => 'text',
  is_nullable => 0,
};

column duckpan_release_version => {
  data_type => 'text',
  is_nullable => 0,
};

column current => {
  data_type => 'int',
  is_nullable => 0,
  default_value => 1,
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

no Moose;
__PACKAGE__->meta->make_immutable;
