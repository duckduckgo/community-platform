package DDGCTest::Database;
#
# BE SURE YOU SAVE THIS FILE AS UTF-8 WITHOUT BYTE ORDER MARK (BOM)
#
######################################################################

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

sub xmpp { shift->_ddgc->xmpp(@_) }

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
		token_domain => {},
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
	$self->add_token_domains;
}

sub isa_ok { ::isa_ok(@_) if shift->test }
sub is { ::is(@_) if shift->test }

#####################################################
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
		flagicon => 'us',
	},
	'de' => {
		name_in_english => 'German of Germany',
		name_in_local => 'Deutsch von Deutschland',
		locale => 'de_DE',
		flagicon => 'de',
	},
	'es' => {
		name_in_english => 'Spanish of Spain',
		name_in_local => 'Español de España',
		locale => 'es_ES',
		flagicon => 'es',
	},
	'br' => {
		name_in_english => 'Portuguese of Brazil',
		name_in_local => 'Português do Brasil',
		locale => 'pt_BR',
		flagicon => 'br',
		plural => '(n > 1)',
	},
	'ru' => {
		name_in_english => 'Russian of Russia',
		name_in_local => 'Русский России',
		locale => 'ru_RU',
		flagicon => 'ru',
		nplurals => '3',
		plural => 'n%10==1 && n%100!=11 ? 0 : n%10>=2 && n%10<=4 && (n%100<10 || n%100>=20) ? 1 : 2',
	},
	'in' => {
		name_in_english => 'Hindi of India',
		name_in_local => 'इंडिया का हिन्दी',
		locale => 'hi_IN',
		flagicon => 'in',
	},
}}

sub add_languages {
	my ( $self ) = @_;
	my $rs = $self->db->resultset('Language');
	$self->c->{languages}->{$_} = $rs->create($self->languages->{$_}) for (keys %{$self->languages});
}

#############################
#  _   _ ___  ___ _ __ ___
# | | | / __|/ _ \ '__/ __|
# | |_| \__ \  __/ |  \__ \
#  \__,_|___/\___|_|  |___/

