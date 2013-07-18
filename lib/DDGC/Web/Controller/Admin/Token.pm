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
	$c->stash->{token_domains} = [$c->d->rs('Token::Domain')->search({})->all];
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
		push @{$c->stash->{token_domains}}, $c->d->rs('Token::Domain')->create(\%new) if (%new);
	}
}

no Moose;
__PACKAGE__->meta->make_immutable;
