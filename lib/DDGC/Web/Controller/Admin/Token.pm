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
	$c->stash->{token_domains} = [$c->model('DB::Token::Domain')->search({})->all];
	for my $tc (@{$c->stash->{token_domains}}) {
		my $p = 'token_domain_'.$tc->id.'_';
		if ($c->req->params->{$p.'delete'}) {
			$tc->delete;
		} elsif ($c->req->params->{save_token_domains}) {
			$tc->name($c->req->params->{$p.'name'}) if $c->req->params->{$p.'name'};
			$tc->update;
		}
	}
	my %new;
	if ($c->req->params->{save_token_domains}) {
		$new{'name'} = $c->req->params->{'token_domain_0_name'} if $c->req->params->{'token_domain_0_name'};
		push @{$c->stash->{token_domains}}, $c->model('DB::Token::Domain')->create(\%new) if (%new);
	}
}

__PACKAGE__->meta->make_immutable;

1;
