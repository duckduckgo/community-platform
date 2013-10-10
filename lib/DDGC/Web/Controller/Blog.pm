package DDGC::Web::Controller::Blog;
# ABSTRACT:

use Moose;
BEGIN {extends 'DDGC::Web::ControllerBase::Blog'; }

use namespace::autoclean;

sub index_title { 'Latest DuckDuckGo Blog posts' }

sub base :Chained('/base') :PathPart('blog') :CaptureArgs(0) {
	my ( $self, $c ) = @_;
  $c->stash->{title} = 'DuckDuckGo Blog';
	push @{$c->stash->{template_layout}}, 'blog/base.tx';
	$c->stash->{page_class} = "page-blog texture";
	$c->stash->{blog_resultset} = $c->d->rs('User::Blog')->company_blog(
	    $c->user_exists ? $c->user : undef
	);
	$c->add_bc('DuckDuckGo Blog posts', $c->chained_uri('Blog', 'index'));
}

1;
