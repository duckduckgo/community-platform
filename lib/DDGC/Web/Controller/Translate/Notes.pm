package DDGC::Web::Controller::Translate::Notes;
# ABSTRACT:

use Moose;
BEGIN { extends 'Catalyst::Controller'; }

use DDGC::Config;
use Data::Printer;
use Path::Class;
use JSON;
use IO::All;
use DateTime;
use namespace::autoclean;

sub base :Chained('/translate/base') :PathPart('notes') :CaptureArgs(0) {
	my ( $self, $c ) = @_;
	if (!$c->user) {
		$c->response->redirect($c->chained_uri('My','login'));
		return $c->detach;
	}
	if (!$c->user || !$c->user->translation_manager) {
		$c->response->redirect($c->chained_uri('Root','index',{ admin_required => 1 }));
		return $c->detach;
	}
	$c->add_bc('Empty Notes Manager', $c->chained_uri('Translate::Notes','index'));
}

sub index :Chained('base') :PathPart('') :Args(0) {
	my ( $self, $c ) = @_;
	$c->bc_index;
	$c->stash->{token_domains} = [ $c->d->resultset('Token::Domain')->search({
		'tokens.notes' => [ undef, "" ],
	},{
		prefetch => [qw( tokens )],
		order_by => [ qw( tokens.msgid )],
	})->all ];
}

__PACKAGE__->meta->make_immutable;

1;
