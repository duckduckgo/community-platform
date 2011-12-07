package DDGC::Web::View::Error;

use Moose;

extends 'Catalyst::View::TT';

use DDGC::Web;

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
	INCLUDE_PATH => [
		DDGC::Web->path_to('templates'),
	],
	START_TAG => '<@',
	END_TAG => '@>',
	ENCODING => 'utf-8',
);

=head1 NAME

DDGC::Web::View::TT - TT View for DDGC::Web

=head1 DESCRIPTION

TT View for DDGC::Web.

=head1 SEE ALSO

L<DDGC::Web>

=head1 AUTHOR

Torsten Raudssus,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
