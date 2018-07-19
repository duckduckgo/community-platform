package DDGC::Web::Controller::Translate;
# ABSTRACT: Translation pages web controller class

use Moose;
use namespace::autoclean;

use DDGC::Config;
use Data::Printer;
use Path::Class;
use DDGC::Util::Po;
use JSON;
use IO::All;
use DateTime;

BEGIN {extends 'Catalyst::Controller'; }

sub base :Chained('/base') :PathPart('translate') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
	if ($c->user && !$c->user->user_languages) {
		$c->response->redirect($c->chained_uri('Translate','index'));
		return $c->detach;
	}
	$c->stash->{title} = 'Translations';
	$c->stash->{page_class} = "page-translate";
	$c->stash->{user_has_languages} = $c->user ? $c->user->user_languages->count : 0;

	$c->add_bc('Translation Interface', $c->chained_uri('Translate','index'));

}

sub index :Chained('base') :PathPart('') :Args(0) {
    my ( $self, $c ) = @_;
	$c->stash->{headline_template} = 'headline/translate.tt';
	$c->stash->{token_domains} = [ $c->d->rs('Token::Domain')->search({
			active => 1,
		},{
		'+columns' => {
			token_count => $c->d->rs('Token')->search({
				'token_domain_id' => { -ident => 'me.id' },
			},{
				alias => 'token_count_col',
			})->count_rs->as_query,
		},
		cache_for => 300,
	})->all ];
	$c->bc_index;
}

sub logged_in :Chained('base') :PathPart('') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
	if (!$c->user) {
		$c->response->redirect($c->chained_uri('My','login'));
		return $c->detach;
	}
	if (!$c->stash->{user_has_languages}) {
		$c->response->redirect($c->chained_uri('My','account',{ no_languages => 1 }));
		return $c->detach;
	}
}

sub active_tokens :Chained('base') :PathPart('active_tokens.json') :Args(1) {
	my ( $self, $c, $domain ) = @_;
	$domain ||= 'duckduckgo-duckduckgo';
	$c->stash->{x} = {
		tokens => [
			map { { id => $_->id, msgid => $_->msgid } }
			$c->d->rs('Token')
			->search({
				retired => 0,
				'token_domain.key' => $domain,
			},
			{ prefetch => 'token_domain' })
			->all
		]
	};
	$c->forward( $c->view('JSON') );
}

sub untranslated_all :Chained('logged_in') :Args(0) {
	my ( $self, $c ) = @_;
	$c->wiz_start( 'UntranslatedAll' );
}

sub unvoted_all :Chained('logged_in') :Args(0) {
	my ( $self, $c ) = @_;
	$c->wiz_start( 'UnvotedAll' );
}

sub token :Chained('logged_in') :Args(1) {
	my ( $self, $c, $token_id ) = @_;
	if ($c->req->params->{save_token_note}) {

		for (keys %{$c->req->params}) {
			if ($_ =~ m/token_notes_(\d+)_edit$/) {
				my $token = $c->d->resultset('Token')->find($1);
				$token->notes($c->req->params->{$_});
				$token->update;
			}
		}
	}

	$c->stash->{token} = $c->d->rs('Token')->find({ id => $token_id });
	unless ($c->stash->{token}) {
		$c->response->redirect($c->chained_uri('Translate','index'));
		return $c->detach;
	}
	$c->add_bc('Token #'.$c->stash->{token}->id);

	my @token_languages = $c->stash->{token}->token_languages->search({},{
		prefetch => [
			{
				token_domain_language => [ 'token_domain', 'language' ],
			},
			'token',
		],
	})->all;
	$c->stash->{token_languages} = \@token_languages;

	my @token_languages_can;
	my @token_languages_not;

	for my $token_language (@token_languages) {
		if ($c->user->can_speak($token_language->token_domain_language->language->locale)) {
			push @token_languages_can, $token_language;
		} else {
			push @token_languages_not, $token_language;
		}
	}

	$c->stash->{token_languages_can} = \@token_languages_can;
	$c->stash->{token_languages_not} = \@token_languages_not;

}

