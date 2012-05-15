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
	$c->stash->{title} = 'Welcome';
}

sub feedback :Chained('base') :Args(0) {
	my ($self, $c) = @_;
	$c->stash->{title} = 'Feedback';

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
			from        => 'noreply@dukgo.com',
			subject     => '[DuckDuckGo Community] New feedback',
			template	=> 'email/feedback.tt',
			charset		=> 'utf-8',
			content_type => 'text/plain',
		};

		$c->stash->{thanks_for_feedback} = 1;

		$c->forward( $c->view('Email::TT') );

	}

	$c->add_bc($c->stash->{title}, $c->chained_uri('Base','feedback'));

}

sub requestlanguage :Chained('base') :Args(0) {
	my ($self, $c) = @_;
	$c->stash->{title} = 'Request language';

	delete $c->stash->{headline_template};
	
	if ($c->req->params->{submit}) {

		my $error = 0;
	
		if ( !$c->req->params->{email} or !Email::Valid->address($c->req->params->{email}) ) {
			$c->stash->{no_valid_email} = 1;
			$error = 1;
		}

		if ( !$c->req->params->{name_in_english} ) {
			$c->stash->{required_name_in_english} = 1;
			$error = 1;
		}

		if ( !$c->req->params->{name_in_local} ) {
			$c->stash->{required_name_in_local} = 1;
			$error = 1;
		}
		
		if ($error) {

			$c->stash->{requestlanguage_email} = $c->req->params->{email};
			$c->stash->{requestlanguage_name_in_english} = $c->req->params->{name_in_english};
			$c->stash->{requestlanguage_name_in_local} = $c->req->params->{name_in_local};
			$c->stash->{requestlanguage_locale} = $c->req->params->{requestlanguage_locale};
			$c->stash->{requestlanguage_flagurl} = $c->req->params->{flagurl};

		} else {

			$c->stash->{email} = {
				to          => 'getty@duckduckgo.com',
				from        => 'noreply@dukgo.com',
				subject     => '[DuckDuckGo Community] New request for language',
				template	=> 'email/requestlanguage.tt',
				charset		=> 'utf-8',
				content_type => 'text/plain',
			};

			$c->stash->{thanks_for_languagerequest} = 1;
			$c->forward( $c->view('Email::TT') );

		}
	}

	$c->add_bc($c->stash->{title}, $c->chained_uri('Base','requestlanguage'));

}

__PACKAGE__->meta->make_immutable;

1;
