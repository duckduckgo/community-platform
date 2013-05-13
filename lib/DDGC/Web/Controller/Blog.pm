package DDGC::Web::Controller::Blog;

use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

sub base :Chained('/base') :PathPart('blog') :CaptureArgs(0) {
	my ( $self, $c ) = @_;
	push @{$c->stash->{template_layout}}, 'blog/base.tx';
}

sub index :Chained('base') :PathPart('') :Args(0) {
	my ( $self, $c ) = @_;
	#$c->stash->{entries} = $c->d->blog->list_entries;
}

sub topic :Chained('base') :Args(1) {
	my ( $self, $c, $topic ) = @_;
	# $c->stash->{entries} = $c->d->blog->get_topical_entries($topic);
	# unless ($c->stash->{entries})  {
	# 	$c->response->redirect($c->chained_uri('Blog','index'));
	# 	return $c->detach;
	# }
}

sub post_base :Chained('base') :PathPart('') :CaptureArgs(1) {
	my ( $self, $c, $post ) = @_;
	#$c->stash->{post} = $c->d->blog->list_entry($post);
}

sub post :Chained('post_base') :PathPart('') :Args(0) {
	my ( $self, $c, $blog_entry_url ) = @_;
	#$c->stash->{url} = $blog_entry_url;
	#$c->stash->{entry} = $c->d->blog->list_entry($blog_entry_url);
}

1;
