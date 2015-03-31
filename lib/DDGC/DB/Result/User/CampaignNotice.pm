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

column campaign_email_is_account_email => {
  data_type => 'bigint',
  is_nullable => 0,
  default_value => 0,
};

column campaign_email => {
  data_type => 'text',
  is_nullable => 1,
};

column campaign_email_verified => {
  data_type => 'tinyint',
  is_nullable => 0,
  default_value => 0,
};

sub get_verified_campaign_email {
  my ( $self ) = @_;

  if ( $self->campaign_email_is_account_email ) {
    return $self->user->email if $self->user->email_verified;
    return '';
  }

  return $self->campaign_email if $self->campaign_email_verified;
  return '';
}

primary_key ( qw/users_id campaign_id campaign_source/ );

belongs_to 'user', 'DDGC::DB::Result::User', 'users_id', {
  on_delete => 'no action',
};

no Moose;
__PACKAGE__->meta->make_immutable;

1;

