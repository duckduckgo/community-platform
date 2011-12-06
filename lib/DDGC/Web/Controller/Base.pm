package DDGC::Web::Controller::Base;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

use Email::Valid;

sub base :Chained('/base') :PathPart('base') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
	my $headline_template = $c->req->action;
	$headline_template =~ s/^\/base/headline/;
	$c->stash->{headline_template} = $headline_template.'.tt';
}

sub pulse :Chained('base') :Args(0) {
	my ($self, $c) = @_;
	$c->forward( $c->view('TT') );
}

sub captcha :Chained('base') :Args(0) {
	my ($self, $c) = @_;
	$c->create_captcha();
}

sub welcome :Chained('base') :Args(0) {
	my ($self, $c) = @_;
}

sub feedback :Chained('base') :Args(0) {
	my ($self, $c) = @_;
	delete $c->stash->{headline_template};
	
	if ($c->req->params->{submit} && $c->req->params->{feedback}) {

		if ( $c->req->params->{email} && !Email::Valid->address($c->req->params->{email}) ) {
			$c->stash->{no_valid_email} = 1;
			$c->stash->{feedback_email} = $c->req->params->{email};
			$c->stash->{feedback_feedback} = $c->req->params->{feedback};
			return;
		}
		
		$c->stash->{email} = {
			to          => 'getty@duckduckgo.com',
			from        => $c->req->params->{email} ? $c->req->params->{email} : 'noreply@duckduckgo.com',
			subject     => '[DuckDuckGo Community] New feedback',
			template	=> 'email/feedback.tt',
			charset		=> 'utf-8',
			content_type => 'text/plain',
		};

		$c->stash->{thanks_for_feedback} = 1;

		$c->forward( $c->view('Email::TT') );

	}

}

__PACKAGE__->meta->make_immutable;

1;
