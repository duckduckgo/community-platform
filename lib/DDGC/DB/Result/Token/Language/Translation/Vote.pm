package DDGC::DB::Result::Token::Language::Translation::Vote;
# ABSTRACT: A vote of a user on a translation

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'token_language_translation_vote';

column id => {
	data_type => 'bigint',
	is_auto_increment => 1,
};
primary_key 'id';

column users_id => {
	data_type => 'bigint',
	is_nullable => 0,
};

column token_language_translation_id => {
	data_type => 'bigint',
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

unique_constraint(
	token_language_translation_users => [qw/ token_language_translation_id users_id /]
);

belongs_to 'user', 'DDGC::DB::Result::User', 'users_id';

belongs_to 'token_language_translation', 'DDGC::DB::Result::Token::Language::Translation', 'token_language_translation_id', {
	on_delete => 'cascade',
};

after insert => sub {
	my ( $self ) = @_;
	$self->add_event('create');	
};

sub event_related {
	my ( $self ) = @_;
	my @related = $self->token_language_translation->event_related;
	push @related, ['DDGC::DB::Result::Token::Language::Translation', $self->token_language_translation_id];
	return @related;
}

no Moose;
__PACKAGE__->meta->make_immutable ( inline_constructor => 0 );