sub users {{
	'testtwo' => {
		pw => 'test1234',
		public => 1,
		admin => 1,
		notes => 'Testuser, admin, public, es',
		languages => {
			es => 6,
		},
	},
	'testthree' => {
		pw => '1234test',
		public => 1,
		notes => 'Testuser, public, us',
		languages => {
			us => 6,
		},
	},
	'testfour' => {
		pw => '1234test',
		notes => 'Testuser, de, es, us',
		languages => {
			de => 3,
			es => 3,
			us => 5,
		},
	},
	'testfive' => {
		pw => '1-2-3-4-5',
		notes => 'Testuser, ru, us',
		languages => {
			ru => 5,
			us => 2,
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
	$testone->create_related('user_languages',{
		language_id => $self->c->{languages}->{'us'}->id,
		grade => 3,
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

################################################################
#  _        _                                _            _
# | |_ ___ | | _____ _ __     ___ ___  _ __ | |_ _____  _| |_
# | __/ _ \| |/ / _ \ '_ \   / __/ _ \| '_ \| __/ _ \ \/ / __|
# | || (_) |   <  __/ | | | | (_| (_) | | | | ||  __/>  <| |_
#  \__\___/|_|\_\___|_| |_|  \___\___/|_| |_|\__\___/_/\_\\__|

sub token_domains {{
	'test-domain' => {
		name => 'The domain of tests',
		base => 'us',
		description => 'Bla blub the test is dead the test is dead!',
		languages => [qw( us de es br ru )],
		snippets => [
			'Hello %s', {
				testone => {
					'de' => 'Hallo %s',
					'us' => 'Heeellloooo %s',
				},
				testthree => {
					'us' => 'Welcome %s',
				},
				testfive => {
					'ru' => 'Привет %s',
				},
			},
			'You are %s from %s', {
				testone => {
					'de' => 'Du bist %s aus %s',
					'us' => 'You, u %s ofda %s',
				},
				testthree => {
					'us' => 'You are %s from %s',
				},
				testfive => {
					'ru' => 'Вы %s из %s',
				},
			},
			'You have %d message', 'You have %d messages', {
				testone => {
					'de' => [ 'Du hast %d Nachricht', 'Du hast %d Nachrichten' ],
					'us' => [ 'Yu hav %d meage', 'Yuuu hve %d meages' ],
				},
				testthree => {
					'us' => [ 'You have %d message', 'You have %d messages' ],
				},
				testfive => {
					'ru' => [ 'You have %d message', 'You have %d messages', 'You have %d messagess' ],
				},
			},
		],
		tokens => [
		],
	},
	'duckduckgo-results' => {
		name => 'DuckDuckGo Results',
		base => 'us',
		description => 'Snippets around the Resultpage of DuckDuckGo',
		languages => [qw( us de es br ru )],
		snippets => [
			'try', {
				testone => {
					'de' => 'Versuch',
					'us' => 'tryy',
				},
				testthree => {
					'us' => 'try',
				},
			},
			'vehicle info', {
				testone => {
					'de' => 'Fahrzeug Information',
					'us' => 'vehycle ynfo',
				},
				testthree => {
					'us' => 'vehicle info',
				},
			},
			'map', {
				testone => {
					'de' => 'Karte',
					'us' => 'maaap',
				},
				testthree => {
					'us' => 'map',
				},
			},
			'search', {
				notes => {
					token => 'test note',
					de => 'de test note',
				},
				testone => {
					'de' => 'Suche',
					'us' => 'zearch',
				},
				testthree => {
					'us' => 'search',
				},
			},
			'try search on', {
				testone => {
					'de' => 'Versuch deine Suche auf',
					'us' => 'dry zearch pn'
				},
				testthree => {
					'us' => 'try search on',
				},
			},
			'searches', {
				testone => {
					'de' => 'Suchen',
					'us' => 'zearchez',
				},
				testthree => {
					'us' => 'searches',
				},
			},
			'uses our', {
				testone => {
					'de' => 'benutzt unser',
					'us' => 'uzez my',
				},
				testthree => {
					'us' => 'uses our',
				},
			},
			'using our', {},
			'syntax', {},
			'more at', {},
			'more', {},
			'top', {},
			'official site', {},
			'random password', {},
			'random number', {},
			'random', {},
			'entry in', {},
			'web links', {},
			'try web links', {},
			'can mean different things', {},
			'click what you meant by', {},
			'meanings', {},
			'some meanings', {},
			'more meanings', {},
			'dictionary', {},
			'shipment tracking', {},
			'try to go there', {},
			'is a parked domain (last time we checked)', {},
			'is an area code in', {},
			'is a zip code in', {},
			'is a phone number in', {},
			'reverse search', {},
			'pay', {},
			'free', {},
			'uses results from', {},
			'results from', {},
			'no right topic?', {},
			'some topics grouped into', {},
			'more topics', {},
			'topics', {},
			'grouped into sections', {},
			'and', {},
			'more links', {},
			'related topics', {},
			'more related topics', {},
			'at', {},
			'ignore this box please', {},
			'put search terms here', {},
			'settings', {},
			'goodies', {},
			'spread', {},
			'add to', {},
			'from any region', {},
			'I\'m feeling ducky', {},
			'sort by date', {},
			'popular', {},
			'programming', {},
			'images', {},
			'news', {},
			'zero-click info', {},
			'this page requires', {},
			'get the non-JS version', {},
			'here', {},
			'category', {},
		],
		tokens => [
		],
	},
	'duckduckgo-homepage' => {
		name => 'DuckDuckGo Homepage',
		base => 'us',
		description => 'Snippets around the Homepage of DuckDuckGo',
		languages => [qw( de es br ru )],
		snippets => [
		],
		tokens => [
		],
	},
}}

sub add_token_domains {
	my ( $self ) = @_;
	my $rs = $self->db->resultset('Token::Domain');
	for (keys %{$self->token_domains}) {
		my $data = $self->token_domains->{$_};
		my $base = delete $data->{base};
		my $languages = delete $data->{languages};
		push @{$languages}, $base;
		my $snippets = delete $data->{snippets};
		my $tokens = delete $data->{tokens};
		$data->{key} = $_;
		$data->{source_language_id} = $self->c->{languages}->{$base}->id;
		my $tc = $rs->create($data);
		my @translations;
		while (@{$snippets}) {
			my %msgid;
			$msgid{msgid} = shift @{$snippets};
			my $tl = shift @{$snippets};
			if (ref $tl ne 'HASH') {
				$msgid{msgid_plural} = $tl;
				$tl = shift @{$snippets};
			}
			my $token = $tc->create_related('tokens',{
				%msgid,
				snippet => 1,
			});
			push @translations, [ $token, $tl ];
		}
		while (@{$tokens}) {
			my $sn = shift @{$tokens};
			my $tl = shift @{$tokens};
			my $token = $tc->create_related('tokens',{
				name => $sn,
				snippet => 0,
			});
			push @translations, [ $token, $tl ];
		}
		my %tcl;
		for (@{$languages}) {
			$tcl{$_} = $tc->create_related('token_domain_languages',{
				language_id => $self->c->{languages}->{$_}->id,
			});
		}
		for (@translations) {
			my $token = shift @{$_};
			my $trans = shift @{$_};
			for my $u (keys %{$trans}) {
				if ($u eq 'notes') {
					for (keys %{$trans->{$u}}) {
						if ($_ eq 'token') {
							$token->notes($trans->{$u}->{$_});
							$token->update;
						} else {
							my $tl = $token->search_related('token_languages',{
								token_domain_language_id => $tcl{$_}->id,
							})->first;
							$tl->notes($trans->{$u}->{$_});
							$tl->update;
						}
					}
				} else {
					for (keys %{$trans->{$u}}) {
						my $tl = $token->search_related('token_languages',{
							token_domain_language_id => $tcl{$_}->id,
						})->first;
						my %msgstr;
						if (ref $trans->{$u}->{$_} eq 'ARRAY') {
							my $i = 0;
							for (@{$trans->{$u}->{$_}}) {
								$msgstr{'msgstr'.$i} = $_;
								$i++;
							}
						} else {
							$msgstr{msgstr0} = $trans->{$u}->{$_},
						}
						$tl->create_related('token_language_translations',{
							username => $u,
							%msgstr,
						});
					}
				}
			}
		}
		$_->auto_use for ($tc->token_domain_languages->search_related('token_languages')->all);
	}
}

1;





