package DDGC::Web::Controller::Duckpan;
# ABSTRACT:

use Moose;
use namespace::autoclean;

use DDGC::Config;
use Dist::Data;
use Path::Class;
use Pod::Simple::XHTML;

BEGIN {extends 'Catalyst::Controller'; }

sub base :Chained('/base') :PathPart('duckpan') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
    $c->stash->{title} = 'DuckPAN';
    $c->stash->{duckpan} = $c->d->duckpan;
    $c->add_bc('DuckPAN', $c->chained_uri('duckpan','index'));
}

sub index :Chained('base') :PathPart('') :Args(0) {
    my ( $self, $c ) = @_;
}

sub logged_in :Chained('base') :PathPart('') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
    if (!$c->user) {
        $c->response->redirect($c->chained_uri('My','login'));
        return $c->detach;
    }
}

sub do :Chained('logged_in') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
}

sub upload :Chained('do') :Args(0) {
    my ( $self, $c ) = @_;
	if (!$c->user) {
		$c->res->code(403);
		$c->stash->{no_user} = 1;
		return $c->detach;
	}
	my $uploader = $c->user->username;
	my $upload = $c->req->upload('pause99_add_uri_httpupload');
	my $filename = $c->d->config->cachedir.'/'.$upload->filename;
	$upload->copy_to($filename);
	$c->stash->{duckpan_return} = $c->d->duckpan->add_user_distribution($c->user,$filename);
	$c->res->code(403) if (ref $c->stash->{duckpan_return} eq 'HASH');
}

__PACKAGE__->meta->make_immutable;

1;
