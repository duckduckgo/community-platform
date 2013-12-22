package DDGC::Web::Controller::Userpage::Blog;
# ABSTRACT:

use Moose;
BEGIN { extends 'DDGC::Web::ControllerBase::Blog'; }

use namespace::autoclean;

sub index_title { 'Latest User Blog posts' }

sub base :Chained('/userpage/user') :PathPart('blog') :CaptureArgs(0) {
	my ( $self, $c ) = @_;
  if (!$c->stash->{user}->admin) {
    $c->response->redirect($c->chained_uri('Root','index',{ admin_required => 1 }));
    return $c->detach;
  }
  $c->stash->{title} = 'User Blog of '.$c->stash->{user}->username;
	push @{$c->stash->{template_layout}}, 'userpage/blog/base.tx';
	$c->stash->{page_class} = "page-blog texture";
	$c->stash->{blog_resultset} = $c->stash->{user}->search_related('user_blogs',{
		($c->user && $c->user->id == $c->stash->{user}->id) ? () : ( live => 1 ),
	});
	$c->add_bc('Blog', $c->chained_uri('Userpage::Blog', 'index',$c->stash->{user}->username));
}

1;
