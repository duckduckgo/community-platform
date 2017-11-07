package DDGC;
# ABSTRACT: DuckDuckGo Community Platform

use Moose;

use DDGC::Config;
use DDGC::DB;
use DDGC::DuckPAN;
use DDGC::Asana;
use DDGC::PagerDuty;
use DDGC::XMPP;
use DDGC::Markup;
use DDGC::Envoy;
use DDGC::Postman;
use DDGC::Stats;
use DDGC::GitHub;
use DDGC::Forum;
use DDGC::Help;
use DDGC::Ideas;
use DDGC::Util::DateTime;

use IO::All;
use File::Spec;
use File::ShareDir::ProjectDistDir;
use Net::AIML;
use Text::Xslate qw( mark_raw );
use Class::Load qw( load_class );
use IPC::Run qw/ run timeout /;
use POSIX;
use Cache::FileCache;
use Cache::NullCache;
use LWP::UserAgent;
use HTTP::Request;
use Carp;
use Data::Dumper;
use String::Truncate 'elide';
use feature qw/ state /;
use Time::Piece;
use Data::UUID;
use Digest::MD5 'md5_hex';
use JSON;
use URI;
use namespace::autoclean;

our $VERSION ||= '0.000';

##############################################
# TESTING AND DEVELOPMENT, NOT FOR PRODUCTION
sub deploy_fresh {
	my ( $self ) = @_;

	die "Refusing to kill live database." if $self->is_live;

	$self->config->rootdir();
	$self->config->filesdir();
	$self->config->cachedir();

	$self->db->deploy;
	$self->db->resultset('User::Notification::Group')->update_group_types;
}
##############################################

####################################################################
#   ____             __ _                       _   _
#  / ___|___  _ __  / _(_) __ _ _   _ _ __ __ _| |_(_) ___  _ __
# | |   / _ \| '_ \| |_| |/ _` | | | | '__/ _` | __| |/ _ \| '_ \
# | |__| (_) | | | |  _| | (_| | |_| | | | (_| | |_| | (_) | | | |
#  \____\___/|_| |_|_| |_|\__, |\__,_|_|  \__,_|\__|_|\___/|_| |_|
#                         |___/

has config => (
	isa => 'DDGC::Config',
	is => 'ro',
	lazy_build => 1,
	handles => [qw(
		is_live
		is_view
	)],
);
sub _build_config { DDGC::Config->new }


####################################################################

has http => (
	isa => 'LWP::UserAgent',
	is => 'ro',
	lazy_build => 1,
);
sub _build_http {
	my $ua = LWP::UserAgent->new(
	($ENV{DDGC_PROSODY_USERHOST} && $ENV{DDGC_PROSODY_USERHOST} ne 'dukgo.com')
		? ( ssl_opts => { verify_hostname => 0 } )
		: (),
	);
	$ua->timeout(5);
	my $agent = (ref $_[0] ? ref $_[0] : $_[0]).'/'.$VERSION;
	$ua->agent($agent);
	return $ua;
}
has uuid => (
	isa => 'Data::UUID',
	is  => 'ro',
	lazy_build => 1,
);
sub _build_uuid { Data::UUID->new };
sub uid { md5_hex $_[0]->uuid->create_str . rand };

