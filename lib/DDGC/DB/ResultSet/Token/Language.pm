package DDGC::DB::ResultSet::Token::Language;
# ABSTRACT: Resultset class for the tokens for the languages

use Moose;
extends 'DDGC::DB::Base::ResultSet';
use namespace::autoclean;

# Get all untranslated tokens of the given token domain and language
sub untranslated {
	my ( $self, $token_domain_id, $language_id, $scalar_ignore_ids ) = @_;
	my @ignore_ids = $scalar_ignore_ids ? @{$scalar_ignore_ids} : ();
	$self->search({
		'token_domain_language.token_domain_id' => $token_domain_id,
		'language_id' => $language_id,
		'token.retired' => 0,
		-and => [
			'me.id' => { -not_in => \@ignore_ids },
			-or => [
				'me.id' => { -not_in =>
					$self->ddgc->rs('Token::Language::Translation')->search({
						check_result => '1',
					},)->get_column('token_language_id')->as_query,
				},
				fuzzy => 1,
			],
		],
	},{
		join => [ {
			token_language_translations => 'token_language_translation_votes'
		}, 'token_domain_language', 'token' ],
		order_by => { -asc => ($self->me.'created') },
	});
}

# Get all untranslated tokens of the language of the given user
sub untranslated_all {
	my ( $self, $user, $scalar_ignore_ids ) = @_;

	my @language_ids = map { $_->language_id } $user->user_languages->search({},{
		select => ($self->me.'language_id'),
	})->all;
	my @ignore_ids = $scalar_ignore_ids ? @{$scalar_ignore_ids} : ();
	$self->search({
		'token_language_translations.id' => undef,
		'token_domain_language.language_id' => { -in => \@language_ids},
		'token_domain.active' => 1,
		'token.retired' => 0,
		($self->me.'id') => { -not_in => \@ignore_ids },
		$self->result_source->schema->ddgc->is_live ? ( 'token_domain.key' => { -like => 'duckduckgo-%' } ) : (),
	},{
		join => [ 'token', 'token_language_translations', { token_domain_language => 'token_domain' } ],
		order_by => { -asc => ($self->me.'created') },
	});
}

# Get all unvoted translations of the given user
sub unvoted_all {
	my ( $self, $user, $scalar_ignore_ids, $token_domain_id ) = @_;
	my $schema = $self->result_source->schema;

	my @language_ids = map { $_->language_id } $user->user_languages->search({},{
		select => $self->me.'language_id',
	})->all;
	my @ignore_ids = $scalar_ignore_ids ? @{$scalar_ignore_ids} : ();

	$self->search({
		'token_language_translations.id' => { -not => undef },
		'token_domain_language.language_id' => { -in => \@language_ids},
		'token_domain.active' => 1,
		'token.retired' => 0,
		$token_domain_id ? ( 'token_domain_language.token_domain_id' => $token_domain_id ) : (),
		-and => [
			($self->me.'id') => { -not_in => \@ignore_ids },
			($self->me.'id') => { -not_in => $self->search({
				'token_language_translation_votes.users_id' => $user->id,
				$self->result_source->schema->ddgc->is_live ? ( 'token_domain.key' => { -like => 'duckduckgo-%' } ) : (),
			},{
				select => 'user_voted.id',
				alias => 'user_voted',
				join => [ {
					token_language_translations => 'token_language_translation_votes'
				}, { token_domain_language => 'token_domain' } ],
			})->as_query},
		],
		$schema->ddgc->is_live ? ( 'token_domain.key' => { -like => 'duckduckgo-%' } ) : (),
	},{
		join => [ 'token', {
			token_language_translations => 'token_language_translation_votes'
		}, { token_domain_language => 'token_domain' } ],
		order_by => { -desc => ($self->me.'created') },
		# '+columns' => {
		# 	token_language_votes => $schema->resultset('Token::Language::Translation::Vote')->search({
		# 		'token_language_translation.token_language_id' => { -ident => 'me.id' },
		# 	},{
		# 		join => 'token_language_translation',
		# 		alias => 'votes',
		# 	})->count_rs->as_query,
		# },
	});
}

# Get all unvoted translations of the given token domain, language and user
sub unvoted {
	my ( $self, $token_domain_id, $language_id, $user, $scalar_ignore_ids ) = @_;
	my $schema = $self->result_source->schema;
	my @ignore_ids = $scalar_ignore_ids ? @{$scalar_ignore_ids} : ();
	$self->search({
		'token_language_translations.id' => { -not => undef },
		'token_domain_language.token_domain_id' => $token_domain_id,
		'language_id' => $language_id,
		'token.retired' => 0,
		-and => [
			($self->me.'id') => { -not_in => \@ignore_ids },
			($self->me.'id') => { -not_in => $self->search({
				'token_language_translation_votes.users_id' => $user->id,
				'token_domain_language.token_domain_id' => $token_domain_id,
				'language_id' => $language_id,
			},{
				select => 'user_voted.id',
				alias => 'user_voted',
				join => [ {
					token_language_translations => 'token_language_translation_votes'
				}, 'token_domain_language' ],
			})->as_query},
		],
	},{
		join => [ 'token', {
			token_language_translations => 'token_language_translation_votes'
		}, 'token_domain_language' ],
		order_by => { -desc => 'me.created' },
		# '+columns' => {
		# 	token_language_votes => $schema->resultset('Token::Language::Translation::Vote')->search({
		# 		'token_language_translation.token_language_id' => { -ident => 'me.id' },
		# 	},{
		# 		join => 'token_language_translation',
		# 		alias => 'votes',
		# 	})->count_rs->as_query,
		# },
	});
}

no Moose;
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );
