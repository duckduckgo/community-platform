package DDGC::Config;
# ABSTRACT: DDGC main configuration file

use Moose;
use File::Path qw( make_path );
use File::Spec;
use File::ShareDir::ProjectDistDir;
use Path::Class;
use Catalyst::Utils;
use FindBin;
use IO::All;
use JSON;
use Sys::Hostname;

use DDGC::Config::Subscriptions;

has always_use_default => (
	is => 'ro',
	lazy => 1,
	default => sub { 0 },
);

has subscriptions => (
	is => 'ro',
	lazy_build => 1,
);
sub _build_subscriptions {
	DDGC::Config::Subscriptions->new;
}

sub has_conf {
	my ( $name, $env_key, $default ) = @_;
	my $default_ref = ref $default;
	has $name => (
		is => 'ro',
		lazy => 1,
		default => sub {
			my ( $self ) = @_;
			my $result;
			if ($self->always_use_default) {
				if ($default_ref eq 'CODE') {
					$result = $default->(@_);
				} else {
					$result = $default;
				}
			} else {
				if (defined $ENV{$env_key}) {
					$result = $ENV{$env_key};
				} else {
					if ($default_ref eq 'CODE') {
						$result = $default->(@_);
					} else {
						$result = $default;
					}
				}
			}
			return $result;
		},
	);
}

has_conf nid => DDGC_NID => 1;
has_conf pid => DDGC_PID => $$;

has_conf livereload_js_uri => DDGC_LIVERELOAD_JS_URI => sprintf( 'http://%s:5000/livereload.js', hostname() );
has_conf appdir_path => DDGC_APPDIR => sub {
	( -f "$FindBin::Bin/../package.json" ) && return "$FindBin::Bin/../";
	return "/home/ddgc/live/";
};
has_conf rootdir_path => DDGC_ROOTDIR => $ENV{HOME}.'/ddgc/';
has_conf no_cache => DDGC_NOCACHE => 0;

sub rootdir {
	my ( $self ) = @_;
	my $dir = $self->rootdir_path;
	make_path($dir) if !-d $dir;
	return File::Spec->rel2abs( $dir );
}

has_conf web_base => DDGC_WEB_BASE => sub {
	( $_[0]->is_live )
		? 'https://duck.co'
		: 'https://ddgc-staging.duckduckgo.com';
};

sub prosody_db_samplefile { File::Spec->rel2abs( File::Spec->catfile( dist_dir('DDGC'), 'ddgc.prosody.sqlite' ) ) }
sub duckpan_cdh_template { File::Spec->rel2abs( File::Spec->catfile( dist_dir('DDGC'), 'perldoc', 'duckpan.html' ) ) }
sub duckpan_cdh_assets {{
	'duckpan.css' => File::Spec->rel2abs( File::Spec->catfile( dist_dir('DDGC'), 'perldoc', 'duckpan.css' ) ),
	'duckpan.png' => File::Spec->rel2abs( File::Spec->catfile( dist_dir('DDGC'), 'perldoc', 'duckpan.png' ) ),
}}

has_conf prosody_db_driver => DDGC_PROSODY_DB_DRIVER => 'SQLite3';
has_conf prosody_db_database => DDGC_PROSODY_DB_DATABASE => sub {
	my ( $self ) = @_;
	return $self->rootdir().'/ddgc.prosody.sqlite';
};

has_conf errorlog => DDGC_ERRORLOG => sub {
	my ( $self ) = @_;
	return $self->rootdir().'/error.log';
};

has_conf duckpanlog => DDGC_DUCKPANLOG => sub {
	my ( $self ) = @_;
	return $self->rootdir().'/duckpan.log';
};

has_conf prosody_db_username => DDGC_PROSODY_DB_USERNAME => undef;
has_conf prosody_db_password => DDGC_PROSODY_DB_PASSWORD => undef;
has_conf prosody_db_host => DDGC_PROSODY_DB_HOST => undef;
has_conf prosody_userhost => DDGC_PROSODY_USERHOST => 'test.domain';

sub is_live {
	my $self = shift;
	$self->prosody_userhost() eq 'dukgo.com' ? 1 : 0
}

sub is_view {
	my $self = shift;
	$self->prosody_userhost() eq 'ddgc-staging-xmpp.duckduckgo.com' ? 1 : 0
}

