package DDGC::Web::Controller::Blog;

use Moose;
use namespace::autoclean;
use POSIX qw( ceil );

BEGIN {extends 'Catalyst::Controller'; }

sub base :Chained('/base') :PathPart('blog') :CaptureArgs(0) {
	my ( $self, $c ) = @_;
	$c->stash->{page_class} = "page-blog texture";
	push @{$c->stash->{template_layout}}, 'blog/base.tx';
	$c->stash->{topics} = $c->d->blog->topics;
	$c->add_bc("Blog", $c->chained_uri('Blog', 'index'));
}

sub index_base :Chained('base') :PathPart('') :CaptureArgs(0) {
	my ( $self, $c ) = @_;
	my $pagesize = 5;
	my $page = $c->req->params->{page} ? $c->req->params->{page} : 1;
	$c->stash->{posts_days} = $c->d->blog->posts_by_day($page,$pagesize);
	my @posts = map { @{$_} } @{$c->stash->{posts_days}};
	$c->stash->{posts} = \@posts;
	$c->stash->{pagecount} = ceil(scalar @posts / $pagesize);
	$c->bc_index;
	$c->stash->{title} = 'Latest blog posts';
}

sub index :Chained('index_base') :PathPart('') :Args(0) {
	my ( $self, $c ) = @_;
}

sub index_rss :Chained('index_base') :PathPart('rss') :Args(0) {
	my ( $self, $c ) = @_;
	$c->stash->{feed} = $self->posts_to_feed($c,@{$c->stash->{posts}});
	$c->forward('View::Feed');
	$c->forward( $c->view('Feed') );
}

sub topic_base :Chained('base') :PathPart('topic') :CaptureArgs(1) {
	my ( $self, $c, $topic ) = @_;
	my $pagesize = 5;
	my $page = $c->req->params->{page} ? $c->req->params->{page} : 1;
	$c->stash->{posts_days} = $c->d->blog->topic_posts_by_day($topic,$page,$pagesize);
	unless ($c->stash->{posts_days})  {
		$c->response->redirect($c->chained_uri('Blog','index'));
		return $c->detach;
	}
	my @posts = map { @{$_} } @{$c->stash->{posts_days}};
	$c->stash->{posts} = \@posts;
	$c->stash->{pagecount} = ceil(scalar @posts / $pagesize);
	$c->stash->{title} = 'All topic related blog posts';
}

sub topic :Chained('topic_base') :PathPart('') :Args(0) {
	my ( $self, $c ) = @_;
}

sub topic_rss :Chained('topic_base') :PathPart('rss') :Args(0) {
	my ( $self, $c ) = @_;
	$c->stash->{feed} = $self->posts_to_feed($c,@{$c->stash->{posts}});
	$c->forward( $c->view('Feed') );
}

sub posts_to_feed {
	my ( $self, $c, @posts ) = @_;
	$c->stash->{feed} = {
		format      => 'Atom',
		id          => $c->req->uri,
		title       => $c->stash->{title},
		#description => $description,
		link        => $c->req->uri,
		modified    => DateTime->now,
		entries => [
			map {{
				id       => $c->chained_uri('Blog', 'post', $_->uri),
				link     => $c->chained_uri('Blog', 'post', $_->uri),
				title    => $_->title,
				modified => $_->date,
				content  => $_->description,
			}} @posts
		],
	};
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
	$c->stash->{title} = $c->stash->{post}->title;
}

1;
