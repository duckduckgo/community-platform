package DDGC::DB::Result::User::CampaignNotice;
# ABSTRACT: Which user has seen which Special Announcement / Campaign

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

column campaign_id => {
  data_type => 'bigint',
  is_nullable => 0,
};

column campaign_source => {
  data_type => 'text',
  is_nullable => 0,
};

column responded => {
  data_type => 'timestamp',
  is_nullable => 1,
};

column bad_response => {
  data_type => 'tinyint',
  is_nullable => 0,
  default_value => 0,
};

primary_key ( qw/users_id campaign_id campaign_source/ );

belongs_to 'notice_user', 'DDGC::DB::Result::User', 'users_id', {
  on_delete => 'no action',
};

no Moose;
__PACKAGE__->meta->make_immutable;

1;

