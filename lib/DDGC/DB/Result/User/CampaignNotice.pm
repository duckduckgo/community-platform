package DDGC::DB::Result::User::CampaignNotice;
# ABSTRACT: Which user has seen which 'Special Announcement'

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'user_campaign_notice';

column users_id => {
  data_type => 'bigint',
  is_nullable => 0,
};

column thread_id => {
  data_type => 'bigint',
  is_nullable => 0,
};

primary_key ( qw/users_id thread_id/ );

belongs_to 'notice_user', 'DDGC::DB::Result::User', 'users_id', {
  on_delete => 'no action',
};

belongs_to 'notice_thread', 'DDGC::DB::Result::Thread', 'thread_id', {
  on_delete => 'no action',
};

no Moose;
__PACKAGE__->meta->make_immutable;

1;

