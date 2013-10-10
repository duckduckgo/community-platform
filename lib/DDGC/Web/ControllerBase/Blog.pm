package DDGC::Web::ControllerBase::Blog;
# ABSTRACT: Role for Web::Controller of Blogs

use Moose;
use namespace::autoclean;
BEGIN { extends 'Catalyst::Controller'; }

use JSON;

sub pagesize { 20 }

sub blog_base :Chained('base') :PathPart('') :CaptureArgs(0) {
	my ( $self, $c ) = @_;
	my $blog_rs = $c->stash->{blog_resultset};
	die "require blog_resultset in stash" unless defined $blog_rs;
	$c->stash->{blog_topics} = $blog_rs->topics;
}

sub postlist_base :Chained('blog_base') :PathPart('') :CaptureArgs(0) {
	my ( $self, $c ) = @_;
	push @{$c->stash->{template_layout}}, 'blog/posts.tx';
    $c->pager_init($c->action,$self->pagesize);
}

sub postlist_resultset {
	my ( $self, $c ) = @_;
	$c->stash->{posts_resultset} = $c->stash->{blog_resultset}->most_recent_updated
	    ->search_rs({},{
		page => $c->stash->{page},
		rows => $c->stash->{pagesize},
		prefetch => 'user',
	});
}

sub postlist_view {
	my ( $self, $c ) = @_;
	$self->postlist_resultset($c);
	$c->stash->{posts} = $c->stash->{posts_resultset}->posts_by_day;
}

sub postlist_rss {
	my ( $self, $c ) = @_;
	$self->postlist_resultset($c);
	my @posts = $c->stash->{posts_resultset}->all;
	$c->stash->{feed} = $self->posts_to_feed($c,@posts);
	$c->forward('View::Feed');
	$c->forward( $c->view('Feed') );
}

sub index_base :Chained('postlist_base') :PathPart('') :CaptureArgs(0) {
	my ( $self, $c ) = @_;
	$c->bc_index;
}

sub index :Chained('index_base') :PathPart('') :Args(0) {
	shift->postlist_view(shift);
}

sub index_rss :Chained('index_base') :PathPart('rss') :Args(0) {
	shift->postlist_rss(shift);
}

sub topic_base :Chained('postlist_base') :PathPart('topic') :CaptureArgs(1) {
	my ( $self, $c, $topic ) = @_;
	$c->stash->{current_topic} = $topic;
	$c->stash->{title} = 'All topic related blog posts';
	$c->add_bc($c->stash->{title});
	my $json = json_string($topic);
	$c->stash->{blog_resultset} = $c->stash->{blog_resultset}->search({
		topics => { -like => "%".$json."%" }
	});
}

sub topic :Chained('topic_base') :PathPart('') :Args(0) {
	shift->postlist_view(shift);
}

sub topic_rss :Chained('topic_base') :PathPart('rss') :Args(0) {
	shift->postlist_rss(shift);
}

sub post_base :Chained('blog_base') :PathPart('') :CaptureArgs(1) {
	my ( $self, $c, $uri ) = @_;
	push @{$c->stash->{template_layout}}, 'blog/post.tx';
	$c->stash->{post} = $c->stash->{blog_resultset}->search({ uri => $uri })->first;
	unless ($c->stash->{post})  {
		$c->response->redirect($c->chained_uri('Blog','index'));
		return $c->detach;
	}
	$c->add_bc($c->stash->{post}->title, "");
}

sub post :Chained('post_base') :PathPart('') :Args(0) {
	my ( $self, $c ) = @_;
	$c->stash->{title} = $c->stash->{post}->title;
}

sub posts_to_feed {
	my ( $self, $c, @posts ) = @_;
	$c->stash->{feed} = {
		format      => 'Atom',
		id          => 'dukgo.com/'.$c->action,
		title       => $c->stash->{title},
		#description => $description,
		link        => $c->req->uri,
		modified    => DateTime->now,
		entries => [
			map {{
				id       => $_->id,
				link     => $c->chained_uri(@{$_->u}),
				title    => $_->title,
				modified => $_->updated,
				description => $_->teaser,
				content => $_->html,
			}} @posts
		],
	};
}

sub json_string { JSON->new->allow_nonref(1)->encode(shift) }

1;