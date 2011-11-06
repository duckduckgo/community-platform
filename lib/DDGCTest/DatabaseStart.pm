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
	'duckduckgo-duckduckgo' => {
		name => 'DuckDuckGo Core',
		base => 'us',
		description => 'Snippets around the core pages of DuckDuckGo, the homepage, the resultpage, the settings and the ZeroClickInfo in there',
		languages => [qw( us de es ru )],
		snippets => [
		    'Settings', {
				notes => {
					token => 'In the top menu',
				},
		    },
		    'Goodies', {
				notes => {
					token => 'In the top menu',
				},
		    },
		    'Team Duck', {
				notes => {
					token => 'In the top menu',
				},
		    },
		    'Results', {
				notes => {
					token => 'In the top menu under Settings',
				},
		    },
		    'Privacy', {
				notes => {
					token => 'In the top menu under Settings',
				},
		    },
		    'Colors', {
				notes => {
					token => 'In the top menu under Settings',
				},
		    },
		    'Look', {
				notes => {
					token => 'In the top menu under Settings',
				},
		    },
		    'Interface', {
				notes => {
					token => 'In the top menu under Settings',
				},
		    },
		    'All Settings', {
				notes => {
					token => 'In the top menu under Settings',
				},
		    },
		    'URL Params', {
				notes => {
					token => 'In the top menu under Settings',
				},
		    },
		    'Load/Reset', {
				notes => {
					token => 'In the top menu under Settings',
				},
		    },
		    'Shortcuts', {
				notes => {
					token => 'In the top menu under Goodies',
				},
		    },
		    'Technical', {
				notes => {
					token => 'In the top menu under Goodies',
				},
		    },
		    'Add-ons', {
				notes => {
					token => 'In the top menu under Goodies',
				},
		    },
		    'About', {
				notes => {
					token => 'In the top menu under Goodies',
				},
		    },
		    'Privacy', {
				notes => {
					token => 'In the top menu under Goodies',
				},
		    },
		    'Add to %s', {
				notes => {
					token => 'In the top menu under Team Duck -- %s will be browser names, like Firefox.',
				},
		    },
		    'Get results for different meanings of %s', {
				notes => {
					token => 'In 0-click box -- for disambiguation.'
				},
		    },
		    'See also', {
				notes => {
					token => 'In 0-click box -- for disambiguation.'
				},
		    },
		    'Other uses', {
				notes => {
					token => 'In 0-click box -- for disambiguation.'
				},
		    },
		    'Meanings', {
				notes => {
					token => 'In 0-click box -- for disambiguation.'
				},
		    },
		    'Dictionary', {
				notes => {
					token => 'In 0-click box -- link to definition.'
				},
		    },
		    'Category', {
				notes => {
					token => 'In 0-click box -- link to category page.'
				},
		    },
		    'More related topics', {
				notes => {
					token => 'In 0-click box -- link to category page.'
				},
		    },
		    'More at %s', {
				notes => {
					token => 'In 0-click box -- %s will be a site name, like Wikipedia.'
				},
		    },
		    'Entry in %s', {
				notes => {
					token => 'In results when 0-click box cannot be displayed for some reason -- %s will be a site name, like Wikipedia.'
				},
		    },
		    'Official site', {
				notes => {
					token => 'Whether a site is official or not.'
				},
		    },
		    'Ads via %s', {
				notes => {
					token => 'For advertising -- %s will be an ad provider, like Amazon.'
				},
		    },
		    'Search ideas', {
				notes => {
					token => 'A label for the search ideas feature.'
				},
		    },
		    'More results', {
				notes => {
					token => 'A link to get more results from a particular domain.'
				},
		    },
		    'results by %s', {
				notes => {
					token => 'Used to identify sources -- %s will be a source, like Bing.'
				},
		    },
		    'built with %s', {
				notes => {
					token => 'Used to identify underyling technology -- %s will be a name, like Yahoo!.'
				},
		    },
		    'What does this mean?', {
				notes => {
					token => 'Used to link to a question on our help center.'
				},
		    },
		    'More links', {
				notes => {
					token => 'A link to get more results (when auto-scroll is off or in special cases).'
				},
		    },
		    'more', {
				notes => {
					token => 'Used to point to additional social networking profiles (in results).'
				},
		    },
		    'Special', {
				notes => {
					token => 'Used in the !bang dropdown.'
				},
		    },
		    'Try search on', {
				notes => {
					token => 'Used in the !bang dropdown.'
				},
		    },
		    'Show all', {
				notes => {
					token => 'Used in the !bang dropdown.'
				},
		    },
		    'By category', {
				notes => {
					token => 'Used in the !bang dropdown.'
				},
		    },
		    'Alphabetically', {
				notes => {
					token => 'Used in the !bang dropdown.'
				},
		    },
		    'Map', {
				notes => {
					token => 'Used in 0-click box for local results, e.g. http://duckduckgo.com/?q=black+lab+bistro'
				},
		    },
		    'Nearby', {
				notes => {
					token => 'Used in 0-click box for local results, e.g. http://duckduckgo.com/?q=black+lab+bistro'
				},
		    },
		    'Computed by %s', {
				notes => {
					token => 'Used in 0-click box for attribution -- %s would be a provider, like Wolfram|Alpha'
				},
		    },
		    '%s is a zip code in %s', {
				notes => {
					token => 'Used in 0-click box for local results, e.g. https://duckduckgo.com/?q=19460'
				},
		    },

		    '%s is a phone number in %s', {
				notes => {
					token => 'Used in 0-click box for local results, e.g. https://duckduckgo.com/?q=%28323%29+319-6185'
				},
		    },
		    'shipment tracking', {
				notes => {
					token => 'Used in goodie results, e.g. https://duckduckgo.com/?q=1Z0884XV0399906189'
				},
		    },
		    'Reverse search', {
				notes => {
					token => 'Used in goodie results, e.g. https://duckduckgo.com/?q=%28323%29+319-6185'
				},
		    },
		    'pay', {
				notes => {
					token => 'Used in goodie results, e.g. https://duckduckgo.com/?q=%28323%29+319-6185'
				},
		    },
		    'vehicle info', {
				notes => {
					token => 'Used in goodie results, e.g. https://duckduckgo.com/?q=1g8gg35m1g7123101'
				},
		    },
		    'Reviews', {
				notes => {
					token => 'Used in 0-click box for product results, e.g. https://duckduckgo.com/?q=9780061353246'
				},
		    },
		    'random number', {
				notes => {
					token => 'Used in 0-click box for goodies, e.g. https://duckduckgo.com/?q=random+number'
				},
		    },
		    'random password', {
				notes => {
					token => 'Used in 0-click box for goodies, e.g. https://duckduckgo.com/?q=random+password'
				},
		    },
		    'random', {
				notes => {
					token => 'Used in 0-click box for goodies, e.g. https://duckduckgo.com/?q=yes+or+no'
				},
		    },
		    '%s is in', {
				notes => {
					token => 'Used in 0-click box for local results, e.g. https://duckduckgo.com/?q=72.94.249.36'
				},
		    },
		    'try to go there', {
				notes => {
					token => 'Used in goodie results, e.g. https://duckduckgo.com/?q=72.94.249.36'
				},
		    },
		    '%s is a parked domain (last time we checked).', {
				notes => {
					token => 'Message displayed sometimes at top of results.'
				},
		    },
		    'Try: %s', {
				notes => {
					token => 'Message displayed sometimes at top of results (for bang syntax), e.g. https://duckduckgo.com/?q=twitter+test'
				},
		    },
		    'Searches %s using our %s', {
				notes => {
					token => 'Message displayed sometimes at top of results (for bang syntax), e.g. https://duckduckgo.com/?q=twitter+test'
				},
		    },
		    'Offers', {
				notes => {
					token => 'Used in 0-click box for product results, e.g. https://duckduckgo.com/?q=9780061353246'
				},
		    },
		    'Similar', {
				notes => {
					token => 'Used in 0-click box for product results, e.g. https://duckduckgo.com/?q=9780061353246'
				},
		    },
		    'Library', {
				notes => {
					token => 'Used in 0-click box for product results, e.g. https://duckduckgo.com/?q=9780061353246'
				},
		    },
		    'Top', {
				notes => {
					token => 'Used in headings on Category pages, e.g. https://duckduckgo.com/?q=simpsons+characters'
				},
		    },
		    'Web links', {
				notes => {
					token => 'Used in heading on bottom of Category pages, e.g. https://duckduckgo.com/?q=simpsons+characters'
				},
		    },
		    'No right topic? Try web links...', {
				notes => {
					token => 'Used at the bottom of Category pages, e.g. https://duckduckgo.com/?q=simpsons+characters'
				},
		    },
		    'DDG Topics List', {
				notes => {
					token => 'Used at the bottom of Category pages, e.g. https://duckduckgo.com/?q=simpsons+characters'
				},
		    },
		    'uses results from %s', {
				notes => {
					token => 'Used at the top of results for source attribution -- %s is a source name, like Blekko'
				},
		    },
		    'ignore this box please', {
				notes => {
					token => 'Used for some hidden HTML elements'
				},
		    },
		    'put search terms here', {
				notes => {
					token => 'Used if you enter nothing in the search box.'
				},
		    },
		    'I\m feeling ducky', {
				notes => {
					token => 'Used in the !bang dropdown.'
				},
		    },
		    'sort by date', {
				notes => {
					token => 'Used in the !bang dropdown.'
				},
		    },
		    'Images', {
				notes => {
					token => 'Used in the !bang dropdown.'
				},
		    },
		    'News', {
				notes => {
					token => 'Used in the !bang dropdown.'
				},
		    },
		    'This page requires %s', {
				notes => {
					token => 'Used for browsers not meeting certain requirements.'
				},
		    },
		    'Get the non-JS version', {
				notes => {
					token => 'Used for browsers not having JavaScript.'
				},
		    },
		    'privacy policy', {
				notes => {
					token => 'Link on the homepage.'
				},
		    },
		    'bubble', {
				notes => {
					token => 'Link on the homepage in the context of the Filter Bubble and dontbubble.us'
				},
		    },
		    \'donttrackus', 'track', {
				notes => {
					token => 'Link on the homepage in the context of the No Tracking and donttrack.us'
				},
		    },
		    'We don\'t %s or %s you!', {
				notes => {
					token => 'On the homepage.'
				},
		    },
		    'See our %s', {
				notes => {
					token => 'On the homepage.'
				},
		    },
		    'Set as Homepage', {
				notes => {
					token => 'On the homepage.'
				},
		    },
		    '%s is a %s', {
				notes => {
					token => 'Used in 0-click box for product results, e.g. https://duckduckgo.com/?q=9780061353246'
				},
		    },
		    'by %s', {
				notes => {
					token => 'Used in 0-click box for product results, e.g. https://duckduckgo.com/?q=9780061353246'
				},
		    },
		    'released %s', {
				notes => {
					token => 'Used in 0-click box for product results, e.g. https://duckduckgo.com/?q=9780061353246'
				},
		    },
		    'from %s', {
				notes => {
					token => 'Used in 0-click box for product results, e.g. https://duckduckgo.com/?q=9780061353246'
				},
		    },
		    'and %s', {
				notes => {
					token => 'Used in 0-click box for product results, e.g. https://duckduckgo.com/?q=superbad+dvd'
				},
		    },
		    '%d pg', '%d pgs', {
				notes => {
					token => 'An abbreviation for pages. Used in 0-click box for product results, e.g. https://duckduckgo.com/?q=9780061353246'
				},
		    },
		    '%d disc', '%d discs', {
				notes => {
					token => 'Used in ads for products, e.g. https://duckduckgo.com/?q=the+graduate+dvd'
				},
		    },
		    'book', {
				notes => {
					token => 'Used in 0-click box for product results, e.g. https://duckduckgo.com/?q=superbad+dvd'
				},
		    },
		    'album', {
				notes => {
					token => 'Used in 0-click box for product results, e.g. https://duckduckgo.com/?q=superbad+dvd'
				},
		    },
		    \'zci-product', 'track', {
				notes => {
					token => 'Used in 0-click box for product results, e.g. https://duckduckgo.com/?q=superbad+dvd'
				},
		    },
		    'Did yo mean %s?', {
				notes => {
					token => 'Used in spelling correction, e.g. https://duckduckgo.com/?q=testingg',
				},
		    },
		    'Listen', {
				notes => {
					token => 'Used in 0-click bot for video results, e.g. https://duckduckgo.com/?q=blink182+song',
				},
		    },
		    'Safe search filtered your search to %s', {
				notes => {
					token => 'Message displayed sometimes at top of results.'
				},
		    },
		    'Safe search filtered 0-click info for %s', {
				notes => {
					token => 'Message displayed sometimes at top of results.'
				},
		    },
		    'Use %s command to turn off temporarily.', {
				notes => {
					token => 'Message displayed sometimes at top of results.'
				},
		    },
		    'Turn off', {
				notes => {
					token => 'Message displayed sometimes at top of results -- in the context of safe search.'
				},
		    },
		    'temporarily', {
				notes => {
					token => 'Message displayed sometimes at top of results -- in the context of safe search.'
				},
		    },
		    'permanently', {
				notes => {
					token => 'Message displayed sometimes at top of results -- in the context of safe search.'
				},
		    },
		    'Keyboard shortcuts', {
				notes => {
					token => 'Section heading (for right column).'
				},
		    },
		    'Search syntax', {
				notes => {
					token => 'Section heading (for right column).'
				},
		    },
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
		description => 'Play around with the translation interface without doing any harm! :)',
		languages => [qw( us de es br ru )],
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
		tokens => [
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
}}

1;






