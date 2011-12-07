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
	$self->d->deploy_fresh;
	$self->add_languages;
	$self->add_token_domains;
}

#############################
#  _   _ ___  ___ _ __ ___
# | | | / __|/ _ \ '__/ __|
# | |_| \__ \  __/ |  \__ \
#  \__,_|___/\___|_|  |___/

# sub users {{
	# 'yegg' => {
		# public => 1,
		# admin => 1,
		# languages => {
			# us => 5,
		# },
	# },
	# 'getty' => {
		# public => 1,
		# admin => 1,
		# languages => {
			# de => 5,
			# us => 3,
		# },
	# },
# }}

# sub add_users {
	# my ( $self ) = @_;
	# for (keys %{$self->users}) {
		# my $data = $self->users->{$_};
		# $self->update_user($_,$data);
	# }
	# for (keys %{$self->users}) {
		# my $user = $self->d->find_user($_);
		# $self->is($user->username,$_,'Checking username');
		# $self->isa_ok($user,'DDGC::User');
	# }
# }

# sub update_user {
	# my ( $self, $username, $data ) = @_;
	# my $languages = delete $data->{languages};
	# my $user = $self->d->find_user($username);
	# $user->$_($data->{$_}) for (keys %{$data});
	# for (keys %{$languages}) {
		# $user->create_related('user_languages',{
			# language_id => $self->c->{languages}->{$_}->id,
			# grade => $languages->{$_},
		# });
	# }
	# $user->update;
	# $self->isa_ok($user,'DDGC::User');	
