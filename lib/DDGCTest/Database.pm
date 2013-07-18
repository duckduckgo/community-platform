package DDGCTest::Database;
# ABSTRACT: 
#
# BE SURE YOU SAVE THIS FILE AS UTF-8 WITHOUT BYTE ORDER MARK (BOM)
#
######################################################################

use Moose;
use DDGC::DB;
use utf8;
use File::ShareDir::ProjectDistDir;
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

has init => (
	is => 'ro',
	predicate => 'has_init',
);

has progress => (
	is => 'ro',
	predicate => 'has_progress',
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
    my ( $class, $ddgc, $test, $init, $progress ) = @_;
	my %options;
	$options{_ddgc} = $ddgc;
	$options{test} = $test;
	$options{init} = $init if $init;
	$options{progress} = $progress if $progress;
	return \%options;
}

sub deploy {
	my ( $self ) = @_;
	$self->d->deploy_fresh;
	$self->init->($self->step_count) if $self->has_init;
	$self->add_languages;
	$self->add_users;
	$self->add_token_domains;
	$self->add_distributions;
	$self->add_threads;
	$self->add_comments;
	$self->d->envoy->update_own_notifications;
	if ($self->test) {
		$self->test_userpage;
		$self->test_event;
	}
}

has current_step => (
	is => 'rw',
	default => sub { 0 },
);

sub next_step {
	my ( $self ) = @_;
	return unless $self->has_progress;
	my $step = $self->current_step + 1;
	$self->progress->($step);
	$self->current_step($step);
}

sub step_count {
	my ( $self ) = @_;
	my $base = 404;
	return $base unless $self->test;
}

sub isa_ok { ::isa_ok($_[0],$_[1]) if shift->test }
sub is { ::is($_[0],$_[1],$_[2]) if shift->test }

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
	'da' => {
		name_in_english => 'Danish in Denmark',
		name_in_local => 'Dansk i Danmark',
		locale => 'da_DK',
		flagicon => 'dk',
	},
	'ar' => {
		name_in_english => 'Arabic in Egypt',
		name_in_local => 'العربية - مصر',
		locale => 'ar_EG',
		flagicon => 'eg',
		rtl => 1,
	},
}}

sub add_languages {
	my ( $self ) = @_;
	my $rs = $self->db->resultset('Language');
	for (sort keys %{$self->languages}) {
		$self->c->{languages}->{$_} = $rs->create($self->languages->{$_});
		$self->isa_ok($self->c->{languages}->{$_},'DDGC::DB::Result::Language');
		$self->next_step;
	}
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
		notes => 'Testuser, public, es',
		languages => {
			es => 6,
		},
		data => {
			userpage => {
				twitter => 'duckduckgo',
				email => 'some@universe.org',
				web => 'https://duckduckgo.com/',
				about => 'about duckduckgo on twitter',
				whyddg => 'because it\'s awesome!',
			},
			email => 'testtwo@localhost',
		},
		notifications => [
			[ 2, 'DDGC::DB::Result::Comment' ],
			[ 2, 'DDGC::DB::Result::Token::Language::Translation' ],
			[ 2, 'DDGC::DB::Result::Token' ],
		],
	},
	'testthree' => {
		pw => '1234test',
		public => 1,
		roles => 'translation_manager',
		notes => 'Testuser, public, us, ar, de',
		languages => {
			us => 6,
			ar => 5,
			de => 4,
		},
		data => {
			userpage => {
				web => 'https://test.de/',
			},
			email => 'testthree@localhost',
		},
	},
	'testfour' => {
		pw => '1234test',
		notes => 'Testuser, admin, de, es, us',
		admin => 1,
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
	'cpan' => {
		pw => 'üöüöüöüöäöü',
		notes => 'CPAN upload account for CPAN pinning',
		admin => 1,
		languages => {
			us => 5,
		},
	},
	map {
		'test'.$_ => {
			pw => $_.$_,
			notes => 'Massuser',
		}
	} 1..40,
}}

