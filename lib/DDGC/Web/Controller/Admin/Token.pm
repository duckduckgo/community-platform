package DDGC::Web::Controller::Admin::Token;
# ABSTRACT: REMOVE ME

use Moose;
BEGIN { extends 'Catalyst::Controller'; }

use namespace::autoclean;

sub base :Chained('/admin/base') :PathPart('token') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
    $c->add_bc('Token domain management', $c->chained_uri('Admin::Token','index'));
}

sub index :Chained('base') :PathPart('') :Args(0) {
    my ( $self, $c ) = @_;
    $c->bc_index;

	$c->stash->{token_domains} = $c->d->rs('Token::Domain')->search({},{
		'+columns' => {
			translation_count => $c->d->rs('Token::Language::Translation')->search({
				'token_domain_id' => { -ident => 'me.id' },
			},{
				join => {
					token_language => 'token',
				},
				alias => 'translation_count_col',
			})->count_rs->as_query,
			vote_count => $c->d->rs('Token::Language::Translation::Vote')->search({
				'token_domain_id' => { -ident => 'me.id' },
			},{
				join => {
					token_language_translation => {
						token_language => 'token',
					},
				},
				alias => 'vote_count_col',
			})->count_rs->as_query,
		},
	});

}

no Moose;
__PACKAGE__->meta->make_immutable;
