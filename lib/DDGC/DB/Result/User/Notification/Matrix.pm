package DDGC::DB::Result::User::Notification::Matrix;
# ABSTRACT:

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

__PACKAGE__->table_class('DBIx::Class::ResultSource::View');

table('user_notification_matrix');

__PACKAGE__->result_source_instance->is_virtual(1);
__PACKAGE__->result_source_instance->view_definition(q{

SELECT
  "me"."id"                                       AS "id",
  "me"."id"                                       AS "user_notification_id",
  "me"."users_id"                                 AS "users_id",
  "user_notification_group"."id"                  AS "user_notification_group_id",
  "user_notification_group"."context"             AS "context",
  "me"."context_id"                               AS "context_id",
  "me"."cycle"                                    AS "cycle",
  "me"."xmpp"                                     AS "xmpp",
  "me"."cycle_time"                               AS "cycle_time",
  "me"."created"                                  AS "created",
  "user_notification_group"."type"                AS "type",
  "user_notification_group"."group_context"       AS "group_context",
  "user_notification_group"."sub_context"         AS "sub_context",
  "user_notification_group"."action"              AS "action",
  "user_notification_group"."priority"            AS "priority",
  "user_notification_group"."filter_by_language"  AS "filter_by_language"
FROM "user_notification" "me"
JOIN "user_notification_group" "user_notification_group"
  ON "user_notification_group"."id" = "me"."user_notification_group_id"

});

column id => {
  data_type => 'bigint',
  is_nullable => 0,
};
primary_key 'id';

column user_notification_id => {
  data_type => 'bigint',
  is_nullable => 0,
};

column users_id => {
  data_type => 'bigint',
  is_nullable => 0,
};

column user_notification_group_id => {
  data_type => 'bigint',
  is_nullable => 0,
};

__PACKAGE__->add_context_relations;

column cycle => {
  data_type => 'int',
  is_nullable => 0,
};

column xmpp => {
  data_type => 'int',
  default_value => 0,
};

column cycle_time => {
  data_type => 'timestamp with time zone',
  is_nullable => 1,
};

column created => {
  data_type => 'timestamp with time zone',
  is_nullable => 0,
};

column type => {
  data_type => 'text',
  is_nullable => 0,
};

column group_context => {
  data_type => 'text',
  is_nullable => 1,
};

column sub_context => {
  data_type => 'text',
  is_nullable => 0,
};

column action => {
  data_type => 'text',
  is_nullable => 0,
};

column priority => {
  data_type => 'int',
  is_nullable => 0,
};

column filter_by_language => {
  data_type => 'int',
  is_nullable => 0,
};

belongs_to 'user', 'DDGC::DB::Result::User', 'users_id', {
  on_delete => 'no action',
  on_update => 'no action',
};
has_many 'event_notifications', 'DDGC::DB::Result::Event::Notification', 'user_notification_id', {
  cascade_delete => 0,
};
has_many 'event_notification_groups', 'DDGC::DB::Result::Event::Notification::Group', 'user_notification_group_id', {
  cascade_delete => 0,
};

no Moose;
__PACKAGE__->meta->make_immutable ( inline_constructor => 0 );
