package DDGC::Web::Controller::Wizard;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

sub base :Chained('/base') :PathPart('wizard') :CaptureArgs(0) {}

sub untranslated :Chained('base') :Args(2) {
	my ( $self, $c, $token_domain_key, $locale ) = @_;
	$c->wiz_start( Untranslated =>
		token_domain_key => $token_domain_key,
		locale => $locale,
	);
}

sub unvoted :Chained('base') :Args(2) {
	my ( $self, $c, $token_domain_key, $locale ) = @_;
}

no Moose;
__PACKAGE__->meta->make_immutable;
