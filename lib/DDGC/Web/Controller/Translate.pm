package DDGC::Web::Controller::Translate;
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

	$c->add_bc('Translation Interface', $c->chained_uri('Translate','index'));

}

sub index :Chained('base') :PathPart('') :Args(0) {
    my ( $self, $c ) = @_;
	$c->stash->{headline_template} = 'headline/translate.tt';
	$c->stash->{token_domains} = $c->d->rs('Token::Domain');
	$c->bc_index;
}

sub logged_in :Chained('base') :PathPart('') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
	if (!$c->user) {
		$c->response->redirect($c->chained_uri('My','login'));
		return $c->detach;
	}
	if (!$c->user->db->user_languages->search({})->all) {
		$c->response->redirect($c->chained_uri('My','account'));
		return $c->detach;
	}
}

sub tokenlanguage :Chained('logged_in') :Args(1) {
	my ( $self, $c, $token_language_id ) = @_;
	$self->save_translate_params($c) if ($c->req->params->{save_translation});
	$c->stash->{token_language} = $c->d->rs('Token::Language')->find({ id => $token_language_id });
	if (!defined $c->stash->{token_language} or !$c->stash->{token_language}) {
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

sub vote :Chained('translation') :CaptureArgs(1) {
	my ( $self, $c, $vote ) = @_;
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
	$c->stash->{token_domain} = $c->d->rs('Token::Domain')->find({ key => $token_domain_key },{
		prefetch => {
			token_domain_languages => 'language',
		},
	});
	return $c->go($c->controller('Root'),'default') unless $c->stash->{token_domain};
	$c->stash->{locales} = {};
	$c->stash->{token_domain_languages} = [$c->stash->{token_domain}->token_domain_languages->search({},{
		order_by => { -asc => 'language.locale' },
		prefetch => 'language',
	})->all];
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

	$c->add_bc($c->stash->{token_domain}->name, $c->chained_uri('Translate','tokens',$c->stash->{token_domain}->key,$c->stash->{locale}));
}

sub admin :Chained('domain') :Args(0) {
    my ( $self, $c ) = @_;

    $c->add_bc('Translation Administration', '');

   	if ($c->req->params->{search_token_comments}) {
   		$c->stash->{search_token_comments_result} = $c->stash->{token_domain}->tokens->search({
   			notes => { -like => '%'.$c->req->params->{search_token_comments}.'%' },
   		},{
   			group_by => 'notes',
   		});
   	}

    $c->pager_init($c->action.$c->stash->{token_domain}->id,20);
    $c->stash->{latest_comments} = $c->stash->{token_domain}->comments($c->stash->{page},$c->stash->{pagesize});
}

sub domainindex :Chained('domain') :PathPart('') :Args(0) {
    my ( $self, $c ) = @_;
	$c->response->redirect($c->chained_uri('Translate','tokens',$c->stash->{token_domain}->key,$c->stash->{locale}));
	return $c->detach;
}

sub locale :Chained('domain') :PathPart('') :CaptureArgs(1) {
    my ( $self, $c, $locale ) = @_;
	$c->stash->{locale} = $locale;
	$c->stash->{cur_language} = $c->stash->{locales}->{$c->stash->{locale}}->{l};
	return $c->go($c->controller('Root'),'default') unless $c->stash->{cur_language};
	$c->stash->{token_domain_language} = $c->stash->{locales}->{$c->stash->{locale}}->{tcl};
	$c->session->{cur_locale}->{$c->stash->{token_domain}->key} = $c->stash->{locale};
	$c->stash->{user_can_speak} = $c->user->can_speak($c->stash->{locale});
	$c->add_bc($c->stash->{cur_language}->name_in_english, $c->chained_uri('Translate','tokens',$c->stash->{token_domain}->key,$c->stash->{locale}));
}

sub alltokens :Chained('locale') :Args(0) {
    my ( $self, $c ) = @_;
    $c->add_bc('All tokens', '');
	$c->stash->{token_languages} = $c->stash->{locales}->{$c->stash->{locale}}->{tcl}->token_languages->search({
		'token.type' => 1,
	},{
		order_by => 'me.created',
		prefetch => 'token',
	});
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
			$token_language->add_user_translation($c->user,$k{$_});
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
    $c->stash->{latest_comments} = $c->stash->{token_domain_language}->comments($c->stash->{page},$c->stash->{pagesize});
    $c->add_bc('Latest comments', '');
}

sub tokens :Chained('locale') :Args(0) {
    my ( $self, $c ) = @_;
    $c->bc_index;
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
	if ($c->req->params->{token_search}) {
		$c->stash->{token_search} = $c->req->params->{token_search};
		$c->stash->{token_languages} = $c->stash->{locales}->{$c->stash->{locale}}->{tcl}->search_tokens($c->stash->{page},$c->stash->{pagesize},$c->stash->{token_search});
	} elsif ($c->req->params->{only_untranslated}+0) {
		$c->stash->{only_untranslated} = 1;
		$c->stash->{token_languages} = $c->stash->{locales}->{$c->stash->{locale}}->{tcl}->untranslated_tokens($c->stash->{page},$c->stash->{pagesize});
	} elsif (defined $c->req->params->{only_msgctxt}) {
		$c->stash->{only_msgctxt} = $c->req->params->{only_msgctxt};
		$c->stash->{token_languages} = $c->stash->{locales}->{$c->stash->{locale}}->{tcl}->msgctxt_tokens($c->stash->{page},$c->stash->{pagesize},$c->stash->{only_msgctxt});
	} else {
		$c->stash->{token_languages} = $c->stash->{locales}->{$c->stash->{locale}}->{tcl}->all_tokens($c->stash->{page},$c->stash->{pagesize});
	}
	if ($save_translations && $next_page && $c->stash->{token_languages}->pager->next_page) {
		$c->res->redirect($c->chained_uri('Translate','tokens',$c->stash->{token_domain}->key,$c->stash->{locale},{ page => $c->stash->{token_languages}->pager->next_page }));
		return $c->detach;
	}
}

__PACKAGE__->meta->make_immutable;

1;
