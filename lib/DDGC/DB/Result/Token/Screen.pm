package DDGC::DB::Result::Token::Screen;

use DBIx::Class::Candy -components => [ 'TimeStamp', 'InflateColumn::DateTime', 'InflateColumn::Serializer', 'SingletonRows', 'EncodedColumn' ];

table 'token_screen';

column id => {
	data_type => 'bigint',
	is_auto_increment => 1,
};
primary_key 'id';

column token_id => {
	data_type => 'bigint',
	is_nullable => 1,
};

column screen_id => { 
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

belongs_to 'token', 'DDGC::DB::Result::Token', 'token_id';
belongs_to 'screen', 'DDGC::DB::Result::Screen', 'screen_id';

use overload '""' => sub {
	my $self = shift;
	return 'Token-Screen #'.$self->id;
}, fallback => 1;

1;
