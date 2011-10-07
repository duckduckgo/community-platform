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

column data => {
	data_type => 'text',
	is_nullable => 1,
	serializer_class => 'YAML',
};

column notes => {
	data_type => 'text',
	is_nullable => 1,
};

column used => {
	data_type => 'tinyint',
	is_nullable => 0,
	default_value => 0,
};

column token_language_id => {
	data_type => 'bigint',
	is_nullable => 0,
};

# TODO
# column takenfrom_token_language_translation_id => {
	# data_type => 'bigint',
	# is_nullable => 1,
# };

# column users_id => {
	# data_type => 'bigint',
	# is_nullable => 0,
# };

column username => {
	data_type => 'text',
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

unique_constraint [qw/ token_language_id username /];

#belongs_to 'user', 'DDGC::DB::Result::User', 'users_id';
belongs_to 'user', 'DDGC::DB::Result::User', { 'foreign.username' => 'self.username' };
belongs_to 'token_language', 'DDGC::DB::Result::Token::Language', 'token_language_id';

# TODO
#belongs_to 'takenfrom', 'DDGC::DB::Result::Token::Language::Translation', 'takenfrom_token_language_translation_id';

use overload '""' => sub {
	my $self = shift;
	return 'Token-Language-Translation #'.$self->id;
}, fallback => 1;

1;
