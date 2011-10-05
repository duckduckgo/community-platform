package DDGC::Web::Controller::Translate;
use Moose;
use namespace::autoclean;

use DDGC::Config;

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
    my ( $self, $c, $token_context_id ) = @_;
	$c->stash->{token_context} = $c->d->rs('Token::Context')->find($token_context_id);
	$c->stash->{page} = $c->req->params->{page} ? $c->req->params->{page} : 1;
	$c->stash->{pagesize} = $c->req->params->{pagesize} ? $c->req->params->{pagesize} : 20;
	$c->stash->{pagesize_options} = [qw( 10 20 40 50 100 )];
	$c->stash->{tokens} = $c->d->rs('Token::Context')->search_related('tokens',{},{
		order_by => 'tokens.created',
		page => $c->stash->{page},
		rows => $c->stash->{pagesize},
	});
}

__PACKAGE__->meta->make_immutable;

1;
