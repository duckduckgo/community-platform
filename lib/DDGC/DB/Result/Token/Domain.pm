package DDGC::DB::Result::Token::Domain;

use DBIx::Class::Candy -components => [ 'TimeStamp', 'InflateColumn::DateTime', 'InflateColumn::Serializer', 'EncodedColumn' ];

use Moose;
use Path::Class;

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

column sorting => {
	data_type => 'int',
	is_nullable => 0,
	default_value => 0,
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

has _name_parts => (
	is => 'ro',
	lazy_build => 1,
);

sub _build__name_parts {
	my ( $self ) = @_;
	my @parts = qw( DDGC Locale );
	my $key = $self->key;
	push @parts, join('',map { ucfirst($_) } split('-',$key));
	return \@parts;
}

has dist_name => (
	is => 'ro',
	lazy_build => 1,
);

sub _build_dist_name {
	my ( $self ) = @_;
	return join('-',@{$self->_name_parts});
}

has lib_name => (
	is => 'ro',
	lazy_build => 1,
);

sub _build_lib_name {
	my ( $self ) = @_;
	return join('::',@{$self->_name_parts});
}

sub comments {
	my ( $self, $page, $pagesize ) = @_;
	$self->result_source->schema->resultset('Comment')->search({
		context => 'DDGC::DB::Result::Token::Language',
		context_id => { -in => $self->token_domain_languages->search_related('token_languages')->get_column('id')->as_query },
	},{
		order_by => { -desc => 'me.updated' },
		( ( defined $page and defined $pagesize ) ? (
			page => $page,
			rows => $pagesize,
		) : () ),
		prefetch => 'user',
	});
}

sub token_domain_languages_locale_sorted {
	my ( $self ) = @_;
	$self->token_domain_languages->search({},{
		order_by => 'language.locale',
		prefetch => 'language',
	});
}

sub generate_pos {
	my ( $self, $dir, $generator, $fallback ) = @_;
	for my $tcl ($self->token_domain_languages->all) {
		my $locale = $tcl->language->locale;
		my $basedir = dir($dir,$locale,'LC_MESSAGES');
		$basedir->mkpath(0,0755);
		$tcl->generate_po_for_locale_in_dir_as_with_fallback($basedir, $generator, $fallback);
	}
}

sub analyze_tokens {
	my ( $self, @tokens ) = @_;
	use DDP; p(@tokens);
}

sub migrate_tokens {
	my ( $self, @tokens ) = @_;
	use DDP; p(@tokens);
}

use overload '""' => sub {
	my $self = shift;
	return 'Token-Domain '.$self->name.' #'.$self->id;
}, fallback => 1;

sub u { 'Translate', 'domainindex', shift->key }

1;
