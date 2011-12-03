package DDGC::Web::View::TT;

use Moose;

extends 'Catalyst::View::TT';

use Template::Stash::XS;

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
	PLUGIN_BASE => 'DDGC::Web::Template',
    render_die => 1,
	STASH => Template::Stash::XS->new,
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
