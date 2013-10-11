package DDGC::Web;
# ABSTRACT: 

use Moose;
use Carp qw( croak );

use Catalyst::Runtime 5.90;

use Catalyst qw/
    ConfigLoader
    Static::Simple
	Session
	Session::Store::File
	Session::State::Cookie
	Authentication
	Authorization::Roles
	ChainedURI
	Captcha
	StackTrace
	ErrorCatcher
	CustomErrorMessage
	RunAfterRequest
/;

extends 'Catalyst';

use DDGC::Config;
use Class::Load ':all';
use Digest::MD5 qw( md5_hex );

use DDGC::Web::Wizard::Unvoted;
use DDGC::Web::Wizard::Untranslated;
use DDGC::Web::Wizard::UnvotedAll;
use DDGC::Web::Wizard::UntranslatedAll;
use DDGC::Web::Table;

use namespace::autoclean;

our $VERSION ||= '0.0development';

__PACKAGE__->config(
    name => 'DDGC::Web',
    disable_component_resolution_regex_fallback => 1,
	using_frontend_proxy => 1,
	default_view => 'Xslate',
	encoding => 'UTF-8',
	stacktrace => {
		enable => $ENV{DDGC_ACTIVATE_ERRORCATCHING}||0,
	},
	'Plugin::ErrorCatcher' => {
		enable => $ENV{DDGC_ACTIVATE_ERRORCATCHING}||0,
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
	'custom-error-message' => {
		'error-template' => 'error.tx',
		'content-type' => 'text/html; charset=utf-8',
		'view-name' => 'Xslate',
		'response-status' => 500,
	},
	'Plugin::Session' => {
		expires => 21600,
		dbic_class => 'DDGC::Session',
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
sub ddgc { shift->d(@_) }

sub next_form_id {
	my ( $c ) = @_;
	my $last_id = $c->session->{last_form_id} || int(rand(1_000_000));
	my $next_id = $last_id + int(rand(1_000));
	$c->session->{last_form_id} = $next_id;
	return $next_id;
}

sub set_new_action_token {
	my ( $c ) = @_;
	$c->session->{action_token} = md5_hex(int(rand(1_000_000)));
}

sub check_action_token {
	my ( $c ) = @_;
	return $c->stash->{action_token_checked} if defined $c->stash->{action_token_checked};
	return 0 unless defined $c->req->params->{action_token};
	if ($c->session->{action_token} eq $c->req->params->{action_token}) {
		$c->stash->{action_token_checked} = 1;
	} else {
		$c->stash->{action_token_checked} = 0;
	}
	$c->set_new_action_token;
	return $c->stash->{action_token_checked};
}

sub require_action_token {
	my ( $c ) = @_;
	die "No action token on submit" unless defined $c->stash->{action_token_checked};
	die "Invalid action token" unless $c->stash->{action_token_checked};
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
	$c->stash->{pagesize_options} = [qw( 1 5 10 20 40 50 100 )];
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

sub done {
	my ( $c ) = @_;
	$c->wiz_done;
}

sub table {
	my ( $c, $resultset, $u, $columns, %args ) = @_;
	my $class = defined $args{class}
		? delete $args{class}
		: "DDGC::Web::Table";
	return $class->new(
		c => $c,
		u => $u,
		resultset => $resultset,
		columns => $columns,
		%args,
	);
}

sub wiz_die { die "Wizard is running" unless shift->wiz_running }

sub wiz_start {
	my ( $c, $wizard, %options ) = @_;
	$c->log->debug('Wizard has wiz_start') if $c->debug;
	my $class = 'DDGC::Web::Wizard::'.$wizard;
	$c->session->{'wizard'} = $class->new(%options);
	return $c->wiz->next($c);
}

sub wiz {
	my $c = shift;
	return unless $c->wiz_running;
	return $c->session->{'wizard'};
}

sub wiz_check {
	my $c = shift;
	if ($c->session->{wizard_finished}) {
		$c->stash->{wizard_finished} = 1;
		delete $c->session->{wizard_finished};
	}
	return unless $c->wiz_running;
	return unless $c->wiz->can('check');
	return $c->wiz->check($c);
}

sub wiz_post_check {
	my $c = shift;
	return unless $c->wiz_running;
	return unless $c->wiz->can('post_check');
	return $c->wiz->post_check($c);
}

sub wiz_running { defined shift->session->{'wizard'} }

sub wiz_inside {
	my $c = shift;
	return 0 unless $c->wiz_running;
	return $c->wiz->inside;
}

sub wiz_outside {
	my $c = shift;
	return 0 unless $c->wiz_running;
	return $c->wiz->inside ? 0 : 1;
}

sub wiz_step {
	my $c = shift;
	return unless $c->wiz_running;
	return $c->wiz->next_step(1);
}

sub wiz_finished {
	my $c = shift;
	$c->wiz_die;
	$c->session->{wizard_finished} = 1;
	delete $c->session->{'wizard'};
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

no Moose;
__PACKAGE__->meta->make_immutable( replace_constructor => 1 );
