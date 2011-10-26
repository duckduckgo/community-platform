package DDGC::Web::Controller::Translate;
use Moose;
use namespace::autoclean;

use DDGC::Config;
use Data::Printer;

BEGIN {extends 'Catalyst::Controller'; }

sub base :Chained('/base') :PathPart('translate') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
	push @{$c->stash->{template_layout}}, 'centered_content.tt';
}

sub do :Chained('base') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
}

sub index :Chained('do') :Args(0) {
    my ( $self, $c ) = @_;
	$c->stash->{token_domains} = $c->d->rs('Token::Domain')->search({});
}

sub logged_in :Chained('base') :PathPart('') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
	if (!$c->user) {
		$c->response->redirect($c->chained_uri('Translate','index'));
		return $c->detach;
	}
}

sub domain :Chained('logged_in') :PathPart('') :Args(1) {
    my ( $self, $c, $token_domain_key ) = @_;
	$c->stash->{locale} = $c->req->params->{locale} ? $c->req->params->{locale} :
		$c->session->{locale}->{$c->action} ? $c->session->{locale}->{$c->action} : undef;
	$c->stash->{token_domain} = $c->d->rs('Token::Domain')->find({ key => $token_domain_key },{
		prefetch => {
			token_domain_languages => 'language',
		},
	});
	$c->stash->{locales} = {};
	my $l;
	for ($c->stash->{token_domain}->token_domain_languages) {
		$l = $_->language;
		my $tcl = $_;
		my @uloc = grep { $l->locale eq $_ } keys %{$c->user->locales};
		my $u; $u = $c->user->locales->{$uloc[0]} if @uloc;
		$c->stash->{locale} = $u->language->locale if $u && !$c->stash->{locale};
		$c->stash->{locales}->{$l->locale} = {
			l => $l,
			u => $u,
			tcl => $tcl,
		};
	}
	$c->stash->{locale} = $l->locale if !$c->stash->{locale};
	$c->stash->{language} = $c->stash->{locales}->{$c->stash->{locale}}->{l};
	$c->pager_init($c->action,20);
	my $save_translations = $c->req->params->{save_translations} || $c->req->params->{save_translations_next_page} ? 1 : 0;
	my $next_page = $c->req->params->{save_translations_next_page} ? 1 : 0;
	if ($c->stash->{locales}->{$c->stash->{locale}}->{u}) {
		$c->stash->{token_languages} = $c->stash->{locales}->{$c->stash->{locale}}->{tcl}->token_languages->search({
			'token.snippet' => 1,
		},{
			order_by => 'me.created',
			page => $c->stash->{page},
			rows => $c->stash->{pagesize},
			prefetch => 'token',
		});
		if ($save_translations) {
			my %k; # storage of token_language_id + msgstr index
			for (keys %{$c->req->params}) {
				if (length($c->req->params->{$_}) > 0 && $_ =~ m/token_language_(\d+)_msgstr(\d)/) {
					$k{$1} = {} unless defined $k{$1};
					$k{$1}->{'msgstr'.$2} = $c->req->params->{$_} ;
				}
			}
			for ($c->stash->{token_languages}->all) {
				if ($c->user->admin) {
					my $change = 0;
					if ($c->req->params->{'token_notes_'.$_->id.'_edit'}) {
						$_->token->notes($c->req->params->{'token_notes_'.$_->id.'_edit'});
						$_->token->update;
					}
					if ($c->req->params->{'token_language_notes_'.$_->id.'_edit'}) {
						$_->notes($c->req->params->{'token_language_notes_'.$_->id.'_edit'});
						$_->update;
					}
				}
				if (defined $k{$_->id}) {
					$_->update_or_create_related('token_language_translations',{
						%{$k{$_->id}},
						user => $c->user->db,
					},{
						key => 'token_language_translation_token_language_id_username',
					});
				}
			}
			if ($next_page && $c->stash->{token_languages}->pager->next_page) {
				$c->res->redirect($c->chained_uri('Translate','domain',$c->stash->{token_domain}->key,{ page => $c->stash->{token_languages}->pager->next_page }));
				return $c->detach;
			}
		}
		$c->session->{locale}->{$c->action} = $c->stash->{locale};
	} else {
		$c->stash->{cant_speak} = 1;
	}
}

__PACKAGE__->meta->make_immutable;

1;