sub uri_for {
	my ( $self, $part, $params ) = @_;
	my $uri = URI->new( $self->config->web_base );

	$part =~ s{^/*}{/};
	$uri->path("$part");

	$uri->query_form($params) if $params;

	return ${ $uri->canonical };
}

############################################################
#  ____        _    ____            _
# / ___| _   _| |__/ ___| _   _ ___| |_ ___ _ __ ___  ___
# \___ \| | | | '_ \___ \| | | / __| __/ _ \ '_ ` _ \/ __|
#  ___) | |_| | |_) |__) | |_| \__ \ ||  __/ | | | | \__ \
# |____/ \__,_|_.__/____/ \__, |___/\__\___|_| |_| |_|___/
#                         |___/

# Database (DBIx::Class)
has db => (
	isa => 'DDGC::DB',
	is => 'ro',
	lazy_build => 1,
	handles => [qw(
		without_events
		get_by_i_param
	)],
);
sub _build_db { DDGC::DB->connect(shift) }
sub resultset { shift->db->resultset(@_) }
sub rs { shift->resultset(@_) }

# Asana access
has asana => (
	isa => 'DDGC::Asana',
	is => 'ro',
	lazy_build => 1,
);
sub _build_asana { DDGC::Asana->new({ ddgc => shift }) }

# Get current on-call
has pagerduty => (
	isa => 'DDGC::PagerDuty',
	is => 'ro',
	lazy_build => 1,
);
sub _build_pagerduty { DDGC::PagerDuty->new({ ddgc => shift }) }

# XMPP access interface
has xmpp => (
	isa => 'DDGC::XMPP',
	is => 'ro',
	lazy_build => 1,
);
sub _build_xmpp { DDGC::XMPP->new({ ddgc => shift }) }

# Markup Text parsing
has markup => (
	isa => 'DDGC::Markup',
	is => 'ro',
	lazy_build => 1,
);
sub _build_markup { DDGC::Markup->new({ ddgc => shift }) }

# Notification System
has envoy => (
	isa => 'DDGC::Envoy',
	is => 'ro',
	lazy_build => 1,
);
sub _build_envoy { DDGC::Envoy->new({ ddgc => shift }) }

# Mail System
has postman => (
	isa => 'DDGC::Postman',
	is => 'ro',
	lazy_build => 1,
	handles => [qw(
		mail
	)],
);
sub _build_postman { DDGC::Postman->new({ ddgc => shift }) }

# Access to the DuckPAN infrastructures (Distribution Management)
has duckpan => (
	isa => 'DDGC::DuckPAN',
	is => 'ro',
	lazy_build => 1,
);
sub _build_duckpan { DDGC::DuckPAN->new({ ddgc => shift }) }

has stats => (
	isa => 'DDGC::Stats',
	is => 'ro',
	lazy_build => 1,
);
sub _build_stats { DDGC::Stats->new({ ddgc => shift }) }

has github => (
	isa => 'DDGC::GitHub',
	is => 'ro',
	lazy_build => 1,
);
sub _build_github { DDGC::GitHub->new({ ddgc => shift }) }

has cache => (
	isa => 'Cache::Cache',
	is => 'ro',
	lazy_build => 1,
);
sub _build_cache {
	return $_[0]->config->no_cache
		? Cache::NullCache->new
		: Cache::FileCache->new({
				namespace => 'DDGC',
				cache_root => $_[0]->config->cachedir,
			});
}

##############################
# __  __    _       _
# \ \/ /___| | __ _| |_ ___
#  \  // __| |/ _` | __/ _ \
#  /  \\__ \ | (_| | ||  __/
# /_/\_\___/_|\__,_|\__\___|
# (Templating SubSystem)
#

has xslate => (
	isa => 'Text::Xslate',
	is => 'ro',
	lazy_build => 1,
);
sub _build_xslate {
	my $self = shift;
	my $xslate;
	my $obj2dir = sub {
		my $obj = shift;
		my $class = $obj->can('i') ? $obj->i : ref $obj;
                if ($class =~ m/^[a-z_]+$/) {
                        return $class;
                }
		if ($class =~ m/^DDGC::(DB::Result|DB::ResultSet|Web)::(.*)$/) {
			my $return = lc($2);
                        $return .= '_rs' if $1 eq 'DB::ResultSet';
			$return =~ s/::/_/g;
			return $return;
		}
		die "cant include ".$class." with i-function";
	};
	my $i_template_and_vars = sub {
		my $object = shift;
		my $subtemplate;
		my $no_templatedir;
		my $vars;
		if (ref $object) {
			$subtemplate = shift;
			$vars = shift;
		} elsif (!defined $object) {
			return '';
		} else {
			$no_templatedir = 1;
			$subtemplate = $object;
			my $next = shift;
			if (ref $next eq 'HASH') {
				$object = undef;
				$vars = $next;
			} else {
				$object = $next;
				$vars = shift;
			}
		}
		my $main_object;
		my @objects;
		push @objects, $object if $object;
		if (ref $object eq 'ARRAY') {
			$main_object = $object->[0];
			@objects = @{$object};
		} else {
			$main_object = $object;
		}
		my %current_vars = %{$xslate->current_vars};
		my $no_caller = delete $vars->{no_caller} ? 1 : 0;
		if (defined $current_vars{_} && !$no_caller) {
			$current_vars{caller} = $current_vars{_};
		}
		$current_vars{_} = $main_object;
		my $ref_main_object = ref $main_object;
		if ($main_object && $ref_main_object) {
			if ($main_object->can('meta')) {
				for my $method ( $main_object->meta->get_all_methods ) {
					if ($method->name =~ m/^i_(.*)$/) {
						my $name = $1;
						my $var_name = '_'.$name;
						my $func = 'i_'.$name;
						$current_vars{$var_name} = $main_object->$func;
					}
				}
			}
		}
		my @template = ('i');
		unless ($no_templatedir) {
			push @template, $obj2dir->($main_object);
		}
		push @template, $subtemplate ? $subtemplate : 'label';
		my %new_vars;
		for (@objects) {
			my $obj_dir = $obj2dir->($_);
			if (defined $new_vars{$obj_dir}) {
				if (ref $new_vars{$obj_dir} eq 'ARRAY') {
					push @{$new_vars{$obj_dir}}, $_;
				} else {
					$new_vars{$obj_dir} = [
						$new_vars{$obj_dir}, $_,
					];
				}
			} else {
				$new_vars{$obj_dir} = $_;
			}
		}
		for (keys %new_vars) {
			$current_vars{$_} = $new_vars{$_};
		}
		if ($vars) {
			for (keys %{$vars}) {
				$current_vars{$_} = $vars->{$_};
			}
		}
		return join('/',@template).".tx",\%current_vars;
	};
	$xslate = Text::Xslate->new({
		path => [$self->config->templatedir],
		cache_dir => $self->config->xslate_cachedir,
		suffix => '.tx',
		function => {

			# Functions to access the main model and some functions specific
			d => sub { $self },
			forum_user_filter => sub {
				my ($forum_id, $user) = @_;
				return 1 if (!DDGC::Config::forums->{$forum_id}->{'user_filter'});
				return 0 if (!$user);
				return DDGC::Config::forums->{$forum_id}->{'user_filter'}->($user);
			},
			cur_user => sub { $self->current_user },
			has_cur_user => sub { defined $self->current_user ? 1 : 0 },

			# Mark text as raw HTML
			r => sub { mark_raw(@_) },

			# general functions avoiding xslates problems
			call => sub {
				my $thing = shift;
				my $func = shift;
				$thing->$func;
			},
			call_if => sub {
				my $thing = shift;
				my $func = shift;
				$thing->$func if $thing;
			},
			replace => sub {
				my $source = shift;
				my $from = shift;
				my $to = shift;
				$source =~ s/$from/$to/g;
				return $source;
			},
			urify => sub {
                my $value = shift;
                $value = lc $value;
                $value =~ s/[^a-zA-Z]+/-/g;
                return $value;
            },

			floor => sub { floor($_[0]) },
			ceil => sub { ceil($_[0]) },

			# simple helper for userpage form management
			upf_view => sub { 'userpage/'.$_[1].'/'.$_[0]->view.'.tx' },
			upf_edit => sub { 'my/userpage/field/'.$_[0]->edit.'.tx' },
			#############################################

			# Duration display helper mapped, see DDGC::Util::DateTime
			dur => sub { dur(@_) },
			dur_precise => sub { dur_precise(@_) },
			#############################################

			i_template_and_vars => $i_template_and_vars,
			i => sub { mark_raw($xslate->render($i_template_and_vars->(@_))) },
			i_template => sub {
				my ( $template, $vars ) = $i_template_and_vars->(@_);
				return $template
			},

			results_event_userlist => sub {
				my %users;
				for ($_[0]->all) {
					if ($_->event->users_id) {
						unless (defined $users{$_->event->users_id}) {
							$users{$_->event->users_id} = $_->event->user;
						}
					}
				}
				return [values %users];
			},

			style => sub {
				my %style;
				my @styles = @_;
				while (@styles) {
					my $t_style = $self->template_styles->{shift @styles};
					if (ref $t_style eq 'HASH') {
						$style{$_} = $t_style->{$_} for keys %{$t_style};
					} elsif (ref $t_style eq 'ARRAY') {
						unshift @styles, @{$t_style};
					}
				}
				my $return = 'style="';
				$return .= $_.':'.$style{$_}.';' for (sort { length($a) <=> length($b) } keys %style);
				$return .= '"';
				return mark_raw($return);
			},

			username_gimmick => sub {
				mark_raw(substr($_[0],0,-2).'<i>'.substr($_[0],-2).'</i>')
			},

			hilight_token_placeholders => sub {
				$_[0] =~ s{(%\d?\$?[s|d])}{<span class="hilight-token">$1</span>}g;
				return mark_raw($_[0]);
			},

                        # String::Truncate's elide function
                        truncate => \&elide,

			p => sub { use DDP; return mark_raw( '<pre>' . p( $_[0] ) . '</pre>' ); },

		},
	});
	return $xslate;
}

sub template_styles {{
	'default' => {
		'font-family' => 'sans-serif',
	},
	'sub_text' => {
		'font-family' => 'sans-serif',
		'font-size' => '12px',
	},
	'signoff' => {
		'color' => '#999999',
	},
	'warning' => {
		'font-family' => 'sans-serif',
		'font-style' => 'normal',
		'font-size' => '11px',
		'color' => '#a8a8a8',
	},
	'site_title' => {
		'font-family' => 'sans-serif',
		'position' => 'relative',
		'text-align' => 'left',
		'line-height' => '1',
		'margin' => '0',
	},
	'site_maintitle' => {
		'font-weight' => 'bold',
		'font-size' => '21px',
		'padding-top' => '10px',
		'left' => '-1px',
	},
	'green' => {
		'font-style' => 'normal',
		'color' => '#48af04',
	},
	'site_subtitle' => {
		'font-weight' => 'normal',
		'color' => '#a0a0a0',
		'padding-top' => '4px',
		'padding-bottom' => '7px',
		'font-size' => '12px',
	},
	'msg_body' => {
		'border' => '1px solid #d7d7d7',
		'border-radius' => '5px',
		'max-width' => '800px',
	},
	'msg_header' => {
		'width' => '100%',
		'background-color' => '#f1f1f1',
		'border-bottom' => '1px solid #d7d7d7',
		'border-radius' => '5px 5px 0 0',
	},
	'msg_title' => {
		'font-family' => 'sans-serif',
		'font-weight' => 'normal',
		'font-size' => '28px',
		'color' => '#a0a0a0',
		'margin' => '0',
		'padding' => '9px 0',
	},
	'msg_content' => {
		'font-family' => 'sans-serif',
		'padding' => '10px 0',
		'background-color' => '#ffffff',
	},
	'msg_notification' => {
		'font-family' => 'sans-serif',
		'padding' => '0',
		'background-color' => '#ffffff',
	},
	'notification' => {
		'padding' => '10px 0',
		'font-family' => 'sans-serif',
		'width' => '100%',
		'border-bottom' => '1px solid #d7d7d7',
	},
	'notification_text' => {
		'font-family' => 'sans-serif',
		'font-size' => '14px',
	},
	'notification_icon' => {
		'width' => '40px',
		'height' => '40px',
		'outline' => 'none',
		'border' => 'none',
	},
	'notification_count' => {
		'padding' => '5px 0',
		'background-color' => '#fbfbfb',
		'font-family' => 'sans-serif',
		'width' => '100%',
		'border-bottom' => '1px solid #d7d7d7',
	},
	'notification_count_text' => {
		'margin' => '0',
		'padding-top' => '4px',
		'color' => '#a0a0a0',
		'font-weight' => 'bold',
		'font-size', => '16px',
	},
	'button' => {
		'font-family' => 'sans-serif',
		'font-size' => '14px',
		'border-radius' => '3px',
		'display' => 'block',
		'padding' => '0 12px',
		'height' => '28px',
		'line-height' => '28px',
		'text-align' => 'center',
		'text-decoration' => 'none',
		'color' => '#d7d7d7',
		'background-color' => '#ffffff',
		'border' => '1px solid #d7d7d7',
		'white-space' => 'nowrap',
	},
	'button_blue' => {
		'color' => '#4b8df8',
		'border-color' => '#4b8df8',
	},
	'button_green' => {
		'color' => '#48af04',
		'border-color' => '#48af04',
	},
	'view_link' => {
		'color' => '#d7d7d7',
		'font-size' => '60px',
		'display' => 'block',
		'text-align' => 'right',
		'text-decoration' => 'none',
		'line-height' => '35px',
		'height' => '40px',
		'overflow' => 'visible',
	},
	'hr' => {
		'border' => 'none',
		'height' => '0',
		'border-top' => '1px solid #eee',
		'margin' => '14px auto',
	},
	'quote' => {
		'border' => '1px solid #d7d7d7',
		'border-left-width' => '6px',
		'background-color' => '#ffffff',
		'margin-top' => '-2px',
		'padding' => '14px',
	},
	'quote_self' => {
		'border-color' => '#48af04',
	},
	'quote_indent' => {
		'margin-left' => '6px',
	},
}}

##############################

has forum => (
    isa => 'DDGC::Forum',
    is => 'ro',
    lazy_build => 1,
);
sub _build_forum { DDGC::Forum->new( ddgc => shift ) }

##################################################

has help => (
    isa => 'DDGC::Help',
    is => 'ro',
    lazy_build => 1,
);

sub _build_help { DDGC::Help->new( ddgc => shift ) }

##################################################

has idea => (
    isa => 'DDGC::Ideas',
    is => 'ro',
    lazy_build => 1,
);

sub _build_idea { DDGC::Ideas->new( ddgc => shift ) }

#
# ======== User ====================
#

has current_user => (
  isa => 'DDGC::DB::Result::User',
  is => 'rw',
  clearer => 'reset_current_user',
  predicate => 'has_current_user',
);

sub as {
	my ( $self, $user, $code ) = @_;
	die "as need user or undef" unless !defined $user || $user->isa('DDGC::DB::Result::User');
	die "as need coderef" unless ref $code eq 'CODE';
	my $previous_current_user = $self->current_user;
	$user
		? $self->current_user($user)
		: $self->reset_current_user;
	eval {
		$code->();
	};
	$previous_current_user
		? $self->current_user($previous_current_user)
		: $self->reset_current_user;
	croak $@ if $@;
	return;
}

sub errorlog {
	my ( $self, $msg ) = @_;
	state $counter = 0;
	my $t = localtime;
	my $log_id = $$ . $t->epoch . sprintf("%03d", ++$counter);
	my ($package, $filename, $line) = caller(1);
	my $log_line = "$log_id " . $t->datetime . " - $msg @ $filename:$line\n";
	io($self->config->errorlog)->append($log_line);
	return $log_id;
}

sub update_password {
	my ( $self, $username, $new_password ) = @_;
	return unless $self->config->prosody_running;
	$self->xmpp->admin_data_access->put(lc($username),'accounts',{ password => $new_password });
}

sub delete_user {
	my ( $self, $username ) = @_;
	my $user = $self->db->resultset('User')->single({
		username => $username,
	});
	if ($user) {
		my $deleted_user = $self->db->resultset('User')->single({
			username => $self->config->deleted_account,
		});
		die "Deleted user account doesn't exist!" unless $deleted_user;
		die "You can't delete the deleted account!" if $deleted_user->username eq $user->username;
		my $prosody_user_rs;
		if ($self->config->prosody_running) {
			$prosody_user_rs = $self->xmpp->_prosody->_db->resultset('Prosody')->search({
				host => $self->config->prosody_userhost,
				user => lc($username),
			});
			if (!$prosody_user_rs) {
				croak('Unable to find user in Prosody store - bailing out!');
			}
		}
		my $guard = $self->db->txn_scope_guard;
		my @translations = $user->token_language_translations->search({})->all;
		for (@translations) {
			$_->username($deleted_user->username);
			$_->update;
		}
		my @translated_token_languages = $user->token_languages->search({})->all;
		for (@translated_token_languages) {
			$_->translator_users_id($deleted_user->id);
			$_->update;
		}
		my @checked_translations = $user->checked_translations->search({})->all;
		for (@checked_translations) {
			$_->check_users_id($deleted_user->id);
			$_->update;
		}
		my @comments = $user->comments->search({})->all;
		for (@comments) {
			$_->content("This user account has been deleted.");
			$_->users_id($deleted_user->id);
			$_->update({ 'updated' => $_->created });
		}
		my @threads = $user->threads->search({})->all;
		for (@threads) {
			$_->users_id($deleted_user->id);
			$_->ghosted(1);
			$_->update({ 'updated' => $_->created });
		}
		$user->update({ email_verified => 0 });
		$guard->commit;
		($prosody_user_rs) && $prosody_user_rs->delete;
	}
	return 1;
}

sub create_user {
	my ( $self, $username, $password ) = @_;

	return unless $username and $password;

	unless ($self->config->prosody_running) {
		my $user = $self->find_user($username);
		die "user exists" if $user;
		my $db_user = $self->db->resultset('User')->create({
			username => $username,
			notes => 'Created account',
		});
		return $db_user;
	}

	my %xmpp_user_find = $self->xmpp->user($username);

	die "user exists" if %xmpp_user_find;

	my $prosody_user;
	my $db_user;

	$prosody_user = $self->xmpp->_prosody->_db->resultset('Prosody')->create({
		host => $self->config->prosody_userhost,
		user => lc($username),
		store => 'accounts',
		key => 'password',
		type => 'string',
		value => $password,
	});

	if ($prosody_user) {

		my $xmpp_data_check;

		$xmpp_data_check = Prosody::Mod::Data::Access->new(
			jid => lc($username).'@'.$self->config->prosody_userhost,
			password => $password,
		);

		if ($xmpp_data_check || !$self->config->prosody_running) {

			$db_user = $self->db->resultset('User')->create({
				username => $username,
				notes => 'Created account',
			});

		} else {

			$self->xmpp->_prosody->_db->resultset('Prosody')->search({
				host => $self->config->prosody_userhost,
				user => lc($username),
			})->delete;

		}

	}

	return unless $db_user;
	return $db_user;
}

sub find_user {
	my ( $self, $username ) = @_;

	return unless $username;

	my %xmpp_user;
	my $db_user;

	if ($self->config->prosody_running) {
		%xmpp_user = $self->xmpp->user(lc($username));
		return unless %xmpp_user;
		$db_user = $self->db->resultset('User')->search(\[
			'LOWER(me.username) = ?', lc($username)
		])->one_row;
		unless ($db_user) {
			$db_user = $self->db->resultset('User')->create({
				username => $username,
				notes => 'Generated automatically based on prosody account',
			});
		}
	} else {
		$db_user = $self->db->resultset('User')->search(\[
			'LOWER(me.username) = ?', lc($username)
		])->one_row;
		return unless $db_user;
	}

	return $db_user;
}

sub user_counts {
	my ( $self ) = @_;

  return $self->cache->get('ddgc_user_counts') if defined $self->cache->get('ddgc_user_counts');

	my %counts;
	$counts{db} = $self->db->resultset('User')->search({})->count;
	$counts{xmpp} = $self->config->prosody_running ? $self->xmpp->_prosody->_db->resultset('Prosody')->search({
		host => $self->config->prosody_userhost,
	},{
		group_by => 'user',
	})->count : 0;

	$self->cache->set('ddgc_user_counts',\%counts,"1 hour");

	return \%counts;
}

sub copy_image {
	my ( $self, $src, $dest ) = @_;
	my ( $in, $out, $err );
	run [ convert => ( "$src", "-strip", "$dest" ) ], \$in, \$out, \$err, timeout(20) or return 0;
	return 1;
}

#
# ======== Comments ====================
#

sub add_comment { shift->forum->add_comment(@_) }

#
# ======== Misc ====================
#

no Moose;
__PACKAGE__->meta->make_immutable;

# ABSTRACT: The DuckDuckGo Community Platform

__DATA__

=pod

=head1 DESCRIPTION

This is the main class of DDGC. It provides a bunch of helper methods for the
rest of DDGC, and fires up all the other parts of the system.

=head2 User-Facing Components

If you are looking for a tutorial-like document, head over to L<DDGC::Manual>.

=over 4

=item Help

The L<DDGC::Help> system provides L<https://duck.co/help> -- DuckDuckGo's
user documentation.

=item Forum

L<DDGC::Forum> provides General Ramblings and Instant Answers in
L<https://duck.co/forum> for user discussion and support.

=item Blog

L<DDGC::Web::Controller::Blog> provides L<https://duck.co/blog>,
the company blog.

=item Translate

L<DDGC::Web::Controller::Translate> and friends provide
L<https://duck.co/translate> -- DuckDuckGo's public translation system.

=item Feedback

L<DDGC::Web::Controller::Feedback> provides L<https://duckduckgo.com/feedback>
for directly submitting feedback to DuckDuckGo.

=back

=head2 Major Development Components

=over 4

=item L<DDGC::Web>

The Catalyst app which powers this whole thing.

=item L<DDGC::Web::Table>

Magic for dealing with pagination, sorting, etc. in web-based displays
of resultsets. For example, the forum/ideas use this to sort and paginate
themselves.

=item L<DDGC::Search::Client>

The search engine client for searching through things in DDGC.

=item L<DDGC::DB>

All of the L<DBIx::Class>-based database management.

=item L<DDGC::Config>

Configuration for DDGC. This provides default values, but allows for everything
to be overridden via C<%ENV>.

=back

=head1 ATTRIBUTES

=over 4

=item B<config>

L<DDGC::Config> instance, giving access to all of the configuration.

=item B<http>

L<LWP::UserAgent> instance for making HTTP requests from the server.

=item B<db>

L<DDGC::DB> database abstraction via L<DBIx::Class>.

=item B<xmpp>

L<DDGC::XMPP> instance for accessing a local Prosody XMPP server/database.

=item B<markup>

L<DDGC::Markup> instance for converting user-input markup (BBCode) to HTML.

=item B<envoy>

L<DDGC::Envoy> instance for managing DDGC's notifications.

=item B<postman>

L<DDGC::Postman> - your friendly neighborhood postman - deals with outbound emails.

=item B<duckpan>

L<DDGC::DuckPAN> handles Perl distributions like CPAN, just for DuckDuckGo.

=item B<stats>

L<DDGC::Stats> generates anonymous statistics for DDGC data.

=item B<github>

L<DDGC::GitHub> helps with interaction between DDGC and GitHub.

=item B<cache>

L<Cache::Cache> for caching just about anything in DDGC.

=item B<forum>

L<DDGC::Forum> manages the DuckDuckGo forum L<https://duck.co/forum>.

=item B<help>

L<DDGC::Help> helps with the L<help|https://duck.co/help>!

=item B<idea>

L<DDGC::Ideas> provides convenient functions to the L<ideas|https://duck.co/ideas>
section.

=item B<xslate>

L<Text::Xslate> template engine. This is what renders everything in F<templates>.

=item B<current_user>

L<DDGC::DB::Result::User> instance for the current logged in user (if any).

=back

=head1 METHODS

=over 4

=item B<resultset>

Grab a ResultSet from DBIC. See L<https://metacpan.org/pod/DBIx::Class::ResultSet#new>.

=item B<template_styles>

B<Arguments:> None

B<Return Value:> HashRef

Some of the base styles for DDGC. These go into generated CSS.

=item B<all_roles>

B<Arguments:> $role_id?

Role here refers to permission sets - users have roles including:

=over 8

=item translation_manager

=item forum_manager

=item idea_manager

=back

With C<$role_id>, return the full (human-readable) name of that role.
Without C<$role_id>, return a HashRef of C<< { role_id => "Role Name" } >>

=item B<as>

B<Arguments:> $user, $code

Switch the C<current_user> to $user, execute C<$code>, then reset C<current_user>.

=item B<error_log>

B<Arguments:> @data

Dump C<@data> to the error log, as configured in L<DDGC::Config>.

=item B<update_password>

B<Arguments:> $username, $password

Changes C<$username>'s password to C<$password> both in DDGC and Prosody.

=item B<delete_user>

B<Arguments:> $username

B<Return Value:> True if successful

Delete C<$username> from DDGC and Prosody. There is no going back.

=item B<create_user>

B<Arguments:> $username, $password

B<Return Value:> $user

Create C<$username> in DDGC and Prosody, with default values.
If C<$username> already exists, this will just return that user.

=item B<find_user>

B<Arguments:> $username

B<Return Value:> $user or undef

Try to find C<$username> and return that user. If it does not exist, return undef.

=item B<user_counts>

B<Arguments:> none.

B<Return Value:> HashRef

Get the current number of DDGC (Web) and Prosody (XMPP) users as a HashRef:
C<< { db => $web_count, xmpp => $xmpp_count } >>

=back

=cut
