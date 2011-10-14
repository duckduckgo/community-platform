package DDGC;
# ABSTRACT: DuckDuckGo Community Platform

use Moose;
use DDGC::Config;
use DDGC::DB;
use DDGC::User;
use File::Copy;
use IO::All;
use File::Spec;
use File::ShareDir::ProjectDistDir;

# TESTING AND DEVELOPMENT, NOT FOR PRODUCTION
sub deploy_fresh {
	my ( $self ) = @_;

	DDGC::Config::rootdir();
	DDGC::Config::filesdir();
	DDGC::Config::cachedir();

	copy(DDGC::Config::prosody_db_samplefile,DDGC::Config::rootdir) or die "Copy failed: $!";

	$self->db->connect->deploy;
}

has db => (
	isa => 'DDGC::DB',
	is => 'ro',
	lazy_build => 1,
);
sub _build_db { DDGC::DB->connect }

has xmpp => (
	isa => 'DDGC::XMPP',
	is => 'ro',
	lazy_build => 1,
);
sub _build_xmpp { DDGC::XMPP->new }

sub resultset { shift->db->resultset(@_) }
sub rs { shift->resultset(@_) }

sub update_password {
	my ( $self, $username, $password ) = @_;
	my $pwrow = $self->xmpp->_prosody->_db->resultset('Prosody')->search({
		host => DDGC::Config::prosody_userhost(),
		user => $username,
		store => 'accounts',
		key => 'password',
		type => 'string',
	})->first;
	die "unknown user" if !$pwrow;
	$pwrow->value($password);
	$pwrow->update;
}

sub create_user {
	my ( $self, $username, $password ) = @_;
	
	return unless $username and $password;
	
	my %xmpp_user_find = $self->xmpp->user($username);
	
	die "user exists" if %xmpp_user_find;
	
	my $prosody_user;
	my $db_user;

	$prosody_user = $self->xmpp->_prosody->_db->resultset('Prosody')->create({
		host => DDGC::Config::prosody_userhost(),
		user => $username,
		store => 'accounts',
		key => 'password',
		type => 'string',
		value => $password,
	});

	if ($prosody_user) {
		$db_user = $self->db->resultset('User')->create({
			username => $username,
			notes => 'Created account',
		});
	}

	return unless $db_user;
	
	my %xmpp_user = $self->xmpp->user($username);
	
	return DDGC::User->new({
		username => $username,
		db => $db_user,
		xmpp => \%xmpp_user,
	});
}

sub find_user {
	my ( $self, $username ) = @_;

	return unless $username;

	my %xmpp_user = $self->xmpp->user($username);

	return unless %xmpp_user;

	my $db_user = $self->db->resultset('User')->find_or_create({
		username => $username,
		notes => 'Generated automatically based on prosody account',
	});

	return DDGC::User->new({
		username => $username,
		db => $db_user,
		xmpp => \%xmpp_user,
	});
}

use Data::Printer;

sub flaglist { map { chomp; $_; } io( File::Spec->catfile(dist_dir('DDGC'), 'flaglist.txt') )->slurp }

1;
