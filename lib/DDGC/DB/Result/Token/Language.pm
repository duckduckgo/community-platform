package DDGC::DB::Result::Token::Language;

use DBIx::Class::Candy -components => [ 'TimeStamp', 'InflateColumn::DateTime', 'InflateColumn::Serializer', 'SingletonRows', 'EncodedColumn' ];

table 'token_language';

column id => {
	data_type => 'bigint',
	is_auto_increment => 1,
};
primary_key 'id';

column token_id => {
	data_type => 'bigint',
	is_nullable => 0,
};

column token_domain_language_id => { 
	data_type => 'bigint',
	is_nullable => 0,
};

column notes => {
	data_type => 'text',
	is_nullable => 1,
};

column translation => {
	data_type => 'text',
	is_nullable => 1,
};

column translation_data => {
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

belongs_to 'token', 'DDGC::DB::Result::Token', 'token_id';
belongs_to 'token_domain_language', 'DDGC::DB::Result::Token::Domain::Language', 'token_domain_language_id';

has_many 'token_language_translations', 'DDGC::DB::Result::Token::Language::Translation', 'token_language_id';

unique_constraint [qw/ token_id token_domain_language_id /];

sub gettext_snippet {
	my ( $self, $fallback ) = @_;
	my $str = $self->translation;
	return unless $str || $fallback;
	my $id = $self->token->name;
	$str = $id unless $str;
	return << "EOF";

msgid "$id"
msgstr "$str"
EOF
}

sub auto_use {
	my ( $self ) = @_;
	my @translations = $self->search_related('token_language_translations',{},{
		order_by => 'me.updated',
		prefetch => { user => 'user_languages' },
	})->all;
	my %first;
	my %grade;
	for (@translations) {
		$first{$_->translation} = $_ unless defined $first{$_->translation};
		my $translation_grade = $_->user->search_related('user_languages',{
			language_id => $self->token_domain_language->language->id,
		})->first->grade;
		my $best_grade = defined $grade{$_->translation} ? $grade{$_->translation} : 0;
		$grade{$_->translation} = $translation_grade if $translation_grade > $best_grade;
	}
	my $best;
	for (keys %first) {
		if ($best) {
			$best = $first{$_} if $grade{$_} > $grade{$best->translation}
		} else {
			$best = $first{$_};
		}
	}
	if ($best) {
		$self->translation($best->translation);
		$self->translation_data($best->data);
		return $self->update;
	}
}

sub used_translation { shift->translation }

sub translations {
	my ( $self, $user, $not ) = @_;
	return $self->search_related('token_language_translations',{
		username => { '!=' => $user->username },
	})->first if $not;
	return $self->search_related('token_language_translations',{
		username => $user->username,
	})->first if $user;
	$self->search_related('token_language_translations',{},{
		group_by => ['translation'],
	})->all;
}

use overload '""' => sub {
	my $self = shift;
	return 'Token-Language #'.$self->id;
}, fallback => 1;

1;
