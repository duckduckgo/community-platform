package DDGC::Web;
use Moose;
use namespace::autoclean;
use Carp qw( croak );

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
	StackTrace
	ErrorCatcher
	CustomErrorMessage
/;

extends 'Catalyst';

use DDGC::Config;

our $VERSION ||= '0.0development';

__PACKAGE__->config(
    name => 'DDGC::Web',
    disable_component_resolution_regex_fallback => 1,
	using_frontend_proxy => 1,
	default_view => 'Xslate',
	encoding => 'utf8',
	stacktrace => {
		enable => $ENV{DDGC_ACTIVATE_ERRORCATCHING} ? 1 : 0,,
	},
	'Plugin::ErrorCatcher' => {
		enable => $ENV{DDGC_ACTIVATE_ERRORCATCHING} ? 1 : 0,
		emit_module => 'Catalyst::Plugin::ErrorCatcher::Email',
	},
	'Plugin::ErrorCatcher::Email' => {
		to => 'getty@duckduckgo.com',
		from => 'noreply@dukgo.com',
		subject => '[DuckDuckGo Community] %p %l CRASH!!!',
		use_tags => 1,
	},
	'Plugin::Static::Simple' => {
		dirs => [
			'root'
		],
		ignore_extensions => [ qw/tmpl tt tt2 tx/ ],
	},
	authentication => {
		default_realm => 'users',
		realms => {
			users => {
				credential => {
					class			=> 'Password',
					password_type	=> 'self_check',
				},
				store => {
					class			=> '+DDGC::Web::Authentication::Store::DDGC',
				},
			},
		},
	},
	# doesnt work like supposed :(
	# 'Plugin::ErrorCatcher' => {
		# emit_module => 'Catalyst::Plugin::ErrorCatcher::Email',
	# },
	# 'Plugin::ErrorCatcher::Email' => {
		# to => 'getty@duckduckgo.com',
		# from => 'noreply@dukgo.com',
		# use_tags => 1,
		# subject => '[%n %V] Report from %h; %F, line %l',
	# },
	'custom-error-message' => {
		'error-template' => 'error.tx',
		'content-type' => 'text/html; charset=utf-8',
		'view-name' => 'Xslate',
		'response-status' => 500,
	},
	'Plugin::Session' => {
		expires => 21600,
	},
	'Plugin::Captcha' => {
		session_name => 'captcha_string',
		new => {
			font       => __PACKAGE__->path_to('share','annifont.ttf'),
			width      => 200,
			height     => 90,
			ptsize     => 45,
			lines      => 2,
			thickness  => 3,
			rndmax     => 3,
		},
		create => [qw/ttf rect/],
		particle => [3000],
		out => {force => 'jpeg'}
	},
);

sub localize {
	my $c = shift;
	# thanks to perigrin for this
	return sprintf($_[0], @_[1, $#_]);
}

sub d {
	my ( $c, @args ) = @_;
	return $c->model('DDGC') if !@args;
	return $c->model('DDGC::'.join('::',@args));
}

sub pager_init {
	my ( $c, $key, $default_pagesize ) = @_;
	$key = $c->action if !$key;
	$default_pagesize = 20 if !$default_pagesize;
	$c->session->{pager} = {} if !$c->session->{pager};
	$c->session->{pager}->{$key} = {} if !$c->session->{pager}->{$key};
	if ($c->req->params->{pagesize} && $c->req->params->{pagesize} != $c->session->{pager}->{$key}->{pagesize}) {
		$c->stash->{page} = 1;
	} else {
		$c->stash->{page} = $c->req->params->{page} ? $c->req->params->{page} : 1;
	}
	$c->stash->{pagesize} = $c->req->params->{pagesize} ? $c->req->params->{pagesize} :
		$c->session->{pager}->{$key}->{pagesize} ? $c->session->{pager}->{$key}->{pagesize} : $default_pagesize;
	$c->stash->{pagesize_options} = [qw( 5 10 20 40 50 100 )];
	$c->session->{pager}->{$key}->{pagesize} = $c->stash->{pagesize};
#	$c->session->{pager}->{$key}->{page} = $c->stash->{page};
}

sub add_bc {
	my ( $c, $text, $link ) = @_;
	$c->stash->{breadcrumb} = [] unless $c->stash->{breadcrumb};
	my @bc = @{$c->stash->{breadcrumb}};
	if (@bc) {
		my $last_index = (scalar @bc)-1;
		croak "Breadcrumb already finished" unless $bc[$last_index]->{link};
	}
	push @{$c->stash->{breadcrumb}}, {
		text => $text,
		link => $link,
	};
}

sub bc_index {
	my ( $c ) = @_;
	croak "No breadcrumb" unless $c->stash->{breadcrumb};
	my @bc = @{$c->stash->{breadcrumb}};
	my $last_index = (scalar @bc)-1;
	croak "Breadcrumb already finished" unless $bc[$last_index]->{link};
	$c->stash->{breadcrumb}[$last_index]->{link} = undef;
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
