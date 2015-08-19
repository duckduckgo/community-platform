package DDGC::DB::Result::User::Coupon;
# ABSTRACT: Discount coupons

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'user_coupon';

column coupon => {
  data_type => 'text',
  is_nullable => 0,
};

column campaign_id => {
  data_type => 'bigint',
  is_nullable => 0,
};

column users_id => {
  data_type => 'bigint',
  is_nullable => 1,
};

primary_key ( qw/coupon/ );

no Moose;
__PACKAGE__->meta->make_immutable ( inline_constructor => 0 );

1;

