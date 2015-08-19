package DDGC::DB::Result::Screenshot::Token;
# ABSTRACT: A screenshot on a token

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use DateTime::Format::RSS;
use namespace::autoclean;

table 'screenshot_token';

sub u { shift->token->u(@_) }

column id => {
  data_type => 'bigint',
  is_auto_increment => 1,
};
primary_key 'id';

column token_id => {
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

belongs_to 'token', 'DDGC::DB::Result::Token', 'token_id';
belongs_to 'screenshot', 'DDGC::DB::Result::Screenshot', 'screenshot_id';

###############################

no Moose;
__PACKAGE__->meta->make_immutable ( inline_constructor => 0 );
