package DDGC::Web;
# ABSTRACT: 

use Moose;
use Carp qw( croak );

use Catalyst::Runtime 5.90;

use Catalyst qw/
    ConfigLoader
    Session
    Session::State::PSGI
    Session::Store::PSGI
    Static::Simple
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

use DateTime;
use DateTime::Format::HTTP;

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
		to => $ENV{DDGC_ERROR_EMAIL} // 'ddgc@duckduckgo.com',
		from => 'noreply@duck.co',
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
			github => {
				credential => {
					class           => 'Password',
					password_type   => 'clear',
					password_field  => 'github_access_token',
				},
				store => {
					class			=> '+DDGC::Web::Authentication::Store::DDGC',
				},
			}
		},
	},
	'custom-error-message' => {
		'error-template' => 'error.tx',
		'content-type' => 'text/html; charset=utf-8',
		'view-name' => 'Xslate',
		'response-status' => 500,
	},
	'Plugin::Captcha' => {
		session_name => 'captcha_string',
		new => {
			font       => __PACKAGE__->path_to('share','annifont.ttf'),
			width      => 220,
			height     => 90,
			ptsize     => 45,
			lines      => 3,
			thickness  => 3,
			rndmax     => 4,
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

sub get_uid {
	$_[0]->d->uid;
}

sub next_form_id {
	$_[0]->get_uid;
}

sub set_new_action_token {
	my ($c) = @_;
	$c->session->{action_token} = $c->get_uid;
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
		$c->stash->{page} = $c->req->params->{page} ? $c->req->params->{page}+0 : 1;
	}
	$c->stash->{pagesize} = $c->req->params->{pagesize} ? $c->req->params->{pagesize}+0 :
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

sub finalize_error {
	my $c = shift;
	my $msg = (ref $c->error eq 'ARRAY') ? join "\n", @{$c->error} : $c->error;
	$c->stash->{log_reference} = $c->d->errorlog($msg);
	$c->next::method();
}

sub _apply_session_to_req {
	my ( $c, $req ) = @_;
	$req->header(
		Cookie => 'ddgc_session=' . $c->req->env->{'psgix.session.options'}->{id},
	);
}
sub _ref_to_uri {
	my ( $route ) = @_;
	my $service = '/' . lc( shift @{$route} ) . '.json';
	my ( $uri ) = join  '/', @{$route};
	return "$service/$uri";
}

sub ddgcr_get {
	my ( $c, $route, $params ) = @_;
	$route = _ref_to_uri( $route ) if ( ref $route eq 'ARRAY' );

	my $req = HTTP::Request->new(
		GET => $c->uri_for( $route, $params )->canonical
	);
	$c->_apply_session_to_req( $req );

	my $res = $c->d->http->request( $req );
	$res->{ddgcr} = JSON::from_json( $res->decoded_content, { utf8 => 1 } );
	return $res;
}

sub ddgcr_post {
	my ( $c, $route, $data ) = @_;
	$route = _ref_to_uri( $route ) if ( ref $route eq 'ARRAY' );

	$data = JSON::to_json($data, { convert_blessed => 1, utf8 => 1 }) if ref $data;
	my $req = HTTP::Request->new(
		POST => $c->uri_for( $route )->canonical
	);
	$req->content_type( 'application/json' );
	$req->content( $data );
	$c->_apply_session_to_req( $req );

	my $res = $c->d->http->request( $req );
	$res->{ddgcr} = JSON::from_json( $res->decoded_content, { utf8 => 1 } );
	return $res;
}

sub return_if_not_modified {
	my ( $c, $dt ) = @_;
	$dt->set_formatter( 'DateTime::Format::HTTP' ) if $dt;
	my $if_modified_since = $c->req->header('If-Modified-Since');
	$if_modified_since =~ s/;.*$//;

	$c->response->header(
		'Last-Modified' => "$dt",
	);
	return if !$if_modified_since;

	my $if_modified_since_dt = DateTime::Format::HTTP->parse_datetime( $if_modified_since );

	if ( DateTime->compare( $dt, $if_modified_since_dt ) <= 0 ) {
		$c->response->headers->remove_header($_)
		    for ( qw/ Content-Type Content-Length Content-Disposition / );
		$c->response->status('304');
		return $c->detach;
	}

	return $c->detach if ( $c->request->method eq 'HEAD' );
}

sub nocache {
	my ( $c ) = @_;
	$c->response->header('Cache-Control' => 'no-cache, max-age=0, must-revalidate, no-store');
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
