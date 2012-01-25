package DDGC::Web::Controller::Admin::Language;
use Moose;
use namespace::autoclean;

use DDGC::Config;

BEGIN {extends 'Catalyst::Controller'; }

sub base :Chained('/admin/base') :PathPart('language') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
}

sub index :Chained('base') :PathPart('') :Args(0) {
    my ( $self, $c ) = @_;
	$c->stash->{flaglist} = [$c->d->flaglist];
	$c->stash->{languages} = [$c->d->rs('Language')->search({})->all];
	my @keys = qw/ name_in_english name_in_local locale flagicon nplurals plural rtl/;
	for my $l (@{$c->stash->{languages}}) {
		my $p = 'language_'.$l->id.'_';
		if ($c->req->params->{$p.'delete'}) {
			$l->delete;
		} elsif ($c->req->params->{save_languages}) {
			for (@keys) {
				$l->$_($c->req->params->{$p.$_}) if defined $c->req->params->{$p.$_};
			}
			$l->update;
		}
	}
	my %new;
	if ($c->req->params->{new_language}) {
		for (@keys) {
			$new{$_} = $c->req->params->{'language_0_'.$_} if defined $c->req->params->{'language_0_'.$_};
		}
		push @{$c->stash->{languages}}, $c->d->rs('Language')->create(\%new) if (%new);
	}
}

__PACKAGE__->meta->make_immutable;

1;
