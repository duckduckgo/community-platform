package DDGCTest::Database;

use Moose;
use DDGC::DB;
use Try::Tiny;
use utf8;
use Data::Printer;

has _ddgc => (
	is => 'ro',
	required => 1,
);
sub d { shift->_ddgc(@_) }

sub db { shift->_ddgc->db(@_) }

has test => (
	is => 'ro',
	isa => 'Bool',
	required => 1,
);

# cache
has c => (
	isa => 'HashRef',
	is => 'rw',
	default => sub {{
		languages => {},
		users => {},
		token_context => {},
	}},
);

sub BUILDARGS {
    my ( $class, $ddgc, $test ) = @_;
	my %options;
	$options{_ddgc} = $ddgc;
	$options{test} = $test;
	return \%options;
}

sub deploy {
	my ( $self ) = @_;
	$self->d->deploy_fresh;
	$self->add_languages;
	$self->add_users;
}

sub isa_ok { ::isa_ok(@_) if shift->test }
sub is { ::is(@_) if shift->test }

#  _
# | | __ _ _ __   __ _ _   _  __ _  __ _  ___  ___
# | |/ _` | '_ \ / _` | | | |/ _` |/ _` |/ _ \/ __|
# | | (_| | | | | (_| | |_| | (_| | (_| |  __/\__ \
# |_|\__,_|_| |_|\__, |\__,_|\__,_|\__, |\___||___/
#                |___/             |___/

sub languages {{
	'us' => {
		name_in_english => 'English of United States',
		name_in_local => 'English of United States',
		locale => 'en_US',
	},
	'de' => {
		name_in_english => 'German of Germany',
		name_in_local => 'Deutsch von Deutschland',
		locale => 'de_DE',
	},
	'es' => {
		name_in_english => 'Spanish of Spain',
		name_in_local => 'Español de España',
		locale => 'es_ES',
	},
}}

sub add_languages {
	my ( $self ) = @_;
	my $rs = $self->db->resultset('Language');
	$self->c->{languages}->{$_} = $rs->create($self->languages->{$_}) for (keys %{$self->languages});
}

#  _   _ ___  ___ _ __ ___
# | | | / __|/ _ \ '__/ __|
# | |_| \__ \  __/ |  \__ \
#  \__,_|___/\___|_|  |___/

sub users {{
	'testtwo' => {
		pw => 'test1234',
		public => 1,
		admin => 1,
		notes => 'Testuser, admin and public',
		languages => {
			es => 5,
		},
	},
	'testthree' => {
		pw => '1234test',
		public => 1,
		notes => 'Testuser, public',
		languages => {
			us => 5,
		},
	},
	'testfour' => {
		pw => '1234test',
		notes => 'Testuser',
		languages => {
			de => 3,
			es => 3,
			us => 5,
		},
	},
}}

sub add_users {
	my ( $self ) = @_;
	my $testone = $self->d->find_user('testone');
	$self->isa_ok($testone,'DDGC::User');
	$testone->admin(1);
	$testone->notes('Testuser, admin');
	$testone->create_related('user_languages',{
		language_id => $self->c->{languages}->{'de'}->id,
		grade => 5,
	});
	$testone->update;
	for (keys %{$self->users}) {
		my $data = $self->users->{$_};
		my $pw = delete $data->{pw};
		my $languages = delete $data->{languages};
		my $user = $self->d->create_user($_,$pw);
		$user->$_($data->{$_}) for (keys %{$data});
		for (keys %{$languages}) {
			$user->create_related('user_languages',{
				language_id => $self->c->{languages}->{$_}->id,
				grade => $languages->{$_},
			});
		}
		$user->update;
		$self->isa_ok($user,'DDGC::User');
	}
	for (keys %{$self->users}) {
		my $user = $self->d->find_user($_);
		$self->is($user->username,$_,'Checking username');
		$self->isa_ok($user,'DDGC::User');
	}
}

1;
