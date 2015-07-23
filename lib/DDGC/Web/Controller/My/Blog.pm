package DDGC::Web::Controller::My::Blog;
# ABSTRACT: Blog editor

use Moose;
BEGIN { extends 'Catalyst::Controller'; }

use DateTime;
use DateTime::Format::RSS;
use namespace::autoclean;

sub base :Chained('/my/logged_in') :PathPart('blog') :CaptureArgs(0) {
	my ( $self, $c ) = @_;
	if (!$c->user->admin) {
		$c->response->redirect($c->chained_uri('Root','index',{ admin_required => 1 }));
		return $c->detach;
	}
	$c->add_bc('Blog Editor', $c->chained_uri('My::Blog','index'));
}

sub index :Chained('base') :PathPart('') :Args(0) {
	my ( $self, $c ) = @_;
	my $res = $c->d->ddgcr_get( $c, [ 'Blog', 'by_user' ], { id => $c->user->id } );
	$c->stash->{blog} = $res->{ddgcr}->{posts} if ( $res->is_success );
	$c->bc_index;
}

sub delete :Chained('base') :Args(1) {
	my ( $self, $c, $id ) = @_;

	$c->stash->{id} = $id;
	$c->stash->{post} = $c->d->rs('User::Blog')->find($id+0);

	unless ($c->user->admin || $c->stash->{post}->users_id eq $c->user->id) {
		$c->response->redirect($c->chained_uri('My::Blog','index'));
		return $c->detach;
	}

	if ($c->req->param('iamsure')) {
		$c->require_action_token;
		$c->stash->{post}->delete;
		$c->response->redirect($c->chained_uri('My::Blog','index'));
		return $c->detach;
	}
}

sub edit :Chained('base') :Args(1) {
	my ( $self, $c, $id_or_new ) = @_;

	$c->stash->{id} = $id_or_new;

	my $post;

	if ($id_or_new ne 'new' && $id_or_new+0 > 0) {
		my $id = $id_or_new+0;
		my $res = $c->d->ddgcr_get( $c, [ 'Blog', 'admin', 'post', 'raw' ], { id => $id } );
		$post = $res->{ddgcr}->{post} if ( $res->is_success );
		unless ($c->user->admin) {
			if ($post->{users_id} ne $c->user->id) {
				$c->response->redirect($c->chained_uri('My::Blog','index'));
				return $c->detach;
			}
		}
		$c->stash->{id} = $id;
	} else {
		$c->stash->{id} = 'new';
	}

	if ($c->req->param('save_blog')) {
		$c->require_action_token;

		my %values;

		for (qw( format title uri topics teaser content live fixed_date users_id )) {
			$values{$_} = $c->req->param($_);
		}

		$values{company_blog} = 1;

		my $ok = 1;
		my $res;

		if ($values{fixed_date}) {
			my $d = DateTime::Format::RSS->new->parse_datetime($values{fixed_date});
			if (!$d) {
				$c->stash->{error_fixed_date_invalid} = 1; $ok = 0;
			}
			else {
				$values{fixed_date} = $c->d->db->storage->datetime_parser->format_datetime($d);
			}
		}

		if ($values{topics} && $values{topics} !~ m/^[\w\- ,]+$/g) {
			$c->stash->{error_topics_invalid} = 1; $ok = 0;
		}

		if ($ok) {
			if ($post) {
				$values{id} = $c->stash->{id};
				$res = $c->d->ddgcr_post( $c, [ 'Blog', 'admin', 'post', 'update' ], \%values );
			} else {
				$res = $c->d->ddgcr_post( $c, [ 'Blog', 'admin', 'post', 'new' ], \%values );
			}
		}


		if ($res->is_success) {
			my $post = $res->{ddgcr}->{post};
			$c->response->redirect('/blog/post/' . join '/', ( $post->{id}, $post->{uri} ) );
			return $c->detach;
		} else {
			$c->stash->{not_ok} = 1;
			$c->stash->{post} = \%values;
			$c->stash->{errors} = $res->{ddgcr}->{errors}
				if ($res->{ddgcr}->{errors});
		}

	}

	if (!$post && $id_or_new ne 'new') {
		my $id = $id_or_new+0;
		$c->stash->{id} = $id;
	}

	if ($post && !defined $c->stash->{post}) {
		$c->stash->{post} = $post;
	}

	$c->add_bc($c->stash->{post}->{title} || "New blog post");
}

no Moose;
__PACKAGE__->meta->make_immutable;
