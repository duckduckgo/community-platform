package DDGC::Web::Controller::Duckpan;
# ABSTRACT:

use Moose;
use namespace::autoclean;

use DDGC::Config;
use Dist::Data;
use Path::Class;
use Pod::Simple::XHTML;
use Data::Dumper;

BEGIN {extends 'Catalyst::Controller'; }

sub base :Chained('/base') :PathPart('duckpan') :CaptureArgs(0) {
	my ( $self, $c ) = @_;
	$c->stash->{title} = 'DuckPAN';
	$c->stash->{duckpan} = $c->d->duckpan;
}

sub logged_in :Chained('base') :PathPart('') :CaptureArgs(0) {
	my ( $self, $c ) = @_;
	if (!$c->user) {
		$c->response->redirect($c->chained_uri('My','login'));
		return $c->detach;
	}
}

sub upload :Chained('logged_in') :Args(0) {
	my ( $self, $c ) = @_;
	eval {
		$c->add_bc('Upload');
		if (!$c->user) {
			$c->res->code(403);
			$c->d->errorlog("No user");
			$c->stash->{no_user} = 1;
			return $c->detach;
		}
		my $uploader = $c->user->username;
		my $upload = $c->req->upload('pause99_add_uri_httpupload');
		my $filename = $c->d->config->cachedir.'/'.$upload->filename;
		$upload->copy_to($filename);
		my $upload_user = $c->d->rs('User')->search({ username => 'ddgc' })->one_row // $c->user;
		my $return = $c->d->duckpan->add_user_distribution($upload_user,$filename);
		my $return_ref = ref $return;
		if ($return_ref eq 'DDGC::DB::Result::DuckPAN::Release') {
			$c->stash->{duckpan_release} = $return;
		} else {
			$c->stash->{duckpan_error} = $return || "Let's just say something broke.";
			$c->res->code(403);
			$c->d->errorlog($c->stash->{duckpan_error});
		}
	};
	if ($@) {
		$c->res->code(403);
		$c->d->errorlog("DuckPAN 403 - " . $@);
		$c->stash->{duckpan_error} = $@;
	}
	if (defined $c->stash->{duckpan_error}) {
		$c->stash->{subject} = "Error on release!"
	} else {
		$c->stash->{subject} = "Successfully uploaded ".
			$c->stash->{duckpan_release}->name." ".
			$c->stash->{duckpan_release}->version;
	}
	$c->d->postman->template_mail(
		1,
		$c->user->email,
		'"DuckPAN Indexer" <noreply@duckduckgo.com>',
		'[DuckPAN] '.$c->stash->{subject},
		'duckpan',
		$c->stash,
		Cc => $c->d->config->error_email,
	);
}

__PACKAGE__->meta->make_immutable;

1;
