package DDGC::Web::View::TT;

use Moose;

extends 'Catalyst::View::TT';

use DDGC::Web;
use Template::Stash::XS;
use HTML::EasyForm;

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
	render_die => 1,
	INCLUDE_PATH => [
		DDGC::Web->path_to('templates'),
		HTML::EasyForm->template_tt_dir,
	],
	PLUGIN_BASE => 'DDGC::Web::Template',
	PRE_PROCESS => 'macros.tt',
	COMPILE_DIR => "/tmp/sycontent_web_template_cache_$<",
	STASH => Template::Stash::XS->new,
	RECURSION => 1,
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
