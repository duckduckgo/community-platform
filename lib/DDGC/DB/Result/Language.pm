package DDGC::DB::Result::Language;

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'language';

# sub description_list { "The language", "'".shift->name_in_english."'", "." }
# sub sub_description_list { "the language", "'".shift->name_in_english."'" }

column id => {
	data_type => 'bigint',
	is_auto_increment => 1,
};
primary_key 'id';

#
# gettext information page about locale definition
# http://www.gnu.org/s/hello/manual/gettext/Locale-Names.html
#

# German in Germany
unique_column name_in_english => {
	data_type => 'text',
	is_nullable => 0,
};

# Deutsch in Deutschland
column name_in_local => {
	data_type => 'text',
	is_nullable => 0,
};

# Deutsch
column lang_in_local => {
	data_type => 'text',
	is_nullable => 1,
};

# de_DE
unique_column locale => {
	data_type => 'text',
	is_nullable => 0,
};

column flagicon => {
	data_type => 'text',
	is_nullable => 1,
};
sub flag_url { 'https://duckduckgo.com/f2/'.(shift->flagicon).'.png' }

column nplurals => {
	data_type => 'tinyint',
	is_nullable => 0,
	default_value => 2,
};
sub nplurals_index { shift->nplurals - 1 }

column plural => {
	data_type => 'text',
	is_nullable => 0,
	default_value => 'n != 1',
};

# find them all: http://translate.sourceforge.net/wiki/l10n/pluralforms
sub plural_forms {
	my ( $self ) = @_;
	return 'nplurals=1; plural=0' if ($self->nplurals == 1);
	'nplurals='.($self->nplurals).'; plural='.($self->plural).';';
}

column rtl => {
	data_type => 'tinyint',
	is_nullable => 0,
	default_value => 0,
};
sub ltr { shift->rtl ? 0 : 1 }

column data => {
	data_type => 'text',
	is_nullable => 1,
	serializer_class => 'YAML',
};

column notes => {
	data_type => 'text',
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

has_many 'user_languages', 'DDGC::DB::Result::User::Language', 'language_id';
has_many 'user_blogs', 'DDGC::DB::Result::User::Blog', 'language_id';
has_many 'token_domains', 'DDGC::DB::Result::Token::Domain', 'source_language_id';
has_many 'token_domain_languages', 'DDGC::DB::Result::Token::Domain::Language', 'language_id';

many_to_many 'users', 'user_languages', 'user';

no Moose;
__PACKAGE__->meta->make_immutable;