sub tokenlanguage :Chained('logged_in') :Args(1) {
	my ( $self, $c, $token_language_id ) = @_;
	$self->save_translate_params($c) if ($c->req->params->{save_translations});
	if ($c->wiz_inside && $c->req->params->{wizard_skip}) {
		push @{$c->wiz->unwanted_ids}, $token_language_id;
		$c->wiz_step;
	} else {
		$c->stash->{token_language} = $c->d->rs('Token::Language')->find({ id => $token_language_id });
		if (!defined $c->stash->{token_language} or !$c->stash->{token_language} or !$c->stash->{token_language}->token->token_domain->active) {
			$c->response->redirect($c->chained_uri('Translate','index'));
			return $c->detach;
		}
		$c->stash->{user_can_speak} = $c->user->can_speak($c->stash->{token_language}->token_domain_language->language->locale);
		$c->stash->{hide_tokenlanguage_discuss} = 1;
		$c->add_bc(
			'Token #'.$c->stash->{token_language}
				->token->id.
			' at '.$c->stash->{token_language}
				->token_domain_language
					->token_domain->name.
			' in '.$c->stash->{token_language}
				->token_domain_language
					->language->name_in_english,
		'');
	}
}

sub translation :Chained('logged_in') :CaptureArgs(1) {
	my ( $self, $c, $translation_id ) = @_;
	$c->stash->{translation} = $c->d->rs('Token::Language::Translation')->find({ id => $translation_id });
	if (!$c->stash->{translation}) {
		$c->response->redirect($c->chained_uri('Translate','index',{ no_translation => 1 }));
		$c->response->status(404);
		return $c->detach;
	}
}

sub translation_check :Chained('translation') :PathPart('check') :Args(1) {
	my ( $self, $c, $check ) = @_;
	$c->stash->{translation}->set_check($c->user,$check);
	$c->stash->{translation}->update;
	$c->stash->{x} = {
		check_result => $c->stash->{translation}->check_result,
	};
	$c->forward( $c->view('JSON') );
}

sub delete_msgstr :Chained('logged_in') :PathPart('delete_live') :Args(1) {
	my ( $self, $c, $token_language_id ) = @_;
	my $tl = $c->d->rs('Token::Language')->find({ id => $token_language_id });
	if ( !$tl ) {
		$c->response->status(404);
		return $c->detach;
	}
	if ( $tl->delete_msgstr( $c->user ) ) {
		$c->stash->{x} = {
			check_result => 2,
		};
	} else {
		$c->response->status(403);
		$c->stash->{x} = { error => 'Access denied' };
	}
	$c->forward( $c->view('JSON') );
}

sub single_token :Chained('logged_in') CaptureArgs(1) {
	my ( $self, $c, $token_id ) = @_;
	$c->stash->{token} = $c->d->rs('Token')->find({ id => $token_id });
	if (!$c->stash->{token}) {
		$c->response->status(404);
		return $c->detach;
	}
}

sub token_retire :Chained('single_token') :PathPart('retire') :Args(1) {
	my ( $self, $c, $retire ) = @_;
	if ( !$c->user->admin ) {
		$c->response->status(403);
		$c->stash->{x} = {
			error => 403
		}
	}
	else {
		$c->stash->{token}->retired($retire);
		$c->stash->{token}->update;
		$c->stash->{x} = {
			check_result => $c->stash->{token}->retired,
		};
	}
	$c->forward( $c->view('JSON') );
}

sub vote :Chained('translation') :CaptureArgs(1) {
	my ( $self, $c, $vote ) = @_;
	$c->require_action_token;
	$c->stash->{translation}->set_user_vote($c->user,0+$vote);
}

sub vote_view :Chained('vote') :PathPart('') :Args(0) {
	my ( $self, $c ) = @_;
	$c->stash->{x} = {
		vote_count => $c->stash->{translation}->votes->count
	};
	$c->forward( $c->view('JSON') );
}

sub vote_redirect :Chained('vote') :PathPart('redirect') :Args(0) {
	my ( $self, $c ) = @_;
	$c->response->redirect($c->chained_uri('Translate','tokenlanguage',$c->stash->{translation}->token_language->id));
	return $c->detach;
}

