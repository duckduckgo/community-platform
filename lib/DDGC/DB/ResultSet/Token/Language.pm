package DDGC::DB::ResultSet::Token::Language;
# ABSTRACT: Resultset class for the tokens for the languages

use Moose;
extends 'DBIx::Class::ResultSet';
use namespace::autoclean;

# Get all untranslated tokens of the given token domain and language
sub untranslated {
	my ( $self, $token_domain_id, $language_id, $scalar_ignore_ids ) = @_;
	my @ignore_ids = $scalar_ignore_ids ? @{$scalar_ignore_ids} : ();
	$self->search({
		'token_language_translations.id' => undef,
		'token_domain_id' => $token_domain_id,
		'language_id' => $language_id,
		'me.id' => { -not_in => \@ignore_ids },
	},{
		join => [ {
			token_language_translations => 'token_language_translation_votes'
		}, 'token_domain_language' ],
		order_by => { -asc => 'me.created' },
	});
}

# Get all untranslated tokens of the language of the given user
sub untranslated_all {
	my ( $self, $user, $scalar_ignore_ids ) = @_;

	my @language_ids = map { $_->language_id } $user->user_languages->search({},{
		select => 'me.language_id',
	})->all;
	my @ignore_ids = $scalar_ignore_ids ? @{$scalar_ignore_ids} : ();

	$self->search({
		'token_language_translations.id' => undef,
		'token_domain_language.language_id' => { -in => \@language_ids},
		'me.id' => { -not_in => \@ignore_ids },
		$self->result_source->schema->ddgc->is_live ? ( 'token_domain.key' => { -like => 'duckduckgo-%' } ) : (),
	},{
		join => [ 'token_language_translations', { token_domain_language => 'token_domain' } ],
		order_by => { -asc => 'me.created' },
	});
}

# Get all unvoted translations of the given user
sub unvoted_all {
	my ( $self, $user, $scalar_ignore_ids ) = @_;

	my @language_ids = map { $_->language_id } $user->user_languages->search({},{
		select => 'me.language_id',
	})->all;
	my @ignore_ids = $scalar_ignore_ids ? @{$scalar_ignore_ids} : ();

	$self->search({
		'token_language_translations.id' => { -not => undef },
		'token_domain_language.language_id' => { -in => \@language_ids},
		-and => [
			'me.id' => { -not_in => \@ignore_ids },
			'me.id' => { -not_in => $self->search({
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
		$self->result_source->schema->ddgc->is_live ? ( 'token_domain.key' => { -like => 'duckduckgo-%' } ) : (),
	},{
		join => [ {
			token_language_translations => 'token_language_translation_votes'
		}, { token_domain_language => 'token_domain' } ],
		order_by => { -asc => 'me.created' },
	});
}

# Get all unvoted translations of the given token domain, language and user
sub unvoted {
	my ( $self, $token_domain_id, $language_id, $user, $scalar_ignore_ids ) = @_;
	my @ignore_ids = $scalar_ignore_ids ? @{$scalar_ignore_ids} : ();
	$self->search({
		'token_language_translations.id' => { -not => undef },
		'token_domain_id' => $token_domain_id,
		'language_id' => $language_id,
		-and => [
			'me.id' => { -not_in => \@ignore_ids },
			'me.id' => { -not_in => $self->search({
				'token_language_translation_votes.users_id' => $user->id,
				'token_domain_id' => $token_domain_id,
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
		join => [ {
			token_language_translations => 'token_language_translation_votes'
		}, 'token_domain_language' ],
		order_by => { -asc => 'me.created' },
	});
}

no Moose;
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );
