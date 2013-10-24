package DDGC::Web::Controller::Cronjob;
# ABSTRACT: Trick controller todo cronjobs through web framework

use Moose;
use namespace::autoclean;

use DDGC::Config;

BEGIN {extends 'Catalyst::Controller'; }

sub base :Chained('/base') :PathPart('cronjob') :CaptureArgs(0) {
	my ( $self, $c ) = @_;
	if (defined $ENV{DDGC_EXECUTE_CRONJOBS}
			&& $ENV{DDGC_EXECUTE_CRONJOBS} eq 'YES'
			&& $c->req->address eq '127.0.0.1') {
		return;
	}
	$c->response->status(403);
	$c->response->body('Not allowed');
	return $c->detach;
}

sub index :Chained('base') :PathPart('') :Args {
	my ( $self, $c, @args ) = @_;
	if ($args[0] eq 'notify_cycle') {
		$self->notify_cycle($c,$args[1]);
	}
	$c->response->body('OK');
}

sub notify_cycle {
	my ( $self, $c, $cycle ) = @_;
}

__PACKAGE__->meta->make_immutable;

1;
