package DDGC::DB::Result::Token::Domain::Language;

use DBIx::Class::Candy -components => [ 'TimeStamp', 'InflateColumn::DateTime', 'InflateColumn::Serializer', 'EncodedColumn' ];

table 'token_domain_language';

column id => {
	data_type => 'bigint',
	is_auto_increment => 1,
};
primary_key 'id';

column language_id => {
	data_type => 'bigint',
	is_nullable => 0,
};

column token_domain_id => {
	data_type => 'bigint',
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

belongs_to 'token_domain', 'DDGC::DB::Result::Token::Domain', 'token_domain_id';
belongs_to 'language', 'DDGC::DB::Result::Language', 'language_id';

has_many 'token_languages', 'DDGC::DB::Result::Token::Language', 'token_domain_language_id';

sub insert {
	my $self = shift;
	my $guard = $self->result_source->schema->txn_scope_guard;
	$self->next::method(@_);
	for ($self->token_domain->tokens->all) {
		$self->create_related('token_languages',{
			token_id => $_->id,
		});
	}
	$guard->commit;
	return $self;
}

use overload '""' => sub {
	my $self = shift;
	return 'Token-Domain-Language #'.$self->id;
}, fallback => 1;

1;
