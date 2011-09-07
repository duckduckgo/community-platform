package DDGC::DB::Result::Screen;

use DBIx::Class::Candy -components => [ 'TimeStamp', 'InflateColumn::DateTime', 'InflateColumn::Serializer', 'SingletonRows', 'EncodedColumn' ];

table 'screen';

column id => {
	data_type => 'bigint',
	is_auto_increment => 1,
};
primary_key 'id';

column description => {
	data_type => 'text',
	is_nullable => 1,
};

column tags => {
	data_type => 'text',
	is_nullable => 1,
};

column data => {
	data_type => 'text',
	is_nullable => 1,
	serializer_class => 'YAML',
};

column tags => {
	data_type => 'text',
	is_nullable => 1,
};

column deleted => {
	data_type => 'tinyint',
	is_nullable => 0,
	default_value => 0,
};

column users_id => {
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

has_many 'token_screens', 'DDGC::DB::Result::Token::Screen', 'screen_id';

use overload '""' => sub {
	my $self = shift;
	return 'Screen #'.$self->id;
}, fallback => 1;

1;
