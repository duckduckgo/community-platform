package DDGC::DB::Result::Token::Language;

use DBIx::Class::Candy -components => [ 'TimeStamp', 'InflateColumn::DateTime', 'InflateColumn::Serializer', 'EncodedColumn' ];

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

column msgstr0 => {
	data_type => 'text',
	is_nullable => 1,
};
sub msgstr { shift->msgstr0(@_) }

column msgstr1 => {
	data_type => 'text',
	is_nullable => 1,
};

column msgstr2 => {
	data_type => 'text',
	is_nullable => 1,
};

column msgstr3 => {
	data_type => 'text',
	is_nullable => 1,
};

column msgstr4 => {
	data_type => 'text',
	is_nullable => 1,
};

column msgstr5 => {
	data_type => 'text',
	is_nullable => 1,
};

sub msgstr_index_max { 5 }

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

belongs_to 'token', 'DDGC::DB::Result::Token', 'token_id';
belongs_to 'token_domain_language', 'DDGC::DB::Result::Token::Domain::Language', 'token_domain_language_id';

has_many 'token_language_translations', 'DDGC::DB::Result::Token::Language::Translation', 'token_language_id';

unique_constraint [qw/ token_id token_domain_language_id /];

sub gettext_snippet {
	my ( $self, $fallback ) = @_;
	my %vars;
	if ($self->token->msgid_plural) {
		for (0..$self->msgstr_index_max) {
			my $func = 'msgstr'.$_;
			my $result = $self->$func;
			$vars{'msgstr['.$_.']'} = $result if $result;
		}
	} else {
		$vars{'msgstr'} = $self->msgstr0 if $self->msgstr0;
	}
	return unless %vars || $fallback;
	$vars{msgid} = $self->token->msgid;
	$vars{msgid_plural} = $self->token->msgid_plural if $self->token->msgid_plural;
	$vars{msgctxt} = $self->token->msgctxt if $self->token->msgctxt;
	#$str = $id unless $str;
	return "\n".$self->gettext_snippet_formatter(%vars);
}

sub gettext_snippet_formatter {
	my ( $self, %vars ) = @_;
	my $return;
	for (qw( msgid msgctxt msgid_plural )) {
		$return .= $_.' "'.(delete $vars{$_}).'"'."\n" if $vars{$_};
	}
	for (sort { $a cmp $b } keys %vars) {
		$return .= $_.' "'.(delete $vars{$_}).'"'."\n";
	}
	return $return;
}

sub set_user_translation {
	my ( $self, $user, $translation ) = @_;
	if ($user->can_speak($self->token_domain_language->language->locale)) {
		$self->update_or_create_related('token_language_translations',{
			%{$translation},
			user => $user->db,
		},{
			key => 'token_language_translation_token_language_id_username',
		});
	} else {
		die "you dont speak the language you are going to translate!";
	}
}

sub set_translation {
	my ( $self, $translation ) = @_;
	for (0..$self->msgstr_index_max) {
		my $func = 'msgstr'.$_;
		$self->$func($translation->$func);
	}
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
		$first{$_->key} = $_ unless defined $first{$_->key};
		my $translation_grade = $_->user->search_related('user_languages',{
			language_id => $self->token_domain_language->language->id,
		})->first->grade;
		my $best_grade = defined $grade{$_->key} ? $grade{$_->key} : 0;
		$grade{$_->key} = $translation_grade if $translation_grade > $best_grade;
	}
	my $best;
	for (keys %first) {
		if ($best) {
			$best = $first{$_} if $grade{$_} > $grade{$best->key}
		} else {
			$best = $first{$_};
		}
	}
	if ($best) {
		$self->set_translation($best);
		return $self->update;
	}
}

sub max_msgstr_index {
	my ( $self ) = @_;
	if ( $self->token->msgid_plural ) {
		return $self->token_domain_language->language->nplurals_index;
	} else {
		return 0;
	}
}

sub translations {
    my ( $self, $user, $for_other ) = @_;
    return $self->token_language_translations unless $user;
    my $is_user = sub { $_->username eq $user->username };
    my @tokens = $self->token_language_translations;

    return grep { $is_user->($_) } @tokens unless ($for_other);
    return grep { !$is_user->($_) } @tokens;
}

# the same code, just different written (for people who have no clue of CODEREF)
# sub translations {
	# my ( $self, $user, $for_other ) = @_;
	# return $self->token_language_translations unless $user;
	# my @results;
	# for (@{$self->token_language_translations}) {
		# my $is_user = $_->username eq $user->username;
		# return $_ if $is_user and not $for_other;
		# push @results, $_ unless $is_user;
	# }
	# return @results;
# }

use overload '""' => sub {
	my $self = shift;
	return 'Token-Language #'.$self->id;
}, fallback => 1;

1;
