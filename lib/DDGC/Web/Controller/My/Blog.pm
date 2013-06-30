package DDGC::Web::Controller::My::Blog;
# ABSTRACT: Userpage editor

use Moose;
BEGIN {extends 'Catalyst::Controller'; }

use DateTime;
use DateTime::Format::RSS;
use namespace::autoclean;

sub base :Chained('/my/logged_in') :PathPart('blog') :CaptureArgs(0) {
	my ( $self, $c ) = @_;
	$c->add_bc('Blog Editor', $c->chained_uri('My::Blog','index'));
}

sub index :Chained('base') :PathPart('') :Args(0) {
	my ( $self, $c ) = @_;
	$c->stash->{blog} = $c->user->blog;
	$c->bc_index;
}

sub edit :Chained('base') :Args(1) {
	my ( $self, $c, $id_or_new ) = @_;

	$c->stash->{id} = $id_or_new;

	my $post;

	if ($id_or_new ne 'new' && $id_or_new+0 > 0) {
		my $id = $id_or_new+0;
		$post = $c->d->rs('User::Blog')->find($id);
		unless ($c->user->admin) {
			if ($post->users_id ne $c->user->id) {
				$c->response->redirect($c->chained_uri('My::Blog','index'));
				return $c->detach;
			}
		}
		$c->stash->{id} = $id;
	} else {
		$c->stash->{id} = 'new';
	}

	if ($c->req->param('save_blog')) {

		my %values;

		for (qw( title uri topics teaser content live fixed_date )) {
			$values{$_} = $c->req->param($_);
		}

		if ($c->user->admin) {
			for (qw( company_blog raw_html )) {
				$values{$_} = $c->req->param($_) ? 1 : 0;
			}
		}

		my $ok = 1;

		if ($values{fixed_date}) {
			unless (DateTime::Format::RSS->new->parse_datetime($values{fixed_date})) {
				$c->stash->{error_fixed_date_invalid} = 1; $ok = 0; $ok = 0;
			}
		}

		if ($values{uri} !~ m/^[\w-]+$/g) {
			$c->stash->{error_uri_invalid} = 1; $ok = 0;
		}

		if ($values{topics} && $values{topics} !~ m/^[\w\- ,]+$/g) {
			$c->stash->{error_topics_invalid} = 1; $ok = 0;
		}

		if ($ok) {
			if ($post) {
				$post->update_via_form(\%values);
			} else {
				$post = $c->user->user_blogs_rs->create_via_form(\%values);
			}
			$c->response->redirect($c->chained_uri(@{$post->u}));
			return $c->detach;
		} else {
			$c->stash->{not_ok} = 1;
			$c->stash->{post} = \%values;
		}

	}

	if (!$post && $id_or_new ne 'new') {
		my $id = $id_or_new+0;
		$c->stash->{id} = $id;
	}

	if ($post && !defined $c->stash->{post}) {
		$c->stash->{post} = $post->form_values;
	}

	$c->add_bc($c->stash->{post}->{title} || "New blog post");
}

# sub json :Chained('base') :Args(0) {
# 	my ( $self, $c ) = @_;
# 	$c->stash->{x} = $c->stash->{blog}->export;
# 	$c->forward('View::JSON');
# }


__PACKAGE__->meta->make_immutable;

1;
