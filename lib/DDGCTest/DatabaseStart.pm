package DDGCTest::DatabaseStart;
#
# BE SURE YOU SAVE THIS FILE AS UTF-8 WITHOUT BYTE ORDER MARK (BOM)
#
######################################################################

use Moose;

extends 'DDGCTest::Database';

use utf8;

sub isa_ok {}
sub is {}

sub deploy {
	my ( $self ) = @_;
	$self->add_languages;
	$self->add_users;
	$self->add_token_domains;
}

#############################
#  _   _ ___  ___ _ __ ___
# | | | / __|/ _ \ '__/ __|
# | |_| \__ \  __/ |  \__ \
#  \__,_|___/\___|_|  |___/

sub users {{
	'yegg' => {
		public => 1,
		admin => 1,
		languages => {
			us => 5,
		},
	},
	'getty' => {
		public => 1,
		admin => 1,
		languages => {
			de => 5,
			us => 3,
		},
	},
}}

sub add_users {
	my ( $self ) = @_;
	for (keys %{$self->users}) {
		my $data = $self->users->{$_};
		$self->update_user($_,$data);
	}
	for (keys %{$self->users}) {
		my $user = $self->d->find_user($_);
		$self->is($user->username,$_,'Checking username');
		$self->isa_ok($user,'DDGC::User');
	}
}

sub update_user {
	my ( $self, $username, $data ) = @_;
	my $languages = delete $data->{languages};
	my $user = $self->d->find_user($username);
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

################################################################
#  _        _                                _            _
# | |_ ___ | | _____ _ __     ___ ___  _ __ | |_ _____  _| |_
# | __/ _ \| |/ / _ \ '_ \   / __/ _ \| '_ \| __/ _ \ \/ / __|
# | || (_) |   <  __/ | | | | (_| (_) | | | | ||  __/>  <| |_
#  \__\___/|_|\_\___|_| |_|  \___\___/|_| |_|\__\___/_/\_\\__|

sub token_domains {{
	'duckduckgo-results' => {
		name => 'DuckDuckGo Results',
		base => 'us',
		description => 'Snippets around the Resultpage of DuckDuckGo',
		languages => [qw( us de es br ru )],
		snippets => [
			'try $1', {
				notes => {
					token => 'note at the token directly',
					de => 'note for specific language translation of the token',
				},
			},
			'vehicle info', {},
			'map', {},
			'search', {},
			'try search on $1', {},
			'searches', {},
			'$1 uses our $2', {},
			'using our $1', {},
			'syntax', {},
			'more at $1', {},
			'more', {},
			'top', {},
			'official site', {},
			'random password', {},
			'random number', {},
			'random', {},
			'entry in $1', {},
			'web links', {},
			'try web links', {},
			'$1 can mean different things', {},
			'click what you meant by $1', {},
			'meanings', {},
			'some meanings', {},
			'more meanings', {},
			'dictionary', {},
			'shipment tracking', {},
			'try to go there', {},
			'$1 is a parked domain (last time we checked)', {},
			'$1 is an area code in $2', {},
			'$1 is a zip code in $2', {},
			'$1 is a phone number in $2', {},
			'reverse search', {},
			'pay', {},
			'free', {},
			'uses results from $1', {},
			'results from', {},
			'no right topic?', {},
			'some topics grouped into $1', {},
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
			'add to $1', {},
			'from any region', {},
			'I\'m feeling ducky', {},
			'sort by date', {},
			'popular', {},
			'programming', {},
			'images', {},
			'news', {},
			'zero-click info', {},
			'this page requires $1', {},
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
		languages => [qw( us de es br ru )],
		snippets => [
		],
		tokens => [
		],
	},
	'duckduckgo-settings' => {
		name => 'DuckDuckGo Settings',
		base => 'us',
		description => 'Snippets around the Settings of DuckDuckGo',
		languages => [qw( us de es br ru )],
		snippets => [
		],
		tokens => [
		],
	},
	'duckduckgo-community' => {
		name => 'DuckDuckGo Community',
		base => 'us',
		description => 'The translations for _THIS_ platform :-)',
		languages => [qw( us de es br ru )],
		snippets => [
		],
		tokens => [
		],
	},
	'test' => {
		name => 'Test area, playfield for you',
		base => 'us',
		description => 'The translations for _THIS_ platform :-)',
		languages => [qw( us de es br ru )],
		snippets => [
			'From $1 to $2 over $3' => {},
			'THIS IS SPARTA' => {},
			'You should duck $1' => {},
			'Around the world' => {},
			'I\'m a little teapot' => {},
			'Bird is the word' => {},
			'$1 is the $2' => {},
			'You have $1' => {},
			'$1 messages' => {},
		],
		tokens => [
		],
	},
}}

1;