sub add_users {
	my ( $self ) = @_;
	my $testone = $self->d->create_user('testone','blabla');
	$self->isa_ok($testone,'DDGC::User');
	$testone->admin(1);
	$testone->public(1);
	$testone->notes('Testuser, admin');
	$testone->create_related('user_languages',{
		language_id => $self->c->{languages}->{'de'}->id,
		grade => 5,
	});
	$testone->create_related('user_languages',{
		language_id => $self->c->{languages}->{'us'}->id,
		grade => 3,
	});
	$testone->data({
		userpage => {
			github => 'duckduckgo',
			web => 'https://duckduckgo.com/',
			about => 'about me',
			whyddg => 'because it\'s awesome!',
		},
		email => 'testone@localhost',
	});
	$testone->update;
	for (qw(
		DDGC::DB::Result::Comment
		DDGC::DB::Result::Token::Language::Translation
		DDGC::DB::Result::Token
	)) {
		$testone->create_related('user_notifications',{
			context => $_,
			cycle => 2,
		});
	}
	$self->c->{users}->{testone} = $testone;
	$self->next_step;
	for (sort keys %{$self->users}) {
		my $data = $self->users->{$_};
		my $username = $_;
		my $pw = delete $data->{pw};
		my $languages = delete $data->{languages};
		my @notifications = defined $data->{notifications} ?
			(@{delete $data->{notifications}}) : ();
		my $user = $self->d->create_user($username,$pw);
		$user->$_($data->{$_}) for (keys %{$data});
		for (keys %{$languages}) {
			$user->create_related('user_languages',{
				language_id => $self->c->{languages}->{$_}->id,
				grade => $languages->{$_},
			});
		}
		$user->update;
		$self->c->{users}->{$username} = $user;
		for (@notifications) {
			$user->create_related('user_notifications',{
				cycle => $_->[0],
				context => $_->[1],
				context_id => $_->[2],
				sub_context => $_->[3],
			});
		}
        $self->isa_ok($user,'DDGC::User');
		$self->next_step;
	}
	for (sort keys %{$self->users}) {
		my $user = $self->d->find_user($_);
		$self->is($user->username,$_,'Checking username of '.$_);
		$self->isa_ok($user,'DDGC::User');
		$self->next_step;
	}
}

sub test_userpage {
	my ( $self ) = @_;
	for (sort keys %{$self->users}) {
		my $data = defined $self->users->{$_}->{data}->{userpage}
			? $self->users->{$_}->{data}->{userpage}
			: {};
		my $username = $_;
		my $userpage = $self->d->find_user($_)->userpage->export;
		if (%{$data}) {
			for (qw( about whyddg web )) {
				$self->is($userpage->{$_},defined $data->{$_} ? $data->{$_} : '','Checking '.$username.' userpage export value of '.$_);
			}
			$self->is($userpage->{github},defined $data->{github} ? 'https://github.com/'.$data->{github} : '','Checking '.$username.' userpage export value of github');
			$self->is($userpage->{email},defined $data->{email} ? _replace_email($data->{email}) : '','Checking '.$username.' userpage export value of github');
		} else {
			for (keys %{$userpage}) {
				$self->is($userpage->{$_},'','Checking '.$username.' userpage export value of '.$_.' being empty');
			}
		}
	}
}

sub test_event {
	my ( $self ) = @_;
	my @events = $self->d->resultset('Event')->search({})->all;
	$self->is(scalar @events, 282, "Checking amount of events gathered");
	my @enos = $self->d->resultset('Event::Notification')->search({})->all;
	$self->is(scalar @enos, 523, "Checking amount of event notifications gathered");
}

sub _replace_email {
	my $email = $_[0];
	$email =~ s/@/ at /;
	return $email;
}

################################################################
#      _ _     _        _ _           _   _
#   __| (_)___| |_ _ __(_) |__  _   _| |_(_) ___  _ __  ___
#  / _` | / __| __| '__| | '_ \| | | | __| |/ _ \| '_ \/ __|
# | (_| | \__ \ |_| |  | | |_) | |_| | |_| | (_) | | | \__ \
#  \__,_|_|___/\__|_|  |_|_.__/ \__,_|\__|_|\___/|_| |_|___/


