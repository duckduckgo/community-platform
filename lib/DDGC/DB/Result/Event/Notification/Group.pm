package DDGC::DB::Result::Event::Notification::Group;
# ABSTRACT: A visual group for an event

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'event_notification_group';

column id => {
  data_type => 'bigint',
  is_auto_increment => 1,
};
primary_key 'id';

column user_notification_group_id => {
  data_type => 'bigint',
  is_nullable => 0,
};

column group_context_id => {
  data_type => 'bigint',
  is_nullable => 0,
};

column data => {
  data_type => 'text',
  is_nullable => 0,
  serializer_class => 'JSON',
  default_value => '{}',
};

column created => {
  data_type => 'timestamp with time zone',
  set_on_create => 1,
};

has_many 'event_notifications', 'DDGC::DB::Result::Event::Notification', 'event_notification_group_id';
belongs_to 'user_notification_group', 'DDGC::DB::Result::User::Notification::Group', 'user_notification_group_id';

unique_constraint [qw/ user_notification_group_id group_context_id /];

sub u {}

###############################

no Moose;
__PACKAGE__->meta->make_immutable;
