package DDGC::DB::Result::User::Notification;

use DBIx::Class::Candy -components => [ 'TimeStamp', 'InflateColumn::DateTime', 'InflateColumn::Serializer', 'EncodedColumn' ];

table 'user_notification';

column id => {
	data_type => 'bigint',
	is_auto_increment => 1,
};
primary_key 'id';

column users_id => {
	data_type => 'bigint',
	is_nullable => 0,
};

# Context	ContextID	SubContext	Target
#-------------------------------------------------
# Y			X			Z			Changed/New Z on Y #X
# Y			X						Changes on Y #X
# Y									Changes on any Y or Changed/New Y
# Y						Z			New Z on any Y

column context => {
	data_type => 'text',
	is_nullable => 0,
};

column context_id => {
	data_type => 'bigint',
	is_nullable => 1,
};

column sub_context => {
	data_type => 'text',
	is_nullable => 1,
};

column cycle => {
	data_type => 'int',
	is_nullable => 0,
};

column last_check => {
	data_type => 'timestamp with time zone',
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

###############################

use overload '""' => sub {
	my $self = shift;
	return 'User-Notification #'.$self->id;
}, fallback => 1;

1;
