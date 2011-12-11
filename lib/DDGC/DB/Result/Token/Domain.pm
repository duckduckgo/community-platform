package DDGC::DB::Result::Token::Domain;

use DBIx::Class::Candy -components => [ 'TimeStamp', 'InflateColumn::DateTime', 'InflateColumn::Serializer', 'EncodedColumn' ];

table 'token_domain';

column id => {
	data_type => 'bigint',
	is_auto_increment => 1,
};
primary_key 'id';

unique_column key => {
	data_type => 'text',
	is_nullable => 0,
};

column name => {
	data_type => 'text',
	is_nullable => 0,
};

column description => {
	data_type => 'text',
	is_nullable => 1,
};

column data => {
	data_type => 'text',
	is_nullable => 1,
	serializer_class => 'YAML',
};

column source_language_id => {
	data_type => 'int',
	is_nullable => 0,
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

has_many 'tokens', 'DDGC::DB::Result::Token', 'token_domain_id';
has_many 'token_domain_languages', 'DDGC::DB::Result::Token::Domain::Language', 'token_domain_id';

belongs_to 'source_language', 'DDGC::DB::Result::Language', 'source_language_id';

many_to_many 'languages', 'token_domain_languages', 'language';

use overload '""' => sub {
	my $self = shift;
	return 'Token-Domain '.$self->name.' #'.$self->id;
}, fallback => 1;

1;
