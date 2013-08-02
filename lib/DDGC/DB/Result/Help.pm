package DDGC::DB::Result::Help;
# ABSTRACT: Help information system

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'help';

column id => {
	data_type => 'bigint',
	is_auto_increment => 1,
};
primary_key 'id';

unique_column key => {
	data_type => 'text',
	is_nullable => 0,
};

column help_category_id => {
	data_type => 'text',
	is_nullable => 0,
};

belongs_to 'help_category', 'DDGC::DB::Result::Help::Category', 'help_category_id';
sub cateogry { shift->help_category(@_) }

column data => {
	data_type => 'text',
	is_nullable => 1,
	serializer_class => 'JSON',
};

column notes => {
	data_type => 'text',
	is_nullable => 1,
};

column sort => {
  data_type => 'int',
  is_nullable => 0,
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

has_many 'help_contents', 'DDGC::DB::Result::Help::Content', 'help_id';

sub content_by_language_id {
	my ( $self, $language_id ) = @_;
	$self->search_related('help_contents',{
		language_id => $language_id
	})->first;
}

no Moose;
__PACKAGE__->meta->make_immutable;
