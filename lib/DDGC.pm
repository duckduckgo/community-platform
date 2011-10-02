package DDGC;
# ABSTRACT: DuckDuckGo Community Platform

use Moose;
use DDGC::Config;
use DDGC::DB;
use File::Copy;

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

1;