sub domain :Chained('logged_in') :PathPart('') :CaptureArgs(1) {
    my ( $self, $c, $token_domain_key ) = @_;
	$c->stash->{locale} = $c->req->params->{locale} ? $c->req->params->{locale} :
		$c->session->{cur_locale}->{$token_domain_key} ? $c->session->{cur_locale}->{$token_domain_key} : undef;
	$c->stash->{token_domain} = $c->d->rs('Token::Domain')->find({ key => $token_domain_key });
	return $c->go($c->controller('Root'),'default') unless ($c->stash->{token_domain} && $c->stash->{token_domain}->active);
	$c->stash->{locales} = {};
	my $token_domain_language_rs = $c->stash->{token_domain}->token_domain_languages->search({});
	$c->stash->{token_domain_languages_rs} = $token_domain_language_rs->search({},{
		'+columns' => {
			token_languages_undone_count => $c->d->rs('Token::Language')->search({
				-and => [
					'undone_count.id' =>  { -not_in =>
						$c->ddgc->rs('Token::Language::Translation')->search({
							check_result => '1',
						},)->get_column('token_language_id')->as_query,
					},
					'undone_count.token_domain_language_id' => { -ident => 'me.id' },
					'token.retired' => 0,
				],
			},{
				join => [ 'token', 'token_language_translations' ],
				alias => 'undone_count'
			})->count_rs->as_query,
			token_total_count => $c->d->rs('Token')->search({
				'total_count.token_domain_id' => { -ident => 'me.token_domain_id' },
				'retired' => 0,
			},{
				join => 'token_domain', alias => 'total_count'
			})->count_rs->as_query,
		},
		order_by => { -asc => 'language.locale' },
		prefetch => [ 'language' ],
		cache_for => 300,
	});
	$c->stash->{token_domain_languages} = [$c->stash->{token_domain_languages_rs}->all];
	for (@{$c->stash->{token_domain_languages}}) {
		my $locale = $_->language->locale;
		$c->stash->{locale} = $locale if !$c->stash->{locale} && $c->user->can_speak($locale);
		$c->stash->{locales}->{$locale} = {
			l => $_->language,
			u => defined $c->user->lul->{$locale} ? $c->user->lul->{$locale} : undef,
			tcl => $_,
		};
		$c->stash->{last_locale} = $_->language->locale;
	}
	$c->stash->{locale} = $c->stash->{last_locale} if !$c->stash->{locale};

	$c->add_bc($c->stash->{token_domain}->name, $c->chained_uri('Translate','domainindex',$c->stash->{token_domain}->key));
}

sub domainsearch :Chained('domain') :PathPart('search') :Args(0) {
	my ( $self, $c ) = @_;
	$c->add_bc('Search');
	$c->stash->{search} = $c->req->param('search');
	if ($c->req->param('submit_search')) {
		$c->stash->{token_results} = [ $c->stash->{token_domain}->tokens->search([
			msgid => { -ilike => '%'.$c->stash->{search}.'%' },
			msgid_plural => { -ilike => '%'.$c->stash->{search}.'%' },
		])->all ];
		$c->stash->{token_language_translation_results} = [ $c->d->rs('Token::Language::Translation')->search([
			map {
				'msgstr'.$_ => { -ilike => '%'.$c->stash->{search}.'%' },
			} (0..5)
		])->all ],
	}
}

sub domainindex :Chained('domain') :PathPart('') :Args(0) {
	my ( $self, $c ) = @_;
	$c->bc_index;

	my @can_speak;
	my @not_speak;

	for (@{$c->stash->{token_domain_languages}}) {
		if ($c->user->can_speak($_->language->locale)) {
			push @can_speak, $_;
		} else {
			push @not_speak, $_;
		}
	}

	$c->stash->{can_speak} = \@can_speak;
	$c->stash->{not_speak} = \@not_speak;
}

sub domainuntranslated :Chained('domain') :Args(0) {
	my ( $self, $c ) = @_;
	$c->wiz_start( 'UntranslatedAllDomain', token_domain_id => $c->stash->{token_domain}->id );
}