sub distributions {[
	[ testone => 'DDG-Something-0.001.tar.gz' ],
	[ testtwo => 'DDG-Plugin-OtherThing-MoreTest-0.001.tar.gz' ],
	[ testthree => 'DDG-Plugin-FatHead-Test-0.001.tar.gz' ],
	[ cpan => 'My-Sample-Distribution-0.003.tar.gz' ],
]}

sub add_distributions {
	my ( $self ) = @_;
	my $sharedir = dist_dir('DDGC');
	for (@{$self->distributions}) {
		my $username = $_->[0];
		my $filename = $_->[1];
		my $user = $self->d->find_user($username);
		$self->d->duckpan->add_user_distribution($user,$sharedir.'/testdists/'.$filename);
		$self->next_step;
	}
}

#####################################################
#                                          _
#   ___ ___  _ __ ___  _ __ ___   ___ _ __ | |_ ___
#  / __/ _ \| '_ ` _ \| '_ ` _ \ / _ \ '_ \| __/ __|
# | (_| (_) | | | | | | | | | | |  __/ | | | |_\__ \
#  \___\___/|_| |_| |_|_| |_| |_|\___|_| |_|\__|___/

sub comments {
	my ($self) = @_;
	[
		testone => [
			
		],
	]
}

sub add_comments {
	my ( $self ) = @_;
}

##############################################
#  _____ _   _ ____  _____    _    ____  ____  
# |_   _| | | |  _ \| ____|  / \  |  _ \/ ___| 
#   | | | |_| | |_) |  _|   / _ \ | | | \___ \ 
#   | | |  _  |  _ <| |___ / ___ \| |_| |___) |
#   |_| |_| |_|_| \_\_____/_/   \_\____/|____/ 

sub threads {
    testone => { 
    	title => "Test thread",
    	text => "Testing some BBCode\n[b]Bold[/b]\n[url=http://ddg.gg]URL[/url] / http://ddg.gg\nEtc.",
    	category_id => 5,
    	data => { announcement_status_id => 1 }
    },
    testtwo => {
    	title => "Hello, World!",
    	text => "Hello, World!\n[code=perl]#!/usr/bin/env perl\nprint \"Hello, World!\";[/code]\n[code=lua]print(\"Hello, World\")[/code]\n[code=javascript]alert('Hello, World!');[/code]\n[quote=shakespeare](bb|[^b]{2})[/quote]\n\@testtwo I love you!",
    	category_id => 1,
    	data => { discussion_status_id => 1 },
    },
    testthree => {
    	title => "Syntax highlighting",
    	text => '[code=perl]#!/usr/bin/env perl
        use 5.014;
        say "Hello, World!";[/code]
        [code=javascript]document.write("Hello, World!");[/code]
        [code=lua]print("Hello, World!")[/code]
        [code=ada]with Text_IO;
        procedure Hello_World is
                begin
                        Text_IO.Put_line("Hello World!");
            end Hello_World;[/code]
        [code=basic]10 REM I am awesome.
        20 PRINT "Hello, World!"[/code]
        [code=c]#include<stdio.h>
        
        int main(void) {
                printf("Hello World\n");
                    return 0;
        }[/code]
        [code=sql]SELECT \'Hello World\' as hello_message;[/code]
        [code=yaml]text: Hello, World![/code]',
        category_id => 1,
        data => { discussion_status => 1 }
	},
}

