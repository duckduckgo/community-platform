package DDGC::DB::Result::Token;

use DBIx::Class::Candy -components => [ 'TimeStamp', 'InflateColumn::DateTime', 'InflateColumn::Serializer', 'EncodedColumn' ];

table 'token';

column id => {
	data_type => 'bigint',
	is_auto_increment => 1,
};
primary_key 'id';

column msgid => {
	data_type => 'text',
	is_nullable => 0,
};

column msgid_plural => {
	data_type => 'text',
	is_nullable => 1,
};

column msgctxt => {
	data_type => 'text',
	is_nullable => 1,
};

#
# Token Type
#
# 0: not listed
# 1: snippet
# 2: free text (no plural forms, may include HTML)
# 3: image (no plural forms)
#
column type => {
	data_type => 'tinyint',
	is_nullable => 0,
	default_value => 1,
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

column token_domain_id => {
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

belongs_to 'token_domain', 'DDGC::DB::Result::Token::Domain', 'token_domain_id';

has_many 'token_screens', 'DDGC::DB::Result::Token::Screen', 'token_id';
has_many 'token_languages', 'DDGC::DB::Result::Token::Language', 'token_id';

sub insert {
	my $self = shift;
	my $guard = $self->result_source->schema->txn_scope_guard;
	$self->next::method(@_);
	for ($self->token_domain->token_domain_languages->all) {
		$self->create_related('token_languages',{
			token_domain_language_id => $_->id,
		});
	}
	$guard->commit;
	return $self;
}

use overload '""' => sub {
	my $self = shift;
	return 'Token #'.$self->id;
}, fallback => 1;

1;
