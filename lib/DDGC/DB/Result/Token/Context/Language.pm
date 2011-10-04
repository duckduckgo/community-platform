package DDGC::DB::Result::Token::Context::Language;

use DBIx::Class::Candy -components => [ 'TimeStamp', 'InflateColumn::DateTime', 'InflateColumn::Serializer', 'SingletonRows', 'EncodedColumn' ];

table 'token_context_language';

column id => {
	data_type => 'bigint',
	is_auto_increment => 1,
};
primary_key 'id';

column language_id => {
	data_type => 'bigint',
	is_nullable => 0,
};

column token_context_id => {
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

belongs_to 'token_context', 'DDGC::DB::Result::Token::Context', 'token_context_id';
belongs_to 'language', 'DDGC::DB::Result::Language', 'language_id';

use overload '""' => sub {
	my $self = shift;
	return 'Token-Context-Language #'.$self->id;
}, fallback => 1;

1;
