package DDGC::Web::View::Email::Xslate;
# ABSTRACT: View to send out emails via Catalst (legacy, use DDGC::Postman)

use Moose;
extends 'Catalyst::View::Email::Template';

__PACKAGE__->config(
	default => {
		content_type => 'text/plain',
		charset => 'utf-8'
	},
	view => 'Xslate',
);

has ddgc => (
	is => 'ro',
	required => 1,
);

sub COMPONENT {
	my ($class, $app, $args) = @_;
	$args = $class->merge_config_hashes($class->config, $args);
	$args->{ddgc} = $app->d;
	return $class->new($args);
}

sub _build_mailer_obj {
	my ($self) = @_;
	return $self->ddgc->postman->transport;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;