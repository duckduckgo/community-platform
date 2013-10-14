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

unique_column key => {
  data_type => 'text',
  is_nullable => 0,
};

column type => {
  data_type => 'text',
  is_nullable => 1,
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

###############################

no Moose;
__PACKAGE__->meta->make_immutable;