has_conf prosody_admin_username => DDGC_PROSODY_ADMIN_USERNAME => 'testone';
has_conf prosody_admin_password => DDGC_PROSODY_ADMIN_PASSWORD => 'testpass';

has_conf mail_test => DDGC_MAIL_TEST => 0;
has_conf mail_test_log => DDGC_MAIL_TEST_LOG => '';
has_conf smtp_host => DDGC_SMTP_HOST => undef;
has_conf smtp_ssl => DDGC_SMTP_SSL => 0;
has_conf smtp_sasl_username => DDGC_SMTP_SASL_USERNAME => undef;
has_conf smtp_sasl_password => DDGC_SMTP_SASL_PASSWORD => undef;

has_conf shared_secret => DDGC_SHARED_SECRET => undef;

has_conf templatedir => DDGC_TEMPLATEDIR => sub { dir( Catalyst::Utils::home('DDGC'), 'templates' )->resolve->absolute->stringify };

has_conf duckpan_url => DDGC_DUCKPAN_URL => 'http://duckpan.org/';
has_conf duckpan_locale_uploader => DDGC_DUCKPAN_LOCALE_UPLOADER => 'testone';
has_conf duckduckhack_url => DDGC_DUCKDUCKHACK_URL => 'http://duckduckhack.com/';
has_conf github_token => DDGC_GITHUB_TOKEN => undef;
has_conf github_org => DDGC_GITHUB_ORG => 'duckduckgo';
has_conf github_client_id => DDGC_GITHUB_CLIENT_ID => undef;
has_conf github_client_secret => DDGC_GITHUB_CLIENT_SECRET => undef;

has_conf deleted_account => DDGC_DELETED_ACCOUNT => 'testone';
has_conf automoderator_account => DDGC_AUTOMODERATOR_ACCOUNT => 'automoderator';

has_conf comment_rate_limit => DDGC_COMMENT_RATE_LIMIT => 120;
has_conf login_failure_time_limit => DDGC_LOGIN_FAILURE_TIME_LIMIT => 600;
has_conf login_failure_count_limit => DDGC_LOGIN_FAILURE_COUNT_LIMIT => 6;
has_conf login_failure_session_limit => DDGC_LOGIN_FAILURE_SESSION_LIMIT => 10;

has_conf forgotpw_session_limit => DDGC_LOGIN_FAILURE_SESSION_LIMIT => 5;
has_conf forgotpw_user_time_limit => DDGC_LOGIN_FAILURE_SESSION_LIMIT => 300;

has_conf unsub_key => DDGC_UNSUB_KEY => undef;

# DANGER: DEACTIVATES PASSWORD CHECK FOR ALL USERACCOUNTS!!!!!!!!!!!!!!!!!!!!!!
sub prosody_running { defined $ENV{'DDGC_PROSODY_RUNNING'} ? $ENV{'DDGC_PROSODY_RUNNING'} : 0 }
sub fallback_user { 'testtwo' }

sub prosody_connect_info {
	my ( $self ) = @_;
	my %params = (
		quote_char => '"',
		name_sep => '.',
		cursor_class => 'DBIx::Class::Cursor::Cached',
	);
	my $driver;
	if ($self->prosody_db_driver eq 'SQLite3') {
		$params{sqlite_unicode} = 1;
		$driver = 'SQLite';
	} elsif ($self->prosody_db_driver eq 'MySQL') {
		$params{mysql_enable_utf8} = 1;
		$driver = 'mysql';
	} elsif ($self->prosody_db_driver eq 'PostgreSQL') {
		$params{pg_enable_utf8} = 1;
		$driver = 'Pg';
	}
	my $dsn = 'dbi:'.$driver.':dbname='.$self->prosody_db_database.( $self->prosody_db_host() ? ';host='.$self->prosody_db_host : '' );
	return [
		$dsn,
		$self->prosody_db_username,
		$self->prosody_db_password,
		\%params,
	];
}

has_conf db_dsn => DDGC_DB_DSN => sub {
	my ( $self ) = @_;
	my $rootdir = $self->rootdir();
	warn "DANGER, using SQLite as driver for DDGC will be deprecated soon";
	return 'dbi:SQLite:'.$rootdir.'/ddgc.db.sqlite';
};

