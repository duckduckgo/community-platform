package DDGC::Web::Controller::Admin::Token;
use Moose;
use namespace::autoclean;

use DDGC::Config;

BEGIN {extends 'Catalyst::Controller'; }

sub base :Chained('/admin/base') :PathPart('token') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
}

sub index :Chained('base') :PathPart('') :Args(0) {
    my ( $self, $c ) = @_;
	$c->stash->{token_contexts} = [$c->model('DB::Token::Context')->search({})->all];
	for my $tc (@{$c->stash->{token_contexts}}) {
		my $p = 'token_context_'.$tc->id.'_';
		if ($c->req->params->{$p.'delete'}) {
			$tc->delete;
		} elsif ($c->req->params->{save_token_contexts}) {
			$tc->name($c->req->params->{$p.'name'}) if $c->req->params->{$p.'name'};
			$tc->update;
		}
	}
	my %new;
	if ($c->req->params->{save_token_contexts}) {
		$new{'name'} = $c->req->params->{'token_context_0_name'} if $c->req->params->{'token_context_0_name'};
		push @{$c->stash->{token_contexts}}, $c->model('DB::Token::Context')->create(\%new) if (%new);
	}
}

__PACKAGE__->meta->make_immutable;

1;
