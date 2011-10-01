package DDGC::DB::Result::User;

use DBIx::Class::Candy -components => [ 'TimeStamp', 'InflateColumn::DateTime', 'InflateColumn::Serializer', 'SingletonRows', 'EncodedColumn' ];

table 'users';

column id => {
	data_type => 'bigint',
	is_auto_increment => 1,
};
primary_key 'id';

unique_column username => {
	data_type => 'text',
	is_nullable => 0,
};

column public => {
	data_type => 'int',
	is_nullable => 0,
	default_value => 0,
};

column admin => {
	data_type => 'int',
	is_nullable => 0,
	default_value => 0,
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

column created => {
	data_type => 'timestamp with time zone',
	set_on_create => 1,
};

column updated => {
	data_type => 'timestamp with time zone',
	set_on_create => 1,
	set_on_update => 1,
};

has_many 'screens', 'DDGC::DB::Result::Screen', { 'foreign.username' => 'self.username' };
has_many 'token_language_translations', 'DDGC::DB::Result::Token::Language::Translation', { 'foreign.username' => 'self.username' };
has_many 'user_languages', 'DDGC::DB::Result::User::Language', { 'foreign.username' => 'self.username' };

use overload '""' => sub {
	my $self = shift;
	return 'User '.$self->username.' #'.$self->id;
}, fallback => 1;

1;