has_conf db_user => DDGC_DB_USER => '';
has_conf db_password => DDGC_DB_PASSWORD => '';

has db_params => (
	is => 'ro',
	lazy => 1,
	default => sub {
		my ( $self ) = @_;
		my %vars = (
			quote_char => '"',
			name_sep => '.',
			cursor_class => 'DBIx::Class::Cursor::Cached',
		);
		if ($self->db_dsn =~ m/:SQLite:/) {
			$vars{sqlite_unicode} = 1;
			$vars{on_connect_do} = 'PRAGMA SYNCHRONOUS = OFF';
		} elsif ($self->db_dsn =~ m/:Pg:/) {
			$vars{pg_enable_utf8} = 1;
		}
		return \%vars;
	},
);

has_conf dezi_uri => DDGC_DEZI_URI => 'http://127.0.0.1:5000';
has_conf index_path => DDGC_INDEX_PATH => '.';

has_conf image_proxy_url => DDGC_IMAGE_PROXY_URL => 'https://images.duckduckgo.com/iu/?u=';

sub duckpandir {
	my ( $self ) = @_;
	my $dir = defined $ENV{'DDGC_DUCKPANDIR'} ? $ENV{'DDGC_DUCKPANDIR'} : $self->rootdir().'/duckpan/';
	make_path($dir) if !-d $dir;
	return File::Spec->rel2abs( $dir );
}

sub filesdir {
	my ( $self ) = @_;
	my $dir = defined $ENV{'DDGC_FILESDIR'} ? $ENV{'DDGC_FILESDIR'} : $self->rootdir().'/files/';
	make_path($dir) if !-d $dir;
	return File::Spec->rel2abs( $dir );
}

sub screen_filesdir {
	my ( $self ) = @_;
	my $dir = defined $ENV{'DDGC_FILESDIR_SCREEN'} ? $ENV{'DDGC_FILESDIR_SCREEN'} : $self->filesdir().'/screens/';
	make_path($dir) if !-d $dir;
	return File::Spec->rel2abs( $dir );
}

sub cachedir {
	my ( $self ) = @_;
	my $dir = defined $ENV{'DDGC_CACHEDIR'} ? $ENV{'DDGC_CACHEDIR'} : $self->rootdir().'/cache/';
	make_path($dir) if !-d $dir;
	return File::Spec->rel2abs( $dir );
}

sub docsdir {
	my ( $self ) = @_;
	my $dir = defined $ENV{'DDGC_DOCSDIR'}
		? $ENV{'DDGC_DOCSDIR'}
		: File::Spec->catdir( $self->cachedir, 'docs' );
	make_path($dir) if !-d $dir;
	return File::Spec->rel2abs( $dir );
}

sub mediadir {
	my ( $self ) = @_;
	my $dir = defined $ENV{'DDGC_MEDIADIR'} ? $ENV{'DDGC_MEDIADIR'} : $self->rootdir().'/media/';
	make_path($dir) if !-d $dir;
	return File::Spec->rel2abs( $dir );
}

sub xslate_cachedir {
	my ( $self ) = @_;
	my $dir = defined $ENV{'DDGC_CACHEDIR_XSLATE'} ? $ENV{'DDGC_CACHEDIR_XSLATE'} : $self->cachedir().'/xslate/';
	make_path($dir) if !-d $dir;
	return File::Spec->rel2abs( $dir );
}

sub forum_config { $_[0]->forums->{$_[0]->forum} }
sub forums {
	my ( $self ) = @_;
	+{
		'1' => {
			name => 'General Ramblings',
			notification => 'General Rambling',
			button_text => 'General Ramblings',
			url  => 'general',
		},
		'2' => {
			name => 'Community Leaders',
			notification => 'Community Leaders Post',
			button_img => '/static/images/comleader_button.png',
			url  => 'community_leaders',
			user_filter => sub { ($_[0] && $_[0]->is('forum_manager')) },
		},
		'3' => {
			name => 'Translation Managers',
			notification => 'Translation Managers Post',
			url  => 'translation_managers',
			user_filter => sub { ($_[0] && $_[0]->is('translation_manager')) },
		},
		'4' => {
			name => 'Internal',
			notification => 'Internal Forum Post',
			button_img => '/static/images/admin_button.png',
			url  => 'internal',
			user_filter => sub { ($_[0] && $_[0]->is('patron')) },
		},
		'5' => {
			name => 'Special Announcements',
			notification => 'Special Announcement',
			button_text => 'S',
			url  => 'special',
			user_filter => sub { ($_[0] && $_[0]->is('admin')) },
		},
	};
}
sub id_for_forum {
	my ( $self, $forum_name ) = @_;
	my $forums = $self->forums;
	return (grep { $forums->{$_}->{name} =~ m/$forum_name/i } keys $forums)[0];
}

