package DDGC::DB::Result::Token::Language::Translation;

use DBIx::Class::Candy -components => [ 'TimeStamp', 'InflateColumn::DateTime', 'InflateColumn::Serializer', 'SingletonRows', 'EncodedColumn' ];

table 'token_language_translation';

column id => {
	data_type => 'bigint',
	is_auto_increment => 1,
};
primary_key 'id';

column translation => {
	data_type => 'text',
	is_nullable => 0,
};

column notes => {
	data_type => 'text',
	is_nullable => 1,
};

column token_language_id => {
	data_type => 'bigint',
	is_nullable => 0,
};

column users_id => {
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

belongs_to 'user', 'DDGC::DB::Result::User', 'users_id';
belongs_to 'token_language', 'DDGC::DB::Result::Token::Language', 'token_language_id';

use overload '""' => sub {
	my $self = shift;
	return 'Token-Language-Translation #'.$self->id;
}, fallback => 1;

1;
