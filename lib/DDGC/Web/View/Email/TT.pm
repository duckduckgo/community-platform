package DDGC::Web::View::Email::TT;

use Moose;
extends 'Catalyst::View::Email::Template';

__PACKAGE__->config(
	default => {
		content_type => 'text/plain',
		charset => 'utf-8'
	},
	view => 'TT',
	# sender => {
		# mailer => 'Test',
	# },
);

no Moose;
__PACKAGE__->meta->make_immutable;

1;