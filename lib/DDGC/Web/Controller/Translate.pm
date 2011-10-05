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

sub index :Chained('base') :PathPart('') :Args(0) {
    my ( $self, $c ) = @_;
	$c->stash->{token_contexts} = $c->d->rs('Token::Context')->search({});
}

sub logged_in :Chained('base') :PathPart('') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
	if (!$c->user) {
		$c->response->redirect($c->chained_uri('Translate','index'));
		return $c->detach;
	}
}

sub context :Chained('logged_in') :Args(1) {
    my ( $self, $c, $token_context_key ) = @_;
	$c->pager_init($c->action,20);
	$c->stash->{locale} = $c->req->params->{locale} ? $c->req->params->{locale} :
		$c->session->{locale}->{$c->action} ? $c->session->{locale}->{$c->action} : undef;
	$c->stash->{token_context} = $c->d->rs('Token::Context')->find({ key => $token_context_key },{
		prefetch => {
			token_context_languages => 'language',
		},
	});
	$c->stash->{locales} = {};
	my $l;
	for ($c->stash->{token_context}->languages) {
		$l = $_;
		my @uloc = grep { $l->locale eq $_ } keys %{$c->user->locales};
		my $u; $u = $c->user->locales->{$uloc[0]} if @uloc;
		$c->stash->{locale} = $u->language->locale if $u && !$c->stash->{locale};
		$c->stash->{locales}->{$l->locale} = {
			l => $l,
			u => $u,
		};
	}
	$c->stash->{locale} = $l->locale if !$c->stash->{locale};
	$c->stash->{language} = $c->stash->{locales}->{$c->stash->{locale}}->{l};
	$c->stash->{tokens} = $c->stash->{token_context}->search_related('tokens',{},{
		order_by => 'me.created',
		prefetch => { token_languages => {
			token_language_translations => {
				user => { user_languages => 'language' }
			}
		}},
		page => $c->stash->{page},
		rows => $c->stash->{pagesize},
	});
	$c->session->{locale}->{$c->action} = $c->stash->{locale};
}

__PACKAGE__->meta->make_immutable;

1;
