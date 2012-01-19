package DDGC::Web::Controller::Duckpan;
use Moose;
use namespace::autoclean;

use DDGC::Config;
use Dist::Data;
use Pod::HTMLEmbed;

BEGIN {extends 'Catalyst::Controller'; }

sub base :Chained('/base') :PathPart('duckpan') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
	$c->stash->{title} = 'DuckPAN';
	$c->stash->{duckpan} = $c->d->duckpan;
}

sub do :Chained('base') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
}

sub index :Chained('do') :Args(0) {
    my ( $self, $c ) = @_;
}

sub module :Chained('base') :CaptureArgs(1) {
    my ( $self, $c, $module ) = @_;
	$c->stash->{duckpan_module} = $module;
	$c->stash->{duckpan_dist_filename} = $c->stash->{duckpan}->modules->{$module};
	if ($c->stash->{duckpan_dist_filename}) {
		$c->stash->{duckpan_dist} = Dist::Data->new($c->stash->{duckpan_dist_filename});
	}
}

sub module_index :Chained('module') :PathPart('') :Args(0) {
    my ( $self, $c ) = @_;
	if ($c->stash->{duckpan_dist}) {
		my $p = Pod::HTMLEmbed->new;
		my $filename = $c->stash->{duckpan_dist}->packages->{$c->stash->{duckpan_module}}->{file};
		$c->stash->{module_pod} = $p->load($c->stash->{duckpan_dist}->file($filename));
	}
}

sub logged_in :Chained('do') :PathPart('') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
	if (!$c->user) {
		$c->response->redirect($c->chained_uri('My','login'));
		return $c->detach;
	}
}

sub upload :Chained('logged_in') :Args(0) {
    my ( $self, $c ) = @_;
	my $uploader = $c->user->username;
	my $upload = $c->req->upload('pause99_add_uri_httpupload');
	my $filename = $c->d->config->cachedir.'/'.$upload->filename;
	$upload->copy_to($filename);
	$c->d->duckpan->add_user_distribution($c->user,$filename);
}

__PACKAGE__->meta->make_immutable;

1;