sub add_threads {
    my $self = shift;
    my @threads = threads;

	my $rs = $self->db->resultset('Thread');

    while (@threads) {
    	my $username = shift @threads;
    	my %hash = %{shift @threads};
    	my $user = $self->c->{users}->{$username};
        my $thread = $user->create_related('threads',\%hash);
        #$thread->update;
        #$self->d->db->txn_do(sub { $thread->update });
        $self->next_step;
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
		name => 'The domain of tests',
		base => 'us',
		sorting => 200,
		description => 'Bla blub the test is dead the test is dead!',
		languages => [qw( de es br ru fr se in da ar )],
		snippets => [
			'Hello %s', [
				testone => [
					us => 'Heeellloooo %s', [],
				],
				testthree => [
					de => 'Hallo %s', [qw( testthree testfour )],
					us => 'Welcome %s', [],
				],
				testfour => [
					us => 'Welcome %s', [qw( testthree testfour )],
				],
				testfive => [
					ru => 'Привет %s', [qw( testthree testfour )],
					us => 'Welcomee %s', [],
				],
				notes => {
					token => 'This is a token note',
					de => 'Das ist eine deutsche Information',
					us => 'Thats an american information',
				},
			],
			'You are %s from %s', [
				testone => [
					us => 'You, ofda %2$s u %1$s', [],
				],
				testthree => [
					de => 'Du bist %s aus %s', [],
					de => 'Der %s isse aus %s', [],
					us => 'You are %s from %s', [],
				],
				testfive => [
					ru => 'Вы %s из %s', [],
					us => 'You ar %s from %s', [],
				],
			],
			\'testarea','Yes dude %s %s %s', [
				testone => [
					us => 'Yeah %s douche %s %s', [],
				],
				testthree => [
					de => "Jawohl %s \n Der %s Herr %s", [],
					us => 'Yes dude %s %s %s', [],
				],
				testfive => [
					ru => 'Привет %s %s %s', [],
					us => 'Welcomee %s %s %s', [],
				],
				notes => {
					token => 'This is a token note',
					de => 'Das ist eine deutsche Information',
					us => 'Thats an american information',
				},
			],
			\'email', 'You have %d message', 'You have %d messages', [
				testone => [
					us => 'Yu hav %d meage', 'Yuuu hve %d meages', [],
				],
				testthree => [
					de => 'Du hast %d Nachricht', 'Du hast %d Nachrichten', [],
					us => 'You have %d message', 'You have %d messages', [],
				],
				testfive => [
					ru => 'У вас %d сообщение', 'У вас %d сообщения', 'У вас %d сообщений', [],
					us => 'You have %d mssage', 'You have %d messges', [],
				],
				notes => {
					de => 'Das ist eine deutsche Information',
					us => 'Thats an american information',
				},
			],
			'You have %d message', 'You have %d messages', [
				testone => [
					us => 'Yu hav %d meage', 'Yuuu hve %d meages', [],
				],
				testthree => [
					de => 'Du hast "%d" Nachricht', 'Du hast "%d" Nachrichten', [],
					us => 'You have %d message', 'You have %d messages', [],
				],
				testfive => [
					ru => 'У вас %d сообщение', 'У вас %d сообщения', 'У вас %d сообщений', [],
					us => 'You have %d mssage', 'You have %d messges', [],
				],
				notes => {
					token => 'This is a token note',
				},
			],
			'No idea', [],
			'Leave me alone', 'Leave me alone', [],
			\'instantmessage', 'You have %d instant message', 'You have %d instant messages', [],
			'Wtf is that?', [],
			'Come again?', [],
		],
		texts => [
			'::test::something::1' => [
				notes => {
					token => 'The first paragraph should be about love'
				},
			],
			'::test::something::2' => [
				notes => {
					token => 'The second paragraph should be about war'
				},
			],
			'::test::something::3' => [
				notes => {
					token => 'And the third paragraph should be about DuckDuckGo!'
				},
			],
		],
	},
	'long-list-test' => {
		name => 'taken from some list of feeling words',
		base => 'us',
		description => 'feelings.. nothing more then feelings!',
		sorting => 100,
		languages => [qw( de ru ar )],
		snippets => [
			'abominable',[],
			'absorbed',[],
			'accepting',[],
			'aching',[],
			'admiration',[],
			'affected',[],
			'affectionate',[],
			'afflicted',[],
			'aggressive',[],
			'agonized',[],
			'alarmed',[],
			'alienated',[],
			'alone',[],
			'amazed',[],
			'anguish',[],
			'animated',[],
			'annoyed',[],
			'anxious',[],
			'appalled',[],
			'a sense of loss',[],
			'ashamed',[],
			'at ease',[],
			'attracted',[],
			'bad',[],
			'bitter',[],
			'blessed',[],
			'boiling',[],
			'bold',[],
			'bored',[],
			'brave',[],
			'bright',[],
			'calm',[],
			'certain',[],
			'challenged',[],
			'cheerful',[],
			'clever',[],
			'close',[],
			'cold',[],
			'comfortable',[],
			'comforted',[],
			'concerned',[],
			'confident',[],
			'considerate',[],
			'content',[],
			'courageous',[],
			'cowardly',[],
			'cross',[],
			'crushed',[],
			'curious',[],
			'daring',[],
			'dejected',[],
			'delighted',[],
			'deprived',[],
			'desolate',[],
			'despair',[],
			'desperate',[],
			'despicable',[],
			'determined',[],
			'detestable',[],
			'devoted',[],
			'diminished',[],
			'disappointed',[],
			'discouraged',[],
			'disgusting',[],
			'disillusioned',[],
			'disinterested',[],
			'dismayed',[],
			'dissatisfied',[],
			'distressed',[],
			'distrustful',[],
			'dominated',[],
			'doubtful',[],
			'drawn toward',[],
			'dull',[],
			'dynamic',[],
			'eager',[],
			'earnest',[],
			'easy',[],
			'ecstatic',[],
			'elated',[],
			'embarrassed',[],
			'empty',[],
			'encouraged',[],
			'energetic',[],
			'engrossed',[],
			'enraged',[],
			'enthusiastic',[],
			'excited',[],
			'fascinated',[],
			'fatigued',[],
			'fearful',[],
			'festive',[],
			'forced',[],
			'fortunate',[],
			'free',[],
			'free and easy',[],
			'frightened',[],
			'frisky',[],
			'frustrated',[],
			'fuming',[],
			'gay',[],
			'glad',[],
			'gleeful',[],
			'great',[],
			'grief',[],
			'grieved',[],
			'guilty',[],
			'hardy',[],
			'hateful',[],
			'heartbroken',[],
			'hesitant',[],
			'hopeful',[],
			'hostile',[],
			'humiliated',[],
			'important',[],
			'impulsive',[],
			'in a stew',[],
			'incapable',[],
			'incensed',[],
			'indecisive',[],
			'in despair',[],
			'indignant',[],
			'inferior',[],
			'inflamed',[],
			'infuriated',[],
			'injured',[],
			'inquisitive',[],
			'insensitive',[],
			'inspired',[],
			'insulting',[],
			'intent',[],
			'interested',[],
			'intrigued',[],
			'irritated',[],
			'joyous',[],
			'jubilant',[],
			'keen',[],
			'kind',[],
			'liberated',[],
			'lifeless',[],
			'lonely',[],
			'lost',[],
			'lousy',[],
			'loved',[],
			'loving',[],
			'lucky',[],
			'menaced',[],
			'merry',[],
			'miserable',[],
			'misgiving',[],
			'mournful',[],
			'nervous',[],
			'neutral',[],
			'nonchalant',[],
			'nosy',[],
			'offended',[],
			'offensive',[],
			'optimistic',[],
			'overjoyed',[],
			'pained',[],
			'panic',[],
			'paralyzed',[],
			'passionate',[],
			'pathetic',[],
			'peaceful',[],
			'perplexed',[],
			'pessimistic',[],
			'playful',[],
			'pleased',[],
			'powerless',[],
			'preoccupied',[],
			'provocative',[],
			'provoked',[],
			'quaking',[],
			'quiet',[],
			'reassured',[],
			'rebellious',[],
			'receptive',[],
			're-enforced',[],
			'rejected',[],
			'relaxed',[],
			'reliable',[],
			'repugnant',[],
			'resentful',[],
			'reserved',[],
			'restless',[],
			'satisfied',[],
			'scared',[],
			'secure',[],
			'sensitive',[],
			'serene',[],
			'shaky',[],
			'shy',[],
			'skeptical',[],
			'snoopy',[],
			'sore',[],
			'sorrowful',[],
			'spirited',[],
			'stupefied',[],
			'sulky',[],
			'sunny',[],
			'sure',[],
			'surprised',[],
			'suspicious',[],
			'sympathetic',[],
			'sympathy',[],
			'tearful',[],
			'tenacious',[],
			'tender',[],
			'tense',[],
			'terrible',[],
			'terrified',[],
			'thankful',[],
			'threatened',[],
			'thrilled',[],
			'timid',[],
			'tormented',[],
			'tortured',[],
			'touched',[],
			'tragic',[],
			'unbelieving',[],
			'uncertain',[],
			'understanding',[],
			'uneasy',[],
			'unhappy',[],
			'unique',[],
			'unpleasant',[],
			'unsure',[],
			'upset',[],
			'useless',[],
			'victimized',[],
			'vulnerable',[],
			'warm',[],
			'wary',[],
			'weary',[],
			'woeful',[],
			'wonderful',[],
			'worked up',[],
			'worried',[],
			'wronged',[],
		],
		texts => [
		],
	},
}}