sub domainunvoted :Chained('domain') :Args(0) {
	my ( $self, $c ) = @_;
	$c->wiz_start( 'UnvotedAllDomain', token_domain_id => $c->stash->{token_domain}->id );
}

sub admin :Chained('domain') :Args(0) {
	my ( $self, $c ) = @_;

	$c->add_bc('Translation Management', '');

	if ($c->req->params->{search_token_comments}) {
		$c->stash->{search_token_comments_result} = $c->stash->{token_domain}->tokens->search({
			notes => { -ilike => '%'.$c->req->params->{search_token_comments}.'%' },
		},{
			group_by => 'notes',
		});
	}

	$c->pager_init($c->action.$c->stash->{token_domain}->id,20);
	$c->stash->{latest_comments} = [ $c->stash->{token_domain}->comments($c->stash->{page},$c->stash->{pagesize})->all ];
}


sub locale :Chained('domain') :PathPart('') :CaptureArgs(1) {
    my ( $self, $c, $locale ) = @_;
	$c->stash->{locale} = $locale;
	$c->stash->{cur_language} = $c->stash->{locales}->{$c->stash->{locale}}->{l};
	return $c->go($c->controller('Root'),'default') unless $c->stash->{cur_language};
	$c->stash->{token_domain_language} = $c->stash->{locales}->{$c->stash->{locale}}->{tcl};
	$c->session->{cur_locale}->{$c->stash->{token_domain}->key} = $c->stash->{locale};
	$c->stash->{user_can_speak} = $c->user->can_speak($c->stash->{locale});
	$c->add_bc($c->stash->{cur_language}->name_in_english, $c->chained_uri('Translate','landing',$c->stash->{token_domain}->key,$c->stash->{locale}));
}

sub landing :Chained('locale') :Args(0) {
    my ( $self, $c ) = @_;
    $c->bc_index;
    $c->stash->{untranslated_count} = $c->d->rs('Token::Language')->untranslated($c->stash->{token_domain}->id,$c->stash->{cur_language}->id);
    #$c->stash->{unvoted_count} = $c->d->rs('Token::Language')->untranslated($c->stash->{token_domain}->id,$c->stash->{cur_language}->id,$c->user->id);
	$c->stash->{breadcrumb_right_url} =	$c->chained_uri('Translate','alltokens',$c->stash->{token_domain}->key,'LOCALE');
	$c->stash->{breadcrumb_right} = 'language';
}

sub untranslated :Chained('locale') :Args(0) {
	my ( $self, $c ) = @_;
	$c->wiz_start( Untranslated =>
		token_domain_id => $c->stash->{token_domain}->id,
		language_id => $c->stash->{cur_language}->id,
	);
}

sub unvoted :Chained('locale') :Args(0) {
	my ( $self, $c ) = @_;
	$c->wiz_start( Unvoted =>
		token_domain_id => $c->stash->{token_domain}->id,
		language_id => $c->stash->{cur_language}->id,
	);
}

sub alltokens :Chained('locale') :Args(0) {
    my ( $self, $c ) = @_;
    $c->add_bc('Token overview', '');
	$c->stash->{token_languages} = [ $c->stash->{locales}->{$c->stash->{locale}}->{tcl}->token_languages->search({
		'token.type' => 1,
	},{
		order_by => 'me.created',
		prefetch => 'token',
	})->all ];
	$c->stash->{breadcrumb_right_url} =	$c->chained_uri('Translate','alltokens',$c->stash->{token_domain}->key,'LOCALE');
	$c->stash->{breadcrumb_right} = 'language';
}

