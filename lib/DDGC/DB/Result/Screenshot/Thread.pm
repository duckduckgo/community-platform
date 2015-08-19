package DDGC::DB::Result::Screenshot::Thread;
# ABSTRACT: A screenshot on a thread

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use DateTime::Format::RSS;
use namespace::autoclean;

table 'screenshot_thread';

sub u { shift->thread->u(@_) }

column id => {
  data_type => 'bigint',
  is_auto_increment => 1,
};
primary_key 'id';

column thread_id => {
  data_type => 'bigint',
  is_nullable => 0,
};

column screenshot_id => {
  data_type => 'bigint',
  is_nullable => 0,
};

column created => {
  data_type => 'timestamp with time zone',
  set_on_create => 1,
};

unique_constraint [qw/ thread_id screenshot_id /];

belongs_to 'thread', 'DDGC::DB::Result::Thread', 'thread_id', {
  on_delete => 'cascade',
};

belongs_to 'screenshot', 'DDGC::DB::Result::Screenshot', 'screenshot_id', {
  on_delete => 'cascade',
};

###############################

no Moose;
__PACKAGE__->meta->make_immutable ( inline_constructor => 0 );
