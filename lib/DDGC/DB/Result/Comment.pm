package DDGC::DB::Result::Comment;

use DBIx::Class::Candy -components => [ 'TimeStamp', 'InflateColumn::DateTime', 'InflateColumn::Serializer', 'EncodedColumn' ];

table 'comment';

column id => {
	data_type => 'bigint',
	is_auto_increment => 1,
};
primary_key 'id';

column users_id => {
	data_type => 'bigint',
	is_nullable => 1,
};

column context => {
	data_type => 'text',
	is_nullable => 0,
};

column context_id => {
	data_type => 'bigint',
	is_nullable => 0,
};

column content => {
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

column parent_id => {
	data_type => 'bigint',
	is_nullable => 1,
};

belongs_to 'user', 'DDGC::DB::Result::User', 'users_id', { join_type => 'left' };
belongs_to 'parent', 'DDGC::DB::Result::Comment', 'parent_id', { join_type => 'left' };
has_many 'children', 'DDGC::DB::Result::Comment', 'parent_id';

sub notification_key {
	my ( $self ) = @_;
	return join('|',$self->context,$self->context_id);
}

sub get_context_obj {
	my ( $self ) = @_;
	if ( $self->context =~ m/^DDGC::DB::Result::(.*)$/ ) {
		return $self->result_source->schema->resultset($1)->find($self->context_id);
	}
	die "dont know how to get object of ".$self->context;
}

###############################

use overload '""' => sub {
	my $self = shift;
	return 'Comment #'.$self->id;
}, fallback => 1;

1;
