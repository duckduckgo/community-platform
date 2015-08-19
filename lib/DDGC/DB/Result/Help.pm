package DDGC::DB::Result::Help;
# ABSTRACT: Help information system

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'help';

sub u { ['Help', 'help', $_[0]->category->key, $_[0]->key] }

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
	data_type => 'bigint',
	is_nullable => 1,
};

belongs_to 'help_category', 'DDGC::DB::Result::Help::Category', 'help_category_id', { join_type => 'left' };;
sub category { shift->help_category(@_) }

column data => {
	data_type => 'text',
	is_nullable => 1,
	serializer_class => 'JSON',
};

column notes => {
	data_type => 'text',
	is_nullable => 1,
};

column old_url => {
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

has_many 'help_relate_ons', 'DDGC::DB::Result::Help::Relate', 'on_help_id';
has_many 'help_relate_shows', 'DDGC::DB::Result::Help::Relate', 'show_help_id';

after insert => sub {
  my ( $self ) = @_;
  $self->add_event('create');
};

after update => sub {
  my ( $self ) = @_;
  $self->add_event('update');
};

sub related_helps {
	my ( $self ) = @_;
	$self->help_relate_ons_rs->search_related('show_help',{});
}

sub content_by_language_id {
	my ( $self, $language_id ) = @_;
	$self->search_related('help_contents',{
		language_id => $language_id
	})->first;
}

sub content_by_language_id_cached {
	my ( $self, $language_id ) = @_;
	$self->search_related('help_contents',{
		language_id => $language_id
	},{
		cache_for => 600
	})->first;
}

no Moose;
__PACKAGE__->meta->make_immutable ( inline_constructor => 0 );
