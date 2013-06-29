package DDGC::Web::Controller::Userpage::Blog;

use Moose;
use namespace::autoclean;
BEGIN {extends 'DDGC::Web::ControllerBase::Blog'; }

sub index_title { 'Latest DuckDuckGo Blog posts' }

sub base :Chained('/userpage/base') :PathPart('blog') :CaptureArgs(0) {
	my ( $self, $c ) = @_;
	push @{$c->stash->{template_layout}}, 'userpage/blog/base.tx';
	$c->stash->{page_class} = "page-blog texture";
	$c->stash->{blog_resultset} = $c->stash->{user}->search_related('user_blogs',{
		company_blog => 0,
		($c->user && $c->user->id == $c->stash->{user}->id) ? () : ( live => 1 ),
	});
    $c->add_bc($self->index_title, $c->chained_uri('Blog', 'index'));
}

1;
