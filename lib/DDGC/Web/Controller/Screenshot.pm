package DDGC::Web::Controller::Screenshot;
# ABSTRACT: Screenshot management

use Moose;
BEGIN { extends 'Catalyst::Controller'; }

sub base : Chained('/base') PathPart('screenshot') CaptureArgs(0) {
	my ( $self, $c ) = @_;
	if (!$c->user) {
		$c->response->redirect($c->chained_uri('My','login'));
		return $c->detach;
	}
}

sub manage : Chained('base') Args(1) {
	my ( $self, $c, $form_id ) = @_;
	if ($c->req->param('screenshot')) {
		my $upload = $c->req->uploads->{screenshot};
		my $media = $c->d->rs('Media')->create_via_file($c->user->db, $upload->tempname,{
			upload_filename => $upload->filename,
			content_type => $upload->type
		});
		my $screenshot = $c->d->rs('Screenshot')->create({
			media_id => $media->id,
		});
		$c->session->{thread_forms}->{$form_id}->{screenshots} = [] unless defined $c->session->{thread_forms}->{$form_id}->{screenshots};
		push @{$c->session->{thread_forms}->{$form_id}->{screenshots}}, $screenshot->id;
		$c->stash->{x} = {
			screenshot_id => $screenshot->id,
			media_url => $media->url,
		};
		$c->forward('View::JSON');
	}
	elsif ($c->req->param('delete_screenshot')) {
		my $delete_id = $c->req->param('delete_screenshot');
		$c->stash->{x} = {
			screenshot_id => $delete_id,
		};
		my $screenshot = $c->d->rs('Screenshot')->find($delete_id);
		if ($screenshot->media->users_id == $c->user->id || $c->user->admin) {
			$screenshot->media->delete;
		}
		else {
			$c->res->code(403);
			$c->stash->{x} = {
				error => 'Forbidden',
			};
			return $c->forward('View::JSON');
		}
		@{$c->session->{thread_forms}->{$form_id}->{screenshots}} = grep { $_ != $delete_id } @{$c->session->{thread_forms}->{$form_id}->{screenshots}};
		$c->forward('View::JSON');
    }
}

no Moose;
__PACKAGE__->meta->make_immutable;
