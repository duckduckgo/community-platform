package DDGC::Config;

use Moose;

use File::Path qw( make_path );
use File::Spec;
use File::ShareDir::ProjectDistDir;

sub rootdir_path {
	my $dir = defined $ENV{'DDGC_ROOTDIR'} ? $ENV{'DDGC_ROOTDIR'} : $ENV{HOME}.'/ddgc/';
	return $dir;
}

sub rootdir {
	my $dir = rootdir_path;
	make_path($dir) if !-d $dir;
	return File::Spec->rel2abs( $dir );
}

sub prosody_db_samplefile { File::Spec->rel2abs( File::Spec->catfile( dist_dir('DDGC'), 'ddgc.prosody.sqlite' ) ) }

sub prosody_db_driver { defined $ENV{'DDGC_PROSODY_DB_DRIVER'} ? $ENV{'DDGC_PROSODY_DB_DRIVER'} : 'SQLite3' }
sub prosody_db_database { defined $ENV{'DDGC_PROSODY_DB_DATABASE'} ? $ENV{'DDGC_PROSODY_DB_DATABASE'} : rootdir().'/ddgc.prosody.sqlite' }

sub prosody_db_username { $ENV{'DDGC_PROSODY_DB_USERNAME'} if defined $ENV{'DDGC_PROSODY_DB_USERNAME'} }
sub prosody_db_password { $ENV{'DDGC_PROSODY_DB_PASSWORD'} if defined $ENV{'DDGC_PROSODY_DB_PASSWORD'} }
sub prosody_db_host { $ENV{'DDGC_PROSODY_DB_HOST'} if defined $ENV{'DDGC_PROSODY_DB_HOST'} }

sub prosody_userhost { defined $ENV{'DDGC_PROSODY_USERHOST'} ? $ENV{'DDGC_PROSODY_USERHOST'} : "test.domain" }

sub prosody_connect_info {
	my %params = (
		quote_char              => '"',
		name_sep                => '.',
	);
	my $driver;
	if (prosody_db_driver eq 'SQLite3') {
		$params{sqlite_unicode} = 1;
		$driver = 'SQLite';
	} elsif (prosody_db_driver eq 'MySQL') {
		$params{mysql_enable_utf8} = 1;
		$driver = 'mysql';
	} elsif (prosody_db_driver eq 'PostgreSQL') {
		$params{pg_enable_utf8} = 1;
		$driver = 'Pg';
	}
	my $dsn = 'dbi:'.$driver.':dbname='.prosody_db_database.( prosody_db_host() ? ';host='.prosody_db_host : '' );
	return [
		$dsn,
		prosody_db_username,
		prosody_db_password,
		\%params,
	];
}

sub db_dsn { defined $ENV{'DDGC_DB_DSN'} ? $ENV{'DDGC_DB_DSN'} : 'dbi:SQLite:'.rootdir().'/ddgc.db.sqlite' }
sub db_user { defined $ENV{'DDGC_DB_USER'} ? $ENV{'DDGC_DB_USER'} : '' }
sub db_password { defined $ENV{'DDGC_DB_PASSWORD'} ? $ENV{'DDGC_DB_PASSWORD'} : '' }

sub db_params {
	my %vars = (
		quote_char		=> '"',
		name_sep		=> '.',
	);
	if (db_dsn =~ m/:SQLite:/) {
		$vars{sqlite_unicode} = 1;
	} elsif (db_dsn =~ m/:Pg:/) {
		$vars{pg_enable_utf8} = 1;
	}
	return \%vars;
}

sub filesdir {
	my $dir = defined $ENV{'DDGC_FILESDIR'} ? $ENV{'DDGC_FILESDIR'} : rootdir().'/files/';
	make_path($dir) if !-d $dir;
	return File::Spec->rel2abs( $dir );
}

sub screen_filesdir {
	my $dir = defined $ENV{'DDGC_FILESDIR_SCREEN'} ? $ENV{'DDGC_FILESDIR_SCREEN'} : filesdir().'/screens/';
	make_path($dir) if !-d $dir;
	return File::Spec->rel2abs( $dir );
}

sub cachedir {
	my $dir = defined $ENV{'DDGC_CACHEDIR'} ? $ENV{'DDGC_CACHEDIR'} : rootdir().'/cache/';
	make_path($dir) if !-d $dir;
	return File::Spec->rel2abs( $dir );
}

1;