package DDGC::Web::Controller::Campaign::SubmitResponse;
# ABSTRACT: Retrieve / mail responses for Share Campaign

use Moose;
BEGIN { extends 'Catalyst::Controller'; }

use DDGC::Config;
use Time::Piece;
use Time::Seconds;
use Try::Tiny;

sub base :Chained('/') :PathPart('campaign') :CaptureArgs(0) {
	my ( $self, $c ) = @_;
	if (!$c->user) {
		$c->response->status(403);
		$c->stash->{x} = { ok => 0, errstr => "Not logged in!"};
		$c->forward( $c->view('JSON') );
		return $c->detach;
	}
	elsif ($c->user->responded_campaign($c->req->param('campaign_name'))) {
		$c->response->status(403);
		$c->stash->{x} = {
			ok => 0, already_responded => 1,
			errstr => "You already responded to these questions. Thank you!"
		};
		$c->forward( $c->view('JSON') );
		return $c->detach;
	}
}

sub respond : Chained('base') : PathPart('respond') : Args(0) {
	my ( $self, $c ) = @_;
	use DDP; p $c->req;

	my $to = $c->d->config->share_email // 'sharewear@duckduckgo.com';
	my $from = 'noreply@dukgo.com';
	my $subject = $c->req->param('campaign_name') . " response from " . $c->user->username;
	my $error = 0;

	try {
		$c->d->postman->template_mail(
			$to, $from, $subject, 'campaign', $c->stash
		);
	}
	catch {
		$error = 1;
	};

	if ($error) {
		$c->response->status(500);
		$c->stash->{x} = {
			ok => 0, mailer_error => 1,
			errstr => "Sorry, there was a problem submitting your response. Please try again later."
		};
		$c->forward( $c->view('JSON') );
		return $c->detach;
	}

	$c->user->set_responded_campaign($c->req->param('campaign_name'));

	$c->stash->{x} = {
		ok => 1,
		campaign_id => $c->req->param('campaign_id'),
	};
	$c->forward( $c->view('JSON') );
	return $c->detach;
}

__PACKAGE__->meta->make_immutable;

1;

