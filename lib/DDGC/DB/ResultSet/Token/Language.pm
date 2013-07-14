package DDGC::DB::ResultSet::Token::Language;

use Moose;
extends 'DBIx::Class::ResultSet';
use namespace::autoclean;

sub untranslated {
	my ( $self, $token_domain_id, $language_id, $scalar_ignore_ids ) = @_;
	my @ignore_ids = $scalar_ignore_ids ? @{$scalar_ignore_ids} : ();
	$self->search({
		'token_language_translations.id' => undef,
		'token_domain_id' => $token_domain_id,
		'language_id' => $language_id,
		'me.id' => { -not_in => \@ignore_ids },
	},{
		join => [ 'token_language_translations', 'token_domain_language' ],
		order_by => { -asc => 'me.created' },
	});
}

sub unvoted {
	my ( $self, $token_domain_id, $language_id, $user_id, $scalar_ignore_ids ) = @_;
	my @ignore_ids = $scalar_ignore_ids ? @{$scalar_ignore_ids} : ();
	$self->search({
		'token_language_translations.id' => { -not => undef },
		'token_domain_id' => $token_domain_id,
		'language_id' => $language_id,
		-and => [
			'me.id' => { -not_in => \@ignore_ids },
			'me.id' => { -not_in => $self->search({
				'token_language_translation_votes.users_id' => $user_id,
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
