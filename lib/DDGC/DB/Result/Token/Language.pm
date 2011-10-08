package DDGC::DB::Result::Token::Language;

use DBIx::Class::Candy -components => [ 'TimeStamp', 'InflateColumn::DateTime', 'InflateColumn::Serializer', 'SingletonRows', 'EncodedColumn' ];

table 'token_language';

column id => {
	data_type => 'bigint',
	is_auto_increment => 1,
};
primary_key 'id';

column token_id => {
	data_type => 'bigint',
	is_nullable => 0,
};

column token_context_language_id => { 
	data_type => 'bigint',
	is_nullable => 0,
};

column notes => {
	data_type => 'text',
	is_nullable => 1,
};

column translation => {
	data_type => 'text',
	is_nullable => 1,
};

column translation_data => {
	data_type => 'text',
	is_nullable => 1,
	serializer_class => 'YAML',
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
belongs_to 'token_context_language', 'DDGC::DB::Result::Token::Context::Language', 'token_context_language_id';

has_many 'token_language_translations', 'DDGC::DB::Result::Token::Language::Translation', 'token_language_id';

unique_constraint [qw/ token_id token_context_language_id /];

sub used_translation {
	my ( $self ) = @_;
	return $self->search_related('token_language_translations',{
		used => 1,
	})->first;
}

sub translations {
	my ( $self, $user, $not ) = @_;
	return $self->search_related('token_language_translations',{
		username => { '!=' => $user->username },
	})->first if $not;
	return $self->search_related('token_language_translations',{
		username => $user->username,
	})->first if $user;
	$self->search_related('token_language_translations',{},{
		group_by => ['translation'],
	})->all;
}

use overload '""' => sub {
	my $self = shift;
	return 'Token-Language #'.$self->id;
}, fallback => 1;

1;
