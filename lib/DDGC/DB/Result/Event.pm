package DDGC::DB::Result::Event;

use DBIx::Class::Candy -components => [ 'TimeStamp', 'InflateColumn::DateTime', 'InflateColumn::Serializer', 'EncodedColumn' ];

table 'event';

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
	is_nullable => 1,
};

column data => {
	data_type => 'text',
	is_nullable => 1,
	serializer_class => 'YAML',
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

belongs_to 'user', 'DDGC::DB::Result::User', 'users_id', { join_type => 'left' };

sub get_context_obj {
	my ( $self ) = @_;
	if ( $self->context =~ m/^DDGC::DB::Result::(.*)$/ ) {
		return $self->result_source->schema->resultset($1)->find($self->context_id);
	}
	return;
}

use overload '""' => sub {
	my $self = shift;
	return 'Event #'.$self->id;
}, fallback => 1;

1;
