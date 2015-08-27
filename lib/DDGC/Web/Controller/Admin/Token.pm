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

	if ($c->req->param('save_token_domain')) {
		my %data;
		for (keys %{$c->req->params}) {
			if ($_ =~ m/^token_domain_(\d+)_(.+)$/) {
				my $id = $1;
				my $key = $2;
				$data{$id} = {} unless defined $data{$id};
				$data{$id}->{$key} = $c->req->param($_);
			}
		}
		for my $id (keys %data) {
			my $values = $data{$id};
			if ($id > 0) {
				my $token_domain = $c->d->rs('Token::Domain')->find($id);
				die "token_domain id ".$_." not found" unless $token_domain;
				for (keys %{$values}) {
					$token_domain->$_($values->{$_});
				}
				$token_domain->update;
				$c->stash->{changed_token_domain_id} = $id;
			} else {
				my $english = $c->d->rs('Language')->find({ locale => 'en_US' });
				die "cant find a language with locale en_US" unless $english;
				$values->{source_language_id} = $english->id;
				my $new_token_domain = $c->d->rs('Token::Domain')->create($values);
				$c->stash->{changed_token_domain_id} = $new_token_domain->id;
			}
		}
	}

	$c->stash->{token_domains} = [ $c->d->rs('Token::Domain')->search({},{
		'+columns' => {
			token_count => $c->d->rs('Token')->search({
				'token_domain_id' => { -ident => 'me.id' },
			},{
				alias => 'token_count_col',
			})->count_rs->as_query,
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
		order_by => { -asc => 'sorting' },
	})->all ];

}

no Moose;
__PACKAGE__->meta->make_immutable;
