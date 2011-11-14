package DDGC::Web::Controller::Base;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

sub base :Chained('/base') :PathPart('base') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
	my $headline_template = $c->req->action;
	$headline_template =~ s/^\/base/headline/;
	$c->stash->{headline_template} = $headline_template.'.tt';
}

sub captcha :Chained('base') :Args(0) {
	my ($self, $c) = @_;
	$c->create_captcha();
}

sub welcome :Chained('base') :Args(0) {
	my ($self, $c) = @_;
}

sub about :Chained('base') :Args(0) {
	my ($self, $c) = @_;
}

sub privacy :Chained('base') :Args(0) {
	my ($self, $c) = @_;
}

sub termsofuse :Chained('base') :Args(0) {
	my ($self, $c) = @_;
}

__PACKAGE__->meta->make_immutable;

1;