sub add_token_domains {
	my ( $self ) = @_;
	my $rs = $self->db->resultset('Token::Domain');
	for (sort keys %{$self->token_domains}) {
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
			if (ref $tl ne 'ARRAY') {
				$msgid{msgid_plural} = $tl;
				$tl = shift @{$snippets};
			}
			my $token = $tc->create_related('tokens',{
				%msgid,
				type => 1,
			});
			$self->next_step;
			push @translations, [ $token, $tl ];
		}
		while (@{$texts}) {
			my $sn = shift @{$texts};
			my $tl = shift @{$texts};
			my $token = $tc->create_related('tokens',{
				msgid => $sn,
				type => 2,
			});
			$self->next_step;
			push @translations, [ $token, $tl ];
		}
		my %tcl;
		for (@{$languages}) {
			$tcl{$_} = $tc->create_related('token_domain_languages',{
				language_id => $self->c->{languages}->{$_}->id,
			});
			$self->next_step;
		}
		for (@translations) {
			my $token = $_->[0];
			my @user_trans = @{$_->[1]};
			while (@user_trans) {
				my $user_or_notes = shift @user_trans;
				my $data = shift @user_trans;
				if ($user_or_notes eq 'notes') {
					for (keys %{$data}) {
						if ($_ eq 'token') {
							$token->notes($data->{$_});
							$token->update;
						} else {
							my $tl = $token->search_related('token_languages',{
								token_domain_language_id => $tcl{$_}->id,
							})->first;
							$tl->notes($data->{$_});
							$tl->update;
						}
					}
				} else {
					my $user = $self->c->{users}->{$user_or_notes};
					my @trans_or_votes = @{$data};
					while (@trans_or_votes) {
						my $lang = shift @trans_or_votes;
						my $tl = $token->search_related('token_languages',{
							token_domain_language_id => $tcl{$lang}->id,
						})->first;
						my $i = 0;
						my @votes;
						my %msgstr;
						while (@trans_or_votes) {
							my $next = shift @trans_or_votes;
							if (ref $next eq 'ARRAY') {
								@votes = @{$next};
								last;
							} else {
								my $key = 'msgstr'.$i;
								$msgstr{$key} = $next;
								$i++;
							}
						}
						my $tlt = $tl->create_related('token_language_translations',{
							username => $user->username,
							%msgstr,
						});
						for (@votes) {
							my $voteuser = $self->c->{users}->{$_};
							$tlt->set_user_vote($voteuser,1);
							$self->next_step;
						}
					}
				}
				$self->next_step;
			}
		}
	}
}

no Moose;
__PACKAGE__->meta->make_immutable;
