package DDGC::Web::View::Email::TT;

use Moose;
extends 'Catalyst::View::Email::Template';

__PACKAGE__->config(
    stash_key       => 'email',
	default => {
		view => 'TT::Email',
		content_type => 'text/html',
		charset => 'utf-8',
	},
	# sender => {
		# mailer => 'Test',
	# },
);

no Moose;
__PACKAGE__->meta->make_immutable;

1;