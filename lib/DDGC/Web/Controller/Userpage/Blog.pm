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
		($c->user && $c->user->id == $c->stash->{user}->id) ? () : ( live => 1 ),
	});
	$c->stash->{blog_controller} = 'Userpage::Blog';
	$c->add_bc($c->stash->{user}->username.' Blog', $c->chained_uri('Userpage::Blog', 'index',$c->stash->{user}->username));
}

1;