# }

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
		languages => [qw( de es br ru fr se in da )],
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
					token => 'Used in 0-click box for local results, e.g. <a href="http://duckduckgo.com/?q=black+lab+bistro">http://duckduckgo.com/?q=black+lab+bistro</a>'
				},
		    },
		    'Nearby', {
				notes => {
					token => 'Used in 0-click box for local results, e.g. <a href="http://duckduckgo.com/?q=black+lab+bistro">http://duckduckgo.com/?q=black+lab+bistro</a>'
				},
		    },
		    'Computed by %s', {
				notes => {
					token => 'Used in 0-click box for attribution -- %s would be a provider, like Wolfram|Alpha'
				},
		    },
		    '%s is a zip code in %s', {
				notes => {
					token => 'Used in 0-click box for local results, e.g. <a href="https://duckduckgo.com/?q=19460">https://duckduckgo.com/?q=19460</a>'
				},
		    },

		    '%s is a phone number in %s', {
				notes => {
					token => 'Used in 0-click box for local results, e.g. <a href="https://duckduckgo.com/?q=%28323%29+319-6185">https://duckduckgo.com/?q=%28323%29+319-6185</a>'
				},
		    },
		    'shipment tracking', {
				notes => {
					token => 'Used in goodie results, e.g. <a href="https://duckduckgo.com/?q=1Z0884XV0399906189">https://duckduckgo.com/?q=1Z0884XV0399906189</a>'
				},
		    },
		    'Reverse search', {
				notes => {
					token => 'Used in goodie results, e.g. <a href="https://duckduckgo.com/?q=%28323%29+319-6185">https://duckduckgo.com/?q=%28323%29+319-6185</a>'
				},
		    },
		    'pay', {
				notes => {
					token => 'Used in goodie results, e.g. <a href="https://duckduckgo.com/?q=%28323%29+319-6185">https://duckduckgo.com/?q=%28323%29+319-6185</a>'
				},
		    },
		    'vehicle info', {
				notes => {
					token => 'Used in goodie results, e.g. <a href="https://duckduckgo.com/?q=1g8gg35m1g7123101">https://duckduckgo.com/?q=1g8gg35m1g7123101</a>'
				},
		    },
		    'Reviews', {
				notes => {
					token => 'Used in 0-click box for product results, e.g. <a href="https://duckduckgo.com/?q=9780061353246">https://duckduckgo.com/?q=9780061353246</a>'
				},
		    },
		    'random number', {
				notes => {
					token => 'Used in 0-click box for goodies, e.g. <a href="https://duckduckgo.com/?q=random+number">https://duckduckgo.com/?q=random+number</a>'
				},
		    },
		    'random password', {
				notes => {
					token => 'Used in 0-click box for goodies, e.g. <a href="https://duckduckgo.com/?q=random+password">https://duckduckgo.com/?q=random+password</a>'
				},
		    },
		    'random', {
				notes => {
					token => 'Used in 0-click box for goodies, e.g. <a href="https://duckduckgo.com/?q=yes+or+no">https://duckduckgo.com/?q=yes+or+no</a>'
				},
		    },
		    '%s is in', {
				notes => {
					token => 'Used in 0-click box for local results, e.g. <a href="https://duckduckgo.com/?q=72.94.249.36">https://duckduckgo.com/?q=72.94.249.36</a>'
				},
		    },
		    'try to go there', {
				notes => {
					token => 'Used in goodie results, e.g. <a href="https://duckduckgo.com/?q=72.94.249.36">https://duckduckgo.com/?q=72.94.249.36</a>'
				},
		    },
		    '%s is a parked domain (last time we checked).', {
				notes => {
					token => 'Message displayed sometimes at top of results.'
				},
		    },
		    'Try: %s', {
				notes => {
					token => 'Message displayed sometimes at top of results (for bang syntax), e.g. <a href="https://duckduckgo.com/?q=twitter+test">https://duckduckgo.com/?q=twitter+test</a>'
				},
		    },
		    'Searches %s using our %s', {
				notes => {
					token => 'Message displayed sometimes at top of results (for bang syntax), e.g. <a href="https://duckduckgo.com/?q=twitter+test">https://duckduckgo.com/?q=twitter+test</a>'
				},
		    },
		    'Offers', {
				notes => {
					token => 'Used in 0-click box for product results, e.g. <a href="https://duckduckgo.com/?q=9780061353246">https://duckduckgo.com/?q=9780061353246</a>'
				},
		    },
		    'Similar', {
				notes => {
					token => 'Used in 0-click box for product results, e.g. <a href="https://duckduckgo.com/?q=9780061353246">https://duckduckgo.com/?q=9780061353246</a>'
				},
		    },
		    'Library', {
				notes => {
					token => 'Used in 0-click box for product results, e.g. <a href="https://duckduckgo.com/?q=9780061353246">https://duckduckgo.com/?q=9780061353246</a>'
				},
		    },
		    'Top', {
				notes => {
					token => 'Used in headings on Category pages, e.g. <a href="https://duckduckgo.com/?q=simpsons+characters">https://duckduckgo.com/?q=simpsons+characters</a>'
				},
		    },
		    'Web links', {
				notes => {
					token => 'Used in heading on bottom of Category pages, e.g. <a href="https://duckduckgo.com/?q=simpsons+characters">https://duckduckgo.com/?q=simpsons+characters</a>'
				},
		    },
		    'No right topic? Try web links...', {
				notes => {
					token => 'Used at the bottom of Category pages, e.g. <a href="https://duckduckgo.com/?q=simpsons+characters">https://duckduckgo.com/?q=simpsons+characters</a>'
				},
		    },
		    'DDG Topics List', {
				notes => {
					token => 'Used at the bottom of Category pages, e.g. <a href="https://duckduckgo.com/?q=simpsons+characters">https://duckduckgo.com/?q=simpsons+characters</a>'
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
		    'I\'m feeling ducky', {
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
					token => 'Used in 0-click box for product results, e.g. <a href="https://duckduckgo.com/?q=9780061353246">https://duckduckgo.com/?q=9780061353246</a>'
				},
		    },
		    'by %s', {
				notes => {
					token => 'Used in 0-click box for product results, e.g. <a href="https://duckduckgo.com/?q=9780061353246">https://duckduckgo.com/?q=9780061353246</a>'
				},
		    },
		    'released %s', {
				notes => {
					token => 'Used in 0-click box for product results, e.g. <a href="https://duckduckgo.com/?q=9780061353246">https://duckduckgo.com/?q=9780061353246</a>'
				},
		    },
		    'from %s', {
				notes => {
					token => 'Used in 0-click box for product results, e.g. <a href="https://duckduckgo.com/?q=9780061353246">https://duckduckgo.com/?q=9780061353246</a>'
				},
		    },
		    'and %s', {
				notes => {
					token => 'Used in 0-click box for product results, e.g. <a href="https://duckduckgo.com/?q=9780061353246">https://duckduckgo.com/?q=9780061353246</a>'
				},
		    },
		    '%d pg', '%d pgs', {
				notes => {
					token => 'An abbreviation for pages. Used in 0-click box for product results, e.g. https://duckduckgo.com/?q=9780061353246<a href="https://duckduckgo.com/?q=9780061353246">https://duckduckgo.com/?q=9780061353246</a>'
				},
		    },
		    '%d disc', '%d discs', {
				notes => {
					token => 'Used in ads for products, e.g. <a href="https://duckduckgo.com/?q=the+graduate+dvd">https://duckduckgo.com/?q=the+graduate+dvd</a>'
				},
		    },
		    'book', {
				notes => {
					token => 'Used in 0-click box for product results, e.g. <a href="https://duckduckgo.com/?q=superbad+dvd">https://duckduckgo.com/?q=superbad+dvd</a>'
				},
		    },
		    'album', {
				notes => {
					token => 'Used in 0-click box for product results, e.g. <a href="https://duckduckgo.com/?q=superbad+dvd">https://duckduckgo.com/?q=superbad+dvd</a>'
				},
		    },
		    \'zci-product', 'track', {
				notes => {
					token => 'Used in 0-click box for product results, e.g. <a href="https://duckduckgo.com/?q=superbad+dvd">https://duckduckgo.com/?q=superbad+dvd</a>'
				},
		    },
		    'Did you mean %s?', {
				notes => {
					token => 'Used in spelling correction, e.g. <a href="https://duckduckgo.com/?q=testingg">https://duckduckgo.com/?q=testingg</a>',
				},
		    },
		    'Listen', {
				notes => {
					token => 'Used in 0-click bot for video results, e.g. <a href="https://duckduckgo.com/?q=blink182+song">https://duckduckgo.com/?q=blink182+song</a>',
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
		texts => [
		],
	},
	# 'duckduckgo-community' => {
		# name => 'DuckDuckGo Community',
		# base => 'us',
		# description => 'The translations for _THIS_ platform :-)',
		# languages => [qw( us de es br ru )],
		# snippets => [
		# ],
		# texts => [
		# ],
	# },
	'test' => {
		name => 'Test area, playfield for you',
		base => 'us',
		description => 'Play around with the translation interface without doing any harm! :)',
		languages => [qw( de es br ru fr se in da )],
		snippets => [
			'I\'m a little teapot', {},
			'I will not buy this record; it is scratched.', {},
			'We like searching with DuckDuckGo', {},
			\'Family Guy','Bird is the word', {},
			\'Earth', 'Hello world!', {},
			\'Mars', 'Hello world!', {},
			'You should duck %s', {},
			'From %s to %s', { notes => { token => 'Good example for changing order, you could translate it with "To %2$s from %1$s"' } },
			'You have %s friend', 'You have %s friends', {},
			\'Email', 'You have %s message', 'You have %s messages', {},
			\'Instant Messaging', 'You have %s message', 'You have %s messages', {},
			'%s is better as %s', {},
			'Always look on the bright side of life.', {},
			'We are no longer the knights who say %s! We are now the knights who say %s!', {},
			'I don\'t think there\'s a punch-line scheduled, is there?', {},
			'Yes', {},
			'No', {},
			'Why are dogs noses always wet?', {},
			'Why is 6 afraid of 7? Cause 7 8 9!', { notes => { token => 'Haha, try to translate the joke :-P' } },
			'And I shall go on talking in a low voice while the sea sounds in the distance and overhead the great black flood of wind polishes the bright stars.', {},
			'Downloading', {},
			'I stepped on a Cornflake, and now I am a cereal killer.', {},
			'Loading %s done', { notes => { token => '%s would be a percent number, like 73%' } },
			'Contribution', {},
			'What happens if you get scared half to death twice?', {},
			'Development', {},
			'Developers', {},
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
}}

1;






