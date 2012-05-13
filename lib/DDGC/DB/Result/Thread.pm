package DDGC::DB::Result::Thread;
# ABSTRACT: Dukgo.com Forum thread

use DBIx::Class::Candy -components => [ 'TimeStamp', 'InflateColumn::DateTime', 'InflateColumn::Serializer', 'EncodedColumn' ];

table 'post';

column id => {
	data_type => 'bigint',
	is_auto_increment => 1,
};
primary_key 'id';

column title => {
    data_type => 'text',
    is_nullable => 0,
};

column text => {
    data_typy => 'text',
    is_nullable => 0,
};

column users_id => {
	data_type => 'bigint',
	is_nullable => 0,
};

column category => {
    data_type => 'text',
    is_nullable => 0,
};

belongs_to 'user', 'DDGC::DB::Result::User', 'users_id';

use overload '""' => sub {
	my $self = shift;
	return $self->title;
}, fallback => 1;

1;

