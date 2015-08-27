package DDGC::DB::Result::Token::Domain::Token;
# ABSTRACT: new concept for linking tokens to token domain

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use DateTime::Format::RSS;
use namespace::autoclean;

table 'token_domain_token';

column id => {
  data_type => 'bigint',
  is_auto_increment => 1,
};
primary_key 'id';

column token_domain_id => {
  data_type => 'bigint',
  is_nullable => 0,
};

column token_id => {
  data_type => 'bigint',
  is_nullable => 0,
};

column created => {
  data_type => 'timestamp with time zone',
  set_on_create => 1,
};

belongs_to 'token_domain', 'DDGC::DB::Result::Token::Domain', 'token_domain_id';
belongs_to 'token', 'DDGC::DB::Result::Screenshot', 'token_id';

###############################

no Moose;
__PACKAGE__->meta->make_immutable ( inline_constructor => 0 );