sub roles {
	my ( $self ) = @_;
	+{
		'1' => {
			role => 'admin',
			name => 'Community Platform Admin',
		},
		'2' => {
			role => 'forum_manager',
			name => 'Community Leader (Forum Manager)',
		},
		'3' => {
			role => 'translation_manager',
			name => 'Translation Manager',
		},
		'4' => {
			role => 'patron',
			name => 'Patron',
		},
	};
}
sub id_for_role {
	my ( $self, $role_name ) = @_;
	my $roles = $self->roles;
	$role_name = 'forum_manager' if ($role_name eq 'community_leader');
	(grep { $roles->{$_}->{role} eq $role_name } keys $roles)[0] // 0;
}

sub campaign_config { $_[0]->campaigns->{$_[0]->campaign} }
sub campaigns {
	my ( $self ) = @_;
	+{
		share => {
			id => 1,
			active => 1,
			notification_active => 0,
			min_length => 45,
			url => '/wear/',
			notification => "Help share DuckDuckGo! Find out more...",
			question1 => "How did you hear about DuckDuckGo? (Try to be as descriptive as possible)",
			question2 => "How long have you been a DuckDuckGo user?",
			question3 => "Is this your first time spreading DuckDuckGo to others?",
			question4 => "Are you the kind of person that can really convert at least 3 users, to help your friends take back their privacy?",
			question5 => "What is you favourite <a href=\"https://duck.co/ia/\">IA</a>?",
			question6 => "What is you favourite <a href=\"https://duckduckgo.com/bang\">!bang</a>?",
			question7 => "Share your email so that we can send updates on your DuckDuckGo T-shirt.",
		},
		share_followup => {
			id => 2,
			active => 1,
			notification_active => 1,
			min_length => 50,
			url => '/wear/',
			notification => "You've been sharing DuckDuckGo for 30 days. Ready to answer your final questions?",
			question1 => "How did you get your friends to switch to DuckDuckGo?",
			question2 => "What did they most like about DuckDuckGo?",
			question3 => "How long did it take them to switch?",
		}
	}
}
sub id_for_campaign {
	my ($self, $campaign) = @_;
	return $self->campaigns->{$campaign}->{id};
}
sub first_active_campaign {
	my ($self) = @_;
	my $c = $self->campaigns;
	(sort { $c->{$a}->{id} <=> $c->{$b}->{id} } grep { $c->{$_}->{active} } keys $c)[0];
}

has_conf feedback_email => DDGC_FEEDBACK_EMAIL => 'support@duckduckgo.com';
has_conf error_email => DDGC_ERROR_EMAIL => 'ddgc@duckduckgo.com';
has_conf share_email => DDGC_SHARE_EMAIL => 'sharewear@duckduckgo.com';
has_conf ia_email => DDGC_IA_EMAIL => 'ddgc-ia@duckduckgo.com';

has js_version => (
	isa => 'Str',
	is => 'ro',
	lazy_build => 1,
);
sub _build_js_version {
	my ( $self ) = @_;
	my $ROOT_PATH = $self->appdir_path;

	# look for ia.js which doesn't exist in the repo.
	# If it exists then we are building a debug version.
	# If it doesn't then continue on to return the version
	# number for release.
	if( -f "$ROOT_PATH/root/static/js/ia.js"){
		return '';
	}

	my $file = "$ROOT_PATH/package.json";
	my $pkg < io($file);
	my $json = decode_json($pkg);

	if($json->{'version'} =~ /(\d+)\.(\d+)\.(\d+)/){
		my $version = $2 - 1;
		return qq($1.$version.$3);
	} else {
		$self->errorlog("Unable to ascertain JS version from $ROOT_PATH/package.json");
		return '';
	}
}

1;
