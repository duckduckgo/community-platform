package DDGC::DB::Result::Token::Language;
# ABSTRACT: A token in a specific language

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use HTML::Entities;
use namespace::autoclean;

table 'token_language';

sub u { 
	my ( $self ) = @_;
	[ 'Translate', 'tokenlanguage', $self->id ]
}

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

column translator_users_id => {
	data_type => 'bigint',
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

column fuzzy => {
	data_type => 'tinyint',
	is_nullable => 0,
	default_value => 0,
};

belongs_to 'token', 'DDGC::DB::Result::Token', 'token_id', {
	on_delete => 'cascade',
};

belongs_to 'token_domain_language', 'DDGC::DB::Result::Token::Domain::Language', 'token_domain_language_id', {
	on_delete => 'cascade',
};

belongs_to 'translator_user', 'DDGC::DB::Result::User', 'translator_users_id', { join_type => 'left' };

has_many 'token_language_translations', 'DDGC::DB::Result::Token::Language::Translation', 'token_language_id', {
	cascade_delete => 1,
};

unique_constraint [qw/ token_id token_domain_language_id /];

sub event_related {
	my ( $self ) = @_;
	my @related = $self->token_domain_language->event_related;
	push @related, ['DDGC::DB::Result::Token',$self->token_id];
	return @related;
}

sub gettext_snippet {
	my ( $self, $fallback ) = @_;
	my %vars;
	my $msgstr_index_max = $self->token_domain_language->language->nplurals - 1;

	if ($self->token_domain_language->language->locale eq 'en_US') {
		$vars{msgid} = $self->gettext_escape($self->token->msgid);
		$vars{msgctxt} = $self->gettext_escape($self->token->msgctxt) if $self->token->msgctxt;
		if ($self->token->msgid_plural) {
			$vars{msgid_plural} = $self->gettext_escape($self->token->msgid_plural);
			$vars{'msgstr[0]'} = $self->gettext_escape($self->token->msgid);
			$vars{'msgstr[1]'} = $self->gettext_escape($self->token->msgid_plural);
		}
		else {
			$vars{msgstr} = $self->gettext_escape($self->token->msgid);
		}
		return "\n".$self->gettext_snippet_formatter(%vars);
	}

	if ($self->token->msgid_plural) {
		for (0..$msgstr_index_max) {
			my $func = 'msgstr'.$_;
			my $result = $self->$func;
			$vars{'msgstr['.$_.']'} = $self->gettext_escape($result) if $result;
		}
	} else {
		$vars{'msgstr'} = $self->gettext_escape($self->msgstr0) if $self->msgstr0;
	}
	return unless %vars || $fallback;
	$vars{msgid} = $self->gettext_escape($self->token->msgid);
	$vars{msgctxt} = $self->gettext_escape($self->token->msgctxt) if $self->token->msgctxt;
	if ($self->token->msgid_plural) {
		$vars{msgid_plural} = $self->gettext_escape($self->token->msgid_plural);
		for (0..$msgstr_index_max) {
			$vars{'msgstr['.$_.']'} = $self->gettext_escape($self->token->msgid_plural)
				unless defined $vars{'msgstr['.$_.']'};
		}
	} else {
		$vars{msgstr} = $self->gettext_escape($self->token->msgid)
			unless defined $vars{msgstr};
	}
	return "\n".$self->gettext_snippet_formatter(%vars);
}

sub gettext_escape {
	my ( $self, $content ) = @_;
	$content =~ s/\\/\\\\/g;
	$content =~ s/"/\\"/g;
	return $content;
}

sub delete_msgstr {
	my ( $self, $user ) = @_;
	die "Access denied" unless $user->is('translation_manager');
	for ( map { "msgstr$_" } 0..5 ) {
		$self->$_(undef);
	}
	$self->update;
}

sub gettext_snippet_formatter {
	my ( $self, %vars ) = @_;
	my $return;
	for (qw( msgctxt msgid msgid_plural )) {
		$return .= $_.' "'.(delete $vars{$_}).'"'."\n" if $vars{$_};
	}
	for (sort { $a cmp $b } keys %vars) {
		$return .= $_.' "'.(delete $vars{$_}).'"'."\n";
	}
	return $return;
}

sub add_user_translation {
	my ( $self, $user, $translation ) = @_;
	if ($user->can_speak($self->token_domain_language->language->locale)) {
		my $found = $self->search_related('token_language_translations',{
			%{$translation},
			username => $user->username,
		})->one_row;
		unless ($found) {
			my $plurals=$self->max_msgstr_index;
			for (my $i = $plurals; $i > -1; $i--) {
				return 0 unless $translation->{'msgstr'.$i};
			}
			$self->create_related('token_language_translations',{
				%{$translation},
				username => $user->username,
			});
			return 1;
		}
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
	$self->translator_users_id($translation->user->id) if $translation->user;
}

sub auto_use {
	my ( $self ) = @_;
	my @translations = $self->search_related('token_language_translations',{});
	# my @translations = $self->search_related('token_language_translations',{},{
	# 	order_by => [ 'me.updated', 'me.id' ],
	# 	prefetch => [{ user => 'user_languages', token_language_translation_votes => 'user' }],
	# })->all;
	my %first;
	my %grade;
	my %votes;
	for (@translations) {
		next if $_->invalid;
		my $translation = $_;
		if (defined ($first{$translation->key})) {
			my $old = $first{$translation->key};
			my $translator = $translation->user;
			$old->set_user_vote($translator,1);
			for my $vote ($translation->votes) {
				$old->set_user_vote($vote->user,1);
			}
			$translation->delete;
			$translation = $old;
		} else {
			$first{$translation->key} = $translation;
		}
		my $translator_translation_language = $translation->user->search_related('user_languages',{
			language_id => $self->token_domain_language->language->id,
		})->one_row;
		$grade{$translation->key} = defined $translator_translation_language ? $translator_translation_language->grade : 0;
		for my $vote ($translation->votes) {
			my $translation_language = $vote->user->search_related('user_languages',{
				language_id => $self->token_domain_language->language->id,
			})->one_row;
			my $translation_grade = $translation_language ? $translation_language->grade : 0;
			my $best_grade = defined $grade{$translation->key} ? $grade{$translation->key} : 0;
			$grade{$translation->key} = $translation_grade if $translation_grade > $best_grade;
		}
		$votes{$translation->key} = $translation->vote_count;
	}
	my $best;
	for (keys %first) {
		if ($best) {
			$best = $first{$_} if $votes{$_} > $votes{$best->key};
			$best = $first{$_} if $votes{$_} == $votes{$best->key}
								&& $grade{$_} > $grade{$best->key};
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

sub own_translations {
	my ( $self, $user ) = @_;
	my @own_translations;
	for (@{$self->translations}) {
		push @own_translations, $_ if $_->username eq $user->username;
	}
	return [sort { $b->created <=> $a->created } @own_translations];
}

sub latest_own_translation {
	my ( $self, $user ) = @_;
	my @own_translations = @{$self->own_translations($user)};
	my $own_translation = shift @own_translations;
	return $own_translation ? $own_translation : ();
}

has translations => (
	is => 'ro',
	lazy_build => 1,
);

sub _build_translations { [sort { $a->vote_count <=> $b->vote_count } shift->token_language_translations->all] }

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

no Moose;
__PACKAGE__->meta->make_immutable ( inline_constructor => 0 );
