package DDGC::Web::Controller::Blog;

use Moose;
use namespace::autoclean;
use POSIX qw( ceil );

BEGIN {extends 'Catalyst::Controller'; }

sub base :Chained('/base') :PathPart('blog') :CaptureArgs(0) {
	my ( $self, $c ) = @_;
	push @{$c->stash->{template_layout}}, 'blog/base.tx';
	$c->stash->{topics} = $c->d->blog->topics;
        $c->add_bc("Blog", $c->chained_uri('Blog', 'index'));
}

sub index :Chained('base') :PathPart('') :Args(0) {
	my ( $self, $c ) = @_;
	my $pagesize = 5;
	my $page = $c->req->params->{page} ? $c->req->params->{page} : 1;
	$c->stash->{posts_days} = $c->d->blog->posts_by_day($page,$pagesize);
	my @posts = map { @{$_} } @{$c->stash->{posts_days}};
	$c->stash->{pagecount} = ceil(scalar @posts / $pagesize);
        $c->bc_index;
}

sub topic :Chained('base') :Args(1) {
	my ( $self, $c, $topic ) = @_;
	my $pagesize = 5;
	my $page = $c->req->params->{page} ? $c->req->params->{page} : 1;
	$c->stash->{posts_days} = $c->d->blog->topic_posts_by_day($topic,$page,$pagesize);
	unless ($c->stash->{posts_days})  {
		$c->response->redirect($c->chained_uri('Blog','index'));
		return $c->detach;
	}
	my @posts = map { @{$_} } @{$c->stash->{posts_days}};
	$c->stash->{pagecount} = ceil(scalar @posts / $pagesize);
}

sub post_base :Chained('base') :PathPart('') :CaptureArgs(1) {
	my ( $self, $c, $uri ) = @_;
	$c->stash->{post} = $c->d->blog->get_post($uri);
	unless ($c->stash->{post})  {
		$c->response->redirect($c->chained_uri('Blog','index'));
		return $c->detach;
	}
        $c->add_bc($c->stash->{post}{title}, "");
}

sub post :Chained('post_base') :PathPart('') :Args(0) {
	my ( $self, $c ) = @_;
}

1;
