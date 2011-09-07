package DDGC::Web::View::TT;

use Moose;

extends 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    render_die => 1,
	START_TAG => '<@',
	END_TAG => '@>',
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
