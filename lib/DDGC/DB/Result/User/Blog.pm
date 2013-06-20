package DDGC::DB::Result::User::Blog;

use Moose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'user_blog';

column id => {
	data_type => 'bigint',
	is_auto_increment => 1,
};
primary_key 'id';

column users_id => {
	data_type => 'bigint',
	is_nullable => 0,
};

column translation_of_id => {
	data_type => 'bigint',
	is_nullable => 1,
};

column title => {
	data_type => 'text',
	is_nullable => 0,
};

column uri => {
	data_type => 'text',
	is_nullable => 0,
};

column teaser => {
	data_type => 'text',
	is_nullable => 0,
};

column content => {
	data_type => 'text',
	is_nullable => 0,
};

column topics => {
	data_type => 'text',
	is_nullable => 1,
};

column company_blog => {
	data_type => 'int',
	is_nullable => 0,
	default_value => 0,
};

column raw_html => {
	data_type => 'int',
	is_nullable => 0,
	default_value => 0,
};

column language_id => {
	data_type => 'bigint',
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

belongs_to 'user', 'DDGC::DB::Result::User', 'users_id';
belongs_to 'language', 'DDGC::DB::Result::Language', 'language_id', { join_type => 'left' };
belongs_to 'translation_of', 'DDGC::DB::Result::User::Blog', 'translation_of_id', { join_type => 'left' };

###############################

sub html {
	my ( $self ) = @_;
	return $self->content if $self->raw_html;
	return $self->result_source->schema->ddgc->markup->html($self->content);
}

sub human_duration_updated {
	my ( $self ) = @_;
	my $result = DateTime::Format::Human::Duration->new
		->format_duration(DateTime->now - $self->updated);
	return (split /,/, $result)[0];
}

no Moose;
__PACKAGE__->meta->make_immutable;
