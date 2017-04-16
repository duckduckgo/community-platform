package DDGC::DB::Result::Thread::Suggest;
# ABSTRACT: Fulltext search view for topic suggestions

use Moose;
use MooseX::NonMoose;
extends 'DBIx::Class::Core';
use namespace::autoclean;

__PACKAGE__->table_class('DBIx::Class::ResultSource::View');

__PACKAGE__->table('thread_suggest');

__PACKAGE__->result_source_instance->is_virtual(1);
__PACKAGE__->result_source_instance->view_definition(q{
  SELECT id, title, key, content
  FROM   ( SELECT thread.id as id, thread.title as title, thread.key as key, comment.content as content,
                setweight(to_tsvector('english', title), 'A') ||
                setweight(to_tsvector('english', content), 'B') as document
           FROM   thread
           JOIN   comment on comment.id = thread.comment_id
         ) search
  WHERE  search.document @@ to_tsquery( ? )
  ORDER BY ts_rank(search.document, to_tsquery( ? ))
  DESC
  LIMIT 5
});

__PACKAGE__->add_columns(
  id => {
    data_type => 'bigint',
  },
  title => {
    data_type => 'text',
  },
  content => {
    data_type => 'text',
  },
  key => {
    data_type => 'text',
  }
);

no Moose;
__PACKAGE__->meta->make_immutable;

