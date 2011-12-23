package DDGC;
# ABSTRACT: DuckDuckGo Community Platform

use Moose;
use DDGC::Config;
use DDGC::DB;
use DDGC::User;
use DDGC::Comments;
use File::Copy;
use IO::All;
use File::Spec;
use File::ShareDir::ProjectDistDir;
use Prosody::Mod::Data::Access;

# TESTING AND DEVELOPMENT, NOT FOR PRODUCTION
sub deploy_fresh {
	my ( $self ) = @_;

	$self->config->rootdir();
	$self->config->filesdir();
	$self->config->cachedir();

	copy($self->config->prosody_db_samplefile,$self->config->rootdir) or die "Copy failed: $!";

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

has config => (
	isa => 'DDGC::Config',
	is => 'ro',
	lazy_build => 1,
);
sub _build_config { DDGC::Config->new }

sub resultset { shift->db->resultset(@_) }
sub rs { shift->resultset(@_) }

#
# ======== User ====================
#

sub update_password {
	my ( $self, $username, $new_password ) = @_;
	return unless $self->config->prosody_running;
	Prosody::Mod::Data::Access->new(
		jid => $self->config->prosody_admin_username.'@'.$self->config->prosody_userhost,
		password => $self->config->prosody_admin_password,
	)->put($username,'accounts',{ password => $new_password });
}

sub delete_user {
	my ( $self, $username ) = @_;
	$self->xmpp->_prosody->_db->resultset('Prosody')->search({
		host => $self->config->prosody_userhost,
		user => $username,
	})->delete;
	$self->db->resultset('User')->search({
		username => $username,
	})->delete;
	return 1;
}

sub create_user {
	my ( $self, $username, $password ) = @_;

	return unless $username and $password;

	my %xmpp_user_find = $self->xmpp->user($username);

	die "user exists" if %xmpp_user_find;

	my $prosody_user;
	my $db_user;

	$prosody_user = $self->xmpp->_prosody->_db->resultset('Prosody')->create({
		host => $self->config->prosody_userhost,
		user => $username,
		store => 'accounts',
		key => 'password',
		type => 'string',
		value => $password,
	});

	if ($prosody_user) {

		my $xmpp_data_check;

		$xmpp_data_check = Prosody::Mod::Data::Access->new(
			jid => $username.'@'.$self->config->prosody_userhost,
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
				user => $username,
			})->delete;

		}

	}

	return unless $db_user;
	
	my %xmpp_user = $self->xmpp->user($username);
	
	return DDGC::User->new({
		username => $username,
		db => $db_user,
		xmpp => \%xmpp_user,
		ddgc => $self,
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
		ddgc => $self,
		xmpp => \%xmpp_user,
	});
}

sub user_counts {
	my ( $self ) = @_;
	my %counts;
	$counts{db} = $self->db->resultset('User')->count;
	$counts{xmpp} = $self->xmpp->_prosody->_db->resultset('Prosody')->search({
		host => $self->config->prosody_userhost,
	},{
		group_by => 'user',
	})->count;
	return \%counts;
}

#
# ======== Comments ====================
#

sub add_comment {
	my ( $self, $context, $context_id, $user, $content, @args ) = @_;
	
	if ( $context eq 'DDGC::DB::Result::Comment' ) {
		my $comment = $self->rs('Comment')->find($context_id);
		return $self->rs('Comment')->create({
			context => $comment->context,
			context_id => $comment->context_id,
			parent_id => $context_id,
			users_id => $user->id,
			content => $content,
			@args,
		});
	} else {
		return $self->rs('Comment')->create({
			context => $context,
			context_id => $context_id,
			users_id => $user->id,
			content => $content,
			@args,
		});
	}
}

sub comments {
	my ( $self, $context, $context_id, @args ) = @_;
	return DDGC::Comments->new(
		context => $context,
		context_id => $context_id,
		ddgc => $self,
		@args,
	);
}

#
# ======== Misc ====================
#

sub flaglist { map { chomp; $_; } io( File::Spec->catfile(dist_dir('DDGC'), 'flaglist.txt') )->slurp }

1;
