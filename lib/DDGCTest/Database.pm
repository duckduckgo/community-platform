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
	'se' => {
		name_in_english => 'Swedish in Sweden',
		name_in_local => 'Svenska i Sverige',
		locale => 'sv_SE',
		flagicon => 'se',
	},
	'fr' => {
		name_in_english => 'French in France',
		name_in_local => 'Français en France',
		locale => 'fr_FR',
		flagicon => 'fr',
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
	'test' => {
		name => 'Test area, playfield for you',
		base => 'us',
		description => 'Play around with the translation interface without doing any harm! :)',
		languages => [qw( de es br ru fr se in )],
		snippets => [
			'From %s to %s over %s', {},
			'THIS IS SPARTA', {},
			'You should duck %s', {},
			'Around the world', {},
			'I\'m a little teapot', {},
			'Bird is the word', {},
			'%s is the %s', {},
			'You have %s', {},
			'%s message', '%s messages', {},
		],
		texts => [
			'::test::something::1' => {
				notes => {
					token => 'The first paragraph should be about love'
				},
			},
			'::test::something::2' => {
				notes => {
					token => 'The second paragraph should be about war'
				},
			},
			'::test::something::3' => {
				notes => {
					token => 'And the third paragraph should be about DuckDuckGo!'
				},
			},
		],
	},
	'test-domain' => {
		name => 'The domain of tests',
		base => 'us',
		description => 'Bla blub the test is dead the test is dead!',
		languages => [qw( de es br ru fr se in )],
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
					'us' => 'Welcomee %s',
				},
			},
			'You are %s from %s', {
				testone => {
					'de' => 'Du bist %s aus %s',
					'us' => 'You, ofda %2$s u %1$s',
				},
				testthree => {
					'us' => 'You are %s from %s',
				},
				testfive => {
					'ru' => 'Вы %s из %s',
					'us' => 'You ar %s from %s',
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
					'ru' => [ 'У вас %d сообщение', 'У вас %d сообщения', 'У вас %d сообщений' ],					
					'us' => [ 'You have %d mssage', 'You have %d messges' ],
				},
			},
			'No idea', {},
			'No clue', {},
			'Wtf is that?', {},
			'Come again?', {},
			'Trying to be funny?', {},
			'Umm, I gotta run, talk to you later!', {},
			'Leave me alone', 'Leave me alone', {},
			'Do I have to know that?', {},
			'My dum-dum wants gum-gum', {},
			'Pay me!', 'Pay me!', {},
			'Hold on a sec... just wait...umm I\'ll be right back!!', {},
			'Mooooooo-o-o', {},
			'Huh?', {},
			'Waddayawant?!', {},
			'Yeah, right!! Keep on waiting!', {},
			'*yawn*', {},
			'Don\'t leave! I\'m coming!', {},
			'Where is my sugar?', {},
			'I\'m not that smart :(', {},
			'lalalala-lala-lala', 'lalalala-lala-lala', {},
			'me iz teh suck, ask some1 else', {},
			'must.... eat... batteries..', {},
			'Something tells me you are trying to fool me...', {},
			'NO! I will NOT tell you that!', {},
			'Stop picking on bots, you racist!!', {},
			'Do you have to bug me so much just because I am a bot?', {},
			'Not enough megahurts :(', {},
			'Can\'t tell you, it\'s a secret!', {},
			'Hrooop, something\'s broke!', {},
			'If you don\'t know, why should I? >:O', {},
		],
		texts => [
		],
	},
	'more-tests' => {
		name => 'The domain of other tests wow!',
		base => 'us',
		description => 'PRAISE THE TEST!',
		languages => [qw( de es br ru fr se in )],
		snippets => [
			'Yes dude %s %s %s', {
				testone => {
					'de' => 'Jawohl %s Der %s Herr %s',
					'us' => 'Yeah %s douche %s %s',
				},
				testthree => {
					'us' => 'Yes dude %s %s %s',
				},
				testfive => {
					'ru' => 'Привет %s %s %s',
					'us' => 'Welcomee %s %s %s',
				},
			},
			\'testarea','Yes dude %s %s %s', {
				testone => {
					'de' => 'Jawohl %s Der %s Herr %s',
					'us' => 'Yeah %s douche %s %s',
				},
				testthree => {
					'us' => 'Yes dude %s %s %s',
				},
				testfive => {
					'ru' => 'Привет %s %s %s',
					'us' => 'Welcomee %s %s %s',
				},
			},
			'You are %s from %s', {
				testone => {
					'de' => 'Du bist %s aus %s',
					'us' => 'You, ofda %2$s u %1$s',
				},
				testthree => {
					'us' => 'You are %s from %s',
				},
				testfive => {
					'ru' => 'Вы %s из %s',
					'us' => 'You ar %s from %s',
				},
			},
			\'email', 'You have %d message', 'You have %d messages', {
				testone => {
					'de' => [ 'Du hast %d Nachricht', 'Du hast %d Nachrichten' ],
					'us' => [ 'Yu hav %d meage', 'Yuuu hve %d meages' ],
				},
				testthree => {
					'us' => [ 'You have %d message', 'You have %d messages' ],
				},
				testfive => {
					'ru' => [ 'У вас %d сообщение', 'У вас %d сообщения', 'У вас %d сообщений' ],					
					'us' => [ 'You have %d mssage', 'You have %d messges' ],
				},
			},
			\'community', 'You have %d message', 'You have %d messages', {
				testone => {
					'de' => [ 'Du hast %d Nachricht', 'Du hast %d Nachrichten' ],
					'us' => [ 'Yu hav %d meage', 'Yuuu hve %d meages' ],
				},
				testthree => {
					'us' => [ 'You have %d message', 'You have %d messages' ],
				},
				testfive => {
					'ru' => [ 'У вас %d сообщение', 'У вас %d сообщения', 'У вас %d сообщений' ],					
					'us' => [ 'You have %d mssage', 'You have %d messges' ],
				},
			},
		],
		texts => [
		],
	},
	'feeling-words' => {
		name => 'taken from some list of feeling words',
		base => 'us',
		description => 'feelings.. nothing more then feelings!',
		languages => [qw( de ru )],
		snippets => [
			'abominable',{},
			'absorbed',{},
			'accepting',{},
			'aching',{},
			'admiration',{},
			'affected',{},
			'affectionate',{},
			'afflicted',{},
			'aggressive',{},
			'agonized',{},
			'alarmed',{},
			'alienated',{},
			'alone',{},
			'amazed',{},
			'anguish',{},
			'animated',{},
			'annoyed',{},
			'anxious',{},
			'appalled',{},
			'a sense of loss',{},
			'ashamed',{},
			'at ease',{},
			'attracted',{},
			'bad',{},
			'bitter',{},
			'blessed',{},
			'boiling',{},
			'bold',{},
			'bored',{},
			'brave',{},
			'bright',{},
			'calm',{},
			'certain',{},
			'challenged',{},
			'cheerful',{},
			'clever',{},
			'close',{},
			'cold',{},
			'comfortable',{},
			'comforted',{},
			'concerned',{},
			'confident',{},
			'considerate',{},
			'content',{},
			'courageous',{},
			'cowardly',{},
			'cross',{},
			'crushed',{},
			'curious',{},
			'daring',{},
			'dejected',{},
			'delighted',{},
			'deprived',{},
			'desolate',{},
			'despair',{},
			'desperate',{},
			'despicable',{},
			'determined',{},
			'detestable',{},
			'devoted',{},
			'diminished',{},
			'disappointed',{},
			'discouraged',{},
			'disgusting',{},
			'disillusioned',{},
			'disinterested',{},
			'dismayed',{},
			'dissatisfied',{},
			'distressed',{},
			'distrustful',{},
			'dominated',{},
			'doubtful',{},
			'drawn toward',{},
			'dull',{},
			'dynamic',{},
			'eager',{},
			'earnest',{},
			'easy',{},
			'ecstatic',{},
			'elated',{},
			'embarrassed',{},
			'empty',{},
			'encouraged',{},
			'energetic',{},
			'engrossed',{},
			'enraged',{},
			'enthusiastic',{},
			'excited',{},
			'fascinated',{},
			'fatigued',{},
			'fearful',{},
			'festive',{},
			'forced',{},
			'fortunate',{},
			'free',{},
			'free and easy',{},
			'frightened',{},
			'frisky',{},
			'frustrated',{},
			'fuming',{},
			'gay',{},
			'glad',{},
			'gleeful',{},
			'great',{},
			'grief',{},
			'grieved',{},
			'guilty',{},
			'hardy',{},
			'hateful',{},
			'heartbroken',{},
			'hesitant',{},
			'hopeful',{},
			'hostile',{},
			'humiliated',{},
			'important',{},
			'impulsive',{},
			'in a stew',{},
			'incapable',{},
			'incensed',{},
			'indecisive',{},
			'in despair',{},
			'indignant',{},
			'inferior',{},
			'inflamed',{},
			'infuriated',{},
			'injured',{},
			'inquisitive',{},
			'insensitive',{},
			'inspired',{},
			'insulting',{},
			'intent',{},
			'interested',{},
			'intrigued',{},
			'irritated',{},
			'joyous',{},
			'jubilant',{},
			'keen',{},
			'kind',{},
			'liberated',{},
			'lifeless',{},
			'lonely',{},
			'lost',{},
			'lousy',{},
			'loved',{},
			'loving',{},
			'lucky',{},
			'menaced',{},
			'merry',{},
			'miserable',{},
			'misgiving',{},
			'mournful',{},
			'nervous',{},
			'neutral',{},
			'nonchalant',{},
			'nosy',{},
			'offended',{},
			'offensive',{},
			'optimistic',{},
			'overjoyed',{},
			'pained',{},
			'panic',{},
			'paralyzed',{},
			'passionate',{},
			'pathetic',{},
			'peaceful',{},
			'perplexed',{},
			'pessimistic',{},
			'playful',{},
			'pleased',{},
			'powerless',{},
			'preoccupied',{},
			'provocative',{},
			'provoked',{},
			'quaking',{},
			'quiet',{},
			'reassured',{},
			'rebellious',{},
			'receptive',{},
			're-enforced',{},
			'rejected',{},
			'relaxed',{},
			'reliable',{},
			'repugnant',{},
			'resentful',{},
			'reserved',{},
			'restless',{},
			'satisfied',{},
			'scared',{},
			'secure',{},
			'sensitive',{},
			'serene',{},
			'shaky',{},
			'shy',{},
			'skeptical',{},
			'snoopy',{},
			'sore',{},
			'sorrowful',{},
			'spirited',{},
			'stupefied',{},
			'sulky',{},
			'sunny',{},
			'sure',{},
			'surprised',{},
			'suspicious',{},
			'sympathetic',{},
			'sympathy',{},
			'tearful',{},
			'tenacious',{},
			'tender',{},
			'tense',{},
			'terrible',{},
			'terrified',{},
			'thankful',{},
			'threatened',{},
			'thrilled',{},
			'timid',{},
			'tormented',{},
			'tortured',{},
			'touched',{},
			'tragic',{},
			'unbelieving',{},
			'uncertain',{},
			'understanding',{},
			'uneasy',{},
			'unhappy',{},
			'unique',{},
			'unpleasant',{},
			'unsure',{},
			'upset',{},
			'useless',{},
			'victimized',{},
			'vulnerable',{},
			'warm',{},
			'wary',{},
			'weary',{},
			'woeful',{},
			'wonderful',{},
			'worked up',{},
			'worried',{},
			'wronged',{},
		],
		texts => [
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
		my $texts = delete $data->{texts};
		$data->{key} = $_;
		$data->{source_language_id} = $self->c->{languages}->{$base}->id;
		my $tc = $rs->create($data);
		my @translations;
		while (@{$snippets}) {
			my %msgid;
			if (ref $snippets->[0] eq 'SCALAR') {
				$msgid{msgctxt} = ${shift @{$snippets}};
			}
			$msgid{msgid} = shift @{$snippets};
			my $tl = shift @{$snippets};
			if (ref $tl ne 'HASH') {
				$msgid{msgid_plural} = $tl;
				$tl = shift @{$snippets};
			}
			my $token = $tc->create_related('tokens',{
				%msgid,
				type => 1,
			});
			push @translations, [ $token, $tl ];
		}
		while (@{$texts}) {
			my $sn = shift @{$texts};
			my $tl = shift @{$texts};
			my $token = $tc->create_related('tokens',{
				msgid => $sn,
				type => 2,
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