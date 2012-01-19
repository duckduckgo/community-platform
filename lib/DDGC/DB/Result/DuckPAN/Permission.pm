package DDGC::DB::Result::DuckPAN::Permission;

use DBIx::Class::Candy -components => [ 'TimeStamp', 'InflateColumn::DateTime', 'InflateColumn::Serializer', 'EncodedColumn' ];

table 'duckpan_permission';

column id => {
	data_type => 'bigint',
	is_auto_increment => 1,
};
primary_key 'id';

column namespace => {
	data_type => 'text',
	is_nullable => 0,
};

column users_id => {
	data_type => 'bigint',
	is_nullable => 0,
};

# 1 Admin / Maintainer
# 2 Co-Maintainer
column permission => {
	data_type => 'int',
	is_nullable => 0,
	default_value => 1,
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

unique_constraint [qw/ namespace users_id /];

use overload '""' => sub {
	my $self = shift;
	return 'DuckPAN-Permission #'.$self->id;
}, fallback => 1;

1;
