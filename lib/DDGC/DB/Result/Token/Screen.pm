package DDGC::DB::Result::Token::Screen;
# ABSTRACT: TODO Screenshot of the token in the webpage

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'token_screen';

column id => {
	data_type => 'bigint',
	is_auto_increment => 1,
};
primary_key 'id';

column token_id => {
	data_type => 'bigint',
	is_nullable => 1,
};

column screen_id => { 
	data_type => 'bigint',
	is_nullable => 1,
};

column tag_x => {
	data_type => 'int',
	is_nullable => 1,
};

column tag_y => {
	data_type => 'int',
	is_nullable => 1,
};

column created => {
	data_type => 'timestamp with time zone',
	set_on_create => 1,
};

column updated => {
	data_type => 'timestamp with time zone',
	set_on_create => 1,
	set_on_update => 1,
};

belongs_to 'token', 'DDGC::DB::Result::Token', 'token_id';
belongs_to 'screen', 'DDGC::DB::Result::Screen', 'screen_id';

no Moose;
__PACKAGE__->meta->make_immutable;
