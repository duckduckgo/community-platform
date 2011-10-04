package DDGC::Web;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.90;

use Catalyst qw/
    ConfigLoader
    Static::Simple
	Session
	Session::Store::File
	Session::State::Cookie
	Unicode::Encoding
	Authentication
	Authorization::Roles
	ChainedURI
	Captcha
/;

extends 'Catalyst';

use DDGC::Config;

our $VERSION ||= '0.0development';

__PACKAGE__->config(
    name => 'DDGC::Web',
    disable_component_resolution_regex_fallback => 1,
	default_view => 'TT::Layouts',
	encoding => 'utf8',
	static => {
		dirs => [
			'root'
		],
		ignore_extensions => [ qw/tmpl tt tt2/ ],
	},
	authentication => {
		default_realm => 'users',
		realms => {
			users => {
				credential => {
					class			=> 'Password',
					password_field	=> 'password',
					password_type	=> 'clear',
				},
				store => {
					class			=> '+DDGC::Web::Authentication::Store::DDGC',
				},
			},
		},
	},
	'Plugin::Captcha' => {
		session_name => 'captcha_string',
		new => {
			font       => __PACKAGE__->path_to('share','annifont.ttf'),
			width      => 240,
			height     => 70,
			ptsize     => 34,
			lines      => 6,
			thickness  => 3,
			rndmax     => 6,
		},
		create => [qw/ttf rect/],
		particle => [3000],
		out => {force => 'jpeg'}
	},
	'View::Email' => {
		stash_key => 'email',
		default => {
			content_type => 'text/plain',
			charset => 'utf-8'
		},
		view => 'TT',
	},
	'View::JSON' => {
		expose_stash    => 'x',
	},
);

sub localize {
	my $c = shift;
	return join('|',@_);
}

# Start the application
__PACKAGE__->setup();

=head1 NAME

DDGC::Web - Catalyst based application

=head1 SYNOPSIS

    script/ddgc_web_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<DDGC::Web::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Torsten Raudssus

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
