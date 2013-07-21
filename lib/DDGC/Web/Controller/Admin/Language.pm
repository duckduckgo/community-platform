package DDGC::Web::Controller::Admin::Language;
# ABSTRACT: Language administration web controller class

use Moose;
BEGIN { extends 'Catalyst::Controller'; }

use namespace::autoclean;

sub base :Chained('/admin/base') :PathPart('language') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
    $c->add_bc('Language editor', $c->chained_uri('Admin::Language','index'));
}

sub index :Chained('base') :PathPart('') :Args(0) {
    my ( $self, $c ) = @_;
    $c->bc_index;
	$c->stash->{languages} = $c->d->rs('Language')->search({});

	my @keys = qw/
		name_in_english
		name_in_local
		lang_in_local
		locale
		svg1
		svg2
		nplurals
		plural
		rtl
	/;
	$c->stash->{language_keys} = \@keys;
	# for my $l (@{$c->stash->{languages}}) {
	# 	my $p = 'language_'.$l->id.'_';
	# 	if ($c->req->params->{$p.'delete'}) {
	# 		$l->delete;
	# 	} elsif ($c->req->params->{save_languages}) {
	# 		for (@keys) {
	# 			$l->$_($c->req->params->{$p.$_}) if defined $c->req->params->{$p.$_};
	# 		}
	# 		$l->update;
	# 	}
	# }
	# my %new;
	# if ($c->req->params->{new_language}) {
	# 	for (@keys) {
	# 		$new{$_} = $c->req->params->{'language_0_'.$_} if defined $c->req->params->{'language_0_'.$_};
	# 	}
	# 	push @{$c->stash->{languages}}, $c->d->rs('Language')->create(\%new) if (%new);
	# }
}

no Moose;
__PACKAGE__->meta->make_immutable;
