package DDGC::DB::Result::Comment::Context;

use Moose;
use MooseX::NonMoose;
extends 'DBIx::Class::Core';
use namespace::autoclean;

__PACKAGE__->table_class('DBIx::Class::ResultSource::View');

__PACKAGE__->table('comment_context');

__PACKAGE__->result_source_instance->is_virtual(1);
__PACKAGE__->result_source_instance->view_definition(q{
  SELECT
    (latest).id AS latest_comment_id,
    (first).id AS first_comment_id,
    (first).context AS comments_context,
    (first).context_id AS comments_context_id
  FROM (
    SELECT (
      SELECT latest 
      FROM comment latest
      WHERE latest.context = c.context AND latest.context_id = c.context_id
      ORDER BY
        created DESC
      LIMIT 1
    ) AS latest, (
      SELECT first 
      FROM comment first
      WHERE first.context = c.context AND first.context_id = c.context_id
      ORDER BY
        created ASC
      LIMIT 1
    ) AS first
    FROM comment c
    GROUP BY
      context, context_id
  ) latest_comment
});

__PACKAGE__->add_columns(
  latest_comment_id => {
    data_type => 'bigint',
    is_auto_increment => 1,
  },
  first_comment_id => {
    data_type => 'bigint',
    is_auto_increment => 1,
  },
  comments_context => {
    data_type => 'text',
    is_nullable => 0,
  },
  comments_context_id => {
    data_type => 'bigint',
    is_nullable => 0,
  }
);

no Moose;
__PACKAGE__->meta->make_immutable;