sub save_translate_params {
	my ( $self, $c ) = @_;
	my %k; # storage of token_language_id + msgstr index
	for (keys %{$c->req->params}) {
		if (length($c->req->params->{$_}) > 0 && $_ =~ m/token_language_(\d+)_msgstr(\d)/) {
			$k{$1} = {} unless defined $k{$1};
			$k{$1}->{'msgstr'.$2} = $c->req->params->{$_} ;
		}
		if ($c->user->translation_manager) {
			if ($_ =~ m/token_notes_(\d+)_edit/) {
				my $token = $c->d->rs('Token')->find($1);
				$token->notes($c->req->params->{$_});
				$token->update;
			}
			if ($_ =~ m/token_language_notes_(\d+)_edit/) {
				my $token_language = $c->d->rs('Token::Language')->find($1);
				$token_language->notes($c->req->params->{$_});
				$token_language->update;
			}
		}
	}
	if ($c->user) {
		for (keys %k) {
			my $token_language = $c->d->rs('Token::Language')->find($_);
			if ($token_language->add_user_translation($c->user,$k{$_})) {
				$c->wiz_step;
			} else {
				push @{$c->stash->{errors}}, "This could be because not all fields are filled in";
			}
		}
	}
}

sub discuss :Chained('locale') :PathPart('') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
    $c->add_bc('Discuss', '');
}

sub localecomments :Chained('discuss') :PathPart('comments') :Args(0) {
    my ( $self, $c ) = @_;
}

sub tokenscomments :Chained('discuss') :Args(0) {
    my ( $self, $c ) = @_;
    $c->pager_init($c->action.$c->stash->{token_domain_language}->id,20);
    $c->stash->{latest_comments} = [ $c->stash->{token_domain_language}->comments($c->stash->{page},$c->stash->{pagesize})->all ];
    $c->add_bc('Latest comments', '');
}

sub tokens :Chained('locale') :Args(0) {
    my ( $self, $c ) = @_;
    $c->add_bc('Token browser', '');
	my $placeholder_notes = ( $c->user->data && defined $c->user->data->{placeholder_notes} ) ? $c->user->data->{placeholder_notes} : 1;
	if (defined $c->req->params->{placeholder_notes}) {
		$placeholder_notes = $c->req->params->{placeholder_notes};
		my $data = $c->user->data || {};
		$data->{placeholder_notes} = $placeholder_notes;
		$c->user->data($data);
		$c->user->update;
	}
	$c->stash->{placeholder_notes} = $placeholder_notes;
	$c->pager_init(
		$c->action.
		$c->stash->{token_domain}->key.
		$c->stash->{locale}.
		( $c->req->params->{only_untranslated} ? "1" : "0" ).
		( defined $c->req->params->{only_msgctxt} ? '"'.$c->req->params->{only_msgctxt}.'"' : "undef" )
	,5);
	my $save_translations = $c->req->params->{save_translations} || $c->req->params->{save_translations_next_page} ? 1 : 0;
	my $next_page = $c->req->params->{save_translations_next_page} ? 1 : 0;
	$self->save_translate_params($c) if ($save_translations);
	my $lang_rs = $c->stash->{locales}->{$c->stash->{locale}}->{tcl};
	if ($c->req->params->{token_search}) {
		$c->stash->{token_search} = $c->req->params->{token_search};
		$lang_rs = $lang_rs->search_tokens($c->stash->{page},$c->stash->{pagesize},$c->stash->{token_search});
	} elsif ($c->req->params->{only_untranslated}+0) {
		$c->stash->{only_untranslated} = 1;
		$lang_rs = $lang_rs->untranslated_tokens($c->stash->{page},$c->stash->{pagesize});
	} elsif (defined $c->req->params->{only_msgctxt}) {
		$c->stash->{only_msgctxt} = $c->req->params->{only_msgctxt};
		$lang_rs = $lang_rs->msgctxt_tokens($c->stash->{page},$c->stash->{pagesize},$c->stash->{only_msgctxt});
	} else {
		$lang_rs = $lang_rs->all_tokens($c->stash->{page},$c->stash->{pagesize});
	}
	$c->stash->{token_languages} = [ $lang_rs->all ];
	$c->stash->{token_languages_pager} = $lang_rs->pager;
	if ($save_translations && $next_page && $c->stash->{token_languages_pager}->next_page) {
		$c->res->redirect($c->chained_uri('Translate','tokens',$c->stash->{token_domain}->key,$c->stash->{locale},{ page => $c->stash->{token_languages_pager}->next_page }));
		return $c->detach;
	}
}

no Moose;
__PACKAGE__->meta->make_immutable;
