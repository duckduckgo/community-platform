package DDGCTest::Database;
# ABSTRACT: 
#
# BE SURE YOU SAVE THIS FILE AS UTF-8 WITHOUT BYTE ORDER MARK (BOM)
#
######################################################################

use Moose;
use utf8;
use File::ShareDir::ProjectDistDir;
use Data::Printer;

use DDGC;
use DDGC::DB;
use DDGC::Config;
use DateTime::Format::RSS;

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

sub for_test {
	my ( $class, $tempdir ) = @_;
	my $ddgc = DDGC->new({ config => DDGC::Config->new(
		always_use_default => 1,
		rootdir_path => $tempdir,
		mail_test => 1,
	) });
	return $class->new($ddgc,1);
}

sub deploy {
	my ( $self ) = @_;
	$self->d->deploy_fresh;
	$self->init->($self->step_count) if $self->has_init;
	$self->add_languages;
	$self->add_helps;
	$self->add_users;
	$self->add_token_domains;
	$self->add_distributions;
	$self->add_threads;
	$self->add_comments;
	$self->add_blogs;
	$self->add_ideas;
	if ($self->test) {
		$self->update_notifications;
		$self->test_userpage;
		$self->test_event;
	}
}

sub update_notifications {
	my ( $self ) = @_;
	$self->d->envoy->update_all_notifications;
}

has current_step => (
	is => 'rw',
	default => sub { 0 },
);

sub next_step {
	my ( $self ) = @_;
	return unless $self->has_progress;
	my $step = $self->current_step + 1;
	warn "Step no. ".$step." is higher as step_count ".$self->step_count
		if $step > $self->step_count;
	$self->progress->($step);
	$self->current_step($step);
}

sub step_count {
	my ( $self ) = @_;
	my $base = 2015;
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

sub countries {{
	'us' => {
		name_in_english => 'United States',
		name_in_local => 'United States',
		flag_source => 'http://upload.wikimedia.org/wikipedia/en/a/a4/Flag_of_the_United_States.svg',
	},
	'de' => {
		name_in_english => 'Germany',
		name_in_local => 'Deutschland',
		flag_source => 'http://upload.wikimedia.org/wikipedia/en/b/ba/Flag_of_Germany.svg',
	},
	'es' => {
		name_in_english => 'Spain',
		name_in_local => 'España',
		flag_source => 'http://upload.wikimedia.org/wikipedia/en/9/9a/Flag_of_Spain.svg',
	},
	'br' => {
		name_in_english => 'Brazil',
		name_in_local => 'Brasil',
		flag_source => 'http://upload.wikimedia.org/wikipedia/commons/0/05/Flag_of_Brazil.svg',
	},
	'pt' => {
		name_in_english => 'Portugal',
		name_in_local => 'República Portuguesa',
		flag_source => 'http://upload.wikimedia.org/wikipedia/commons/thumb/5/5c/Flag_of_Portugal.svg/2000px-Flag_of_Portugal.svg.png',
	},
	'ru' => {
		name_in_english => 'Russia',
		name_in_local => 'России',
		flag_source => 'http://upload.wikimedia.org/wikipedia/commons/f/f3/Flag_of_Russia.svg',
	},
	'gb' => {
		name_in_english => 'United Kingdom',
		name_in_local => 'United Kingdom',
		flag_source => 'https://upload.wikimedia.org/wikipedia/en/thumb/a/ae/Flag_of_the_United_Kingdom.svg/2000px-Flag_of_the_United_Kingdom.svg.png',
	},
	'in' => {
		name_in_english => 'India',
		name_in_local => 'इंडिया का हिन्दी',
		flag_source => 'https://upload.wikimedia.org/wikipedia/en/thumb/4/41/Flag_of_India.svg/2000px-Flag_of_India.svg.png',
	},
	'se' => {
		name_in_english => 'Sweden',
		name_in_local => 'Sverige',
		flag_source => 'http://upload.wikimedia.org/wikipedia/en/4/4c/Flag_of_Sweden.svg',
	},
	'fr' => {
		name_in_english => 'France',
		name_in_local => 'France',
		flag_source => 'http://upload.wikimedia.org/wikipedia/en/c/c3/Flag_of_France.svg',
	},
	'da' => {
		name_in_english => 'Denmark',
		name_in_local => 'Danmark',
		flag_source => 'https://upload.wikimedia.org/wikipedia/commons/9/9c/Flag_of_Denmark.svg',
	},
	'eg' => {
		name_in_english => 'Egypt',
		name_in_local => 'العربية - مصر',
		flag_source => 'https://upload.wikimedia.org/wikipedia/commons/f/fe/Flag_of_Egypt.svg',
	},
	'be' => {
		name_in_english => 'Belgium',
		name_in_local => 'België',
		flag_source => 'http://upload.wikimedia.org/wikipedia/commons/thumb/6/65/Flag_of_Belgium.svg/2000px-Flag_of_Belgium.svg.png',
	},
	'nl' => {
		name_in_english => 'The Netherlands',
		name_in_local => 'Nederland',
		flag_source => 'http://upload.wikimedia.org/wikipedia/commons/thumb/2/20/Flag_of_the_Netherlands.svg/2000px-Flag_of_the_Netherlands.svg.png',
	},
}}

sub languages {{
	'us' => {
		name_in_english => 'English of United States',
		name_in_local => 'English of United States',
		locale => 'en_US',
		country => 'us',
	},
	'de' => {
		name_in_english => 'German of Germany',
		name_in_local => 'Deutsch von Deutschland',
		locale => 'de_DE',
		country => 'de',
	},
	'es' => {
		name_in_english => 'Spanish of Spain',
		name_in_local => 'Español de España',
		locale => 'es_ES',
		country => 'es',
	},
	'br' => {
		name_in_english => 'Portuguese of Brazil',
		name_in_local => 'Português do Brasil',
		locale => 'pt_BR',
		plural => '(n > 1)',
		country => 'br',
		parent_language => 'pt',
	},
	'pt' => {
		name_in_english => 'Portuguese of Portugal',
		name_in_local => 'Português de Portugal',
		locale => 'pt_PT',
		plural => 'n != 1',
		country => 'pt',
	},
	'ru' => {
		name_in_english => 'Russian of Russia',
		name_in_local => 'Русский России',
		locale => 'ru_RU',
		nplurals => '3',
		plural => 'n%10==1 && n%100!=11 ? 0 : n%10>=2 && n%10<=4 && (n%100<10 || n%100>=20) ? 1 : 2',
		country => 'ru',
	},
	'gb' => {
		name_in_english => 'English of United Kingdom',
		name_in_local => 'English of United Kingdom',
		locale => 'en_UK',
		country => 'gb',
	},
	'in' => {
		name_in_english => 'Hindi of India',
		name_in_local => 'इंडिया का हिन्दी',
		locale => 'hi_IN',
		country => 'in',
	},
	'se' => {
		name_in_english => 'Swedish in Sweden',
		name_in_local => 'Svenska i Sverige',
		locale => 'sv_SE',
		country => 'se',
	},
	'fr' => {
		name_in_english => 'French in France',
		name_in_local => 'Français en France',
		locale => 'fr_FR',
		country => 'fr',
	},
	'fr_be' => {
		name_in_english => 'French in Belgium',
		name_in_local => 'Français en Belgique',
		locale => 'fr_BE',
		country => 'be',
	},
	'da' => {
		name_in_english => 'Danish in Denmark',
		name_in_local => 'Dansk i Danmark',
		locale => 'da_DK',
		country => 'da',
	},
	'ar' => {
		name_in_english => 'Arabic in Egypt',
		name_in_local => 'العربية - مصر',
		locale => 'ar_EG',
		rtl => 1,
		country => 'eg',
	},
	'nl_be' => {
		name_in_english => 'Dutch in Belgium',
		name_in_local => 'Nederlands in België',
		locale => 'nl_BE',
		country => 'be',
	},
	'nl' => {
		name_in_english => 'Dutch in The Netherlands',
		name_in_local => 'Nederlands in Nederland',
		locale => 'nl_NL',
		country => 'nl',
	},
}}

sub add_languages {
	my ( $self ) = @_;
	my $country_rs = $self->db->resultset('Country');
	for (sort keys %{$self->countries}) {
		my %values = %{$self->countries->{$_}};
		$values{country_code} = $_;
		$self->c->{countries}->{$_} = $country_rs->create(\%values);
		$self->isa_ok($self->c->{countries}->{$_},'DDGC::DB::Result::Country');
		$self->next_step;
	}
	my $language_rs = $self->db->resultset('Language');
	my %parents;
	for (sort keys %{$self->languages}) {
		my %values = %{$self->languages->{$_}};
		my $country = delete $values{country};
		my $parent_language = delete $values{parent_language};
		$values{country_id} = $self->c->{countries}->{$country}->id;
		my $primary_language = defined $values{primary_language}
			? delete $values{primary_language}
			: 1;
		$self->c->{languages}->{$_} = $language_rs->create(\%values);
		if ($primary_language) {
			$self->c->{countries}->{$country}->primary_language_id($self->c->{languages}->{$_}->id);
			$self->c->{countries}->{$country}->update;
		}
		if ($parent_language) {
			$parents{$_} = $parent_language;
		}
		$self->isa_ok($self->c->{languages}->{$_},'DDGC::DB::Result::Language');
		$self->next_step;
	}
	for (sort keys %parents) {
		$self->c->{languages}->{$_}->parent($self->c->{languages}->{$parents{$_}});
		$self->c->{languages}->{$_}->update;
		$self->next_step;
	}
}

#####################################################
#  _
# | | __ _ _ __   __ _ _   _  __ _  __ _  ___  ___
# | |/ _` | '_ \ / _` | | | |/ _` |/ _` |/ _ \/ __|
# | | (_| | | | | (_| | |_| | (_| | (_| |  __/\__ \
# |_|\__,_|_| |_|\__, |\__,_|\__,_|\__, |\___||___/
#                |___/             |___/

sub helps {{
	'company' => {
		sort => 10,
		title => "Company",
		description => "Praesent sit amet quam non massa blandit.",
		helps => {
			'test' => {
				sort => 0,
				title => "Suspendisse potenti. Maecenas ultricies diam vitae eleifend vestibulum.",
				teaser => "Sed elementum, diam at dapibus tincidunt, leo dui pretium leo, vel pretium tortor mi at diam.",
				content => "In nisi lorem, <b>faucibus at dictum id</b>, feugiat quis diam. Vivamus velit lectus, facilisis vitae nisl at, laoreet mollis erat. Integer blandit, lectus id consequat laoreet, est ante dictum velit, ut imperdiet odio nunc vel est. Nam in laoreet risus, nec tincidunt mi. In hac habitasse platea dictumst. Vestibulum auctor viverra orci eget viverra. In vel dolor ut enim scelerisque varius. Aliquam erat volutpat. Aliquam malesuada gravida eros a ullamcorper.",
				raw_html => 1,
				related => ['community/wallpapers'],
			},
		},
	},
	'results' => {
		sort => 20,
		title => "Results",
		description => "Suspendisse potenti. Maecenas ultricies diam vitae eleifend vestibulum.",
		helps => {
			'test-blub' => {
				sort => 10,
				title => "In nisi lorem, faucibus at dictum id.",
				teaser => "Sed elementum, diam at dapibus tincidunt, leo dui pretium leo, vel pretium tortor mi at diam.",
				content => "In nisi lorem, faucibus at dictum id, <b>feugiat quis diam</b>. Vivamus velit lectus, facilisis vitae nisl at, laoreet mollis erat. Integer blandit, lectus id consequat laoreet, est ante dictum velit, ut imperdiet odio nunc vel est. Nam in laoreet risus, nec tincidunt mi. In hac habitasse platea dictumst. Vestibulum auctor viverra orci eget viverra. In vel dolor ut enim scelerisque varius. Aliquam erat volutpat. Aliquam malesuada gravida eros a ullamcorper.",
				raw_html => 1,
				related => ['community/wallpapers'],
			},
			'xxxxx-blub' => {
				sort => 20,
				title => "Sed elementum, diam at dapibus tincidunt.",
				teaser => "Sed elementum, diam at dapibus tincidunt, leo dui pretium leo, vel pretium tortor mi at diam.",
				content => "In nisi lorem, faucibus at dictum id, <b>feugiat quis diam</b>. Vivamus velit lectus, facilisis vitae nisl at, laoreet mollis erat. Integer blandit, lectus id consequat laoreet, est ante dictum velit, ut imperdiet odio nunc vel est. Nam in laoreet risus, nec tincidunt mi. In hac habitasse platea dictumst. Vestibulum auctor viverra orci eget viverra. In vel dolor ut enim scelerisque varius. Aliquam erat volutpat. Aliquam malesuada gravida eros a ullamcorper.",
				raw_html => 1,
			},
		},
	},
	'community' => {
		sort => 30,
		title => "Features",
		description => "Vestibulum varius, nisl a faucibus varius, diam est sollicitudin dui, at dapibus felis elit consequat lorem.",
		helps => {
			'wallpapers' => {
				sort => 5,
				title => 'Wallpapers',
				teaser => 'DuckDuckGo wallpapers for your enjoyment!',
				content => 'Show your love for DuckDuckGo with these wallpapers for your desktop or mobile device. Each .zip file contains a wallpaper design at the desktop resolutions 800x600, 1024x768, 1280x1024, 1366x768, 1600x900, 1900x1200, and 2560x1600; as well as the mobile resolutions 240x320, 320x480, 480x320, 480x680, 480x800, 640x960, and 800x980. All wallpapers on this page are distributed under the <a href="https://creativecommons.org/licenses/by-nc-sa/3.0/">CC BY-NC-SA license</a>.<br /><br /><a href="http://duckduckgo.com/assets/wallpaper/red.zip"><img alt="" src="/customer/portal/attachments/36476" style="width: 400px; height: 300px;" /></a><br /><br /><a href="http://duckduckgo.com/assets/wallpaper/red.zip">Download this wallpaper</a><br /><br /><a href="http://duckduckgo.com/assets/wallpaper/tall_white.zip"><img alt="" src="/customer/portal/attachments/36477" /></a><br /><br /><a href="http://duckduckgo.com/assets/wallpaper/tall_white.zip">Download this wallpaper</a><br /><br /><a href="http://duckduckgo.com/assets/wallpaper/tall_texture.zip"><img alt="" src="/customer/portal/attachments/36478" /></a><br /><br /><a href="http://duckduckgo.com/assets/wallpaper/tall_texture.zip">Download this wallpaper</a><br /><br /><a href="http://duckduckgo.com/assets/wallpaper/tall_texture2.zip"><img alt="" src="/customer/portal/attachments/36479" /></a><br /><br /><a href="http://duckduckgo.com/assets/wallpaper/tall_texture2.zip">Download this wallpaper</a><br /><br /><a href="http://duckduckgo.com/assets/wallpaper/wide_white.zip"><img alt="" src="/customer/portal/attachments/36480" /></a><br /><br /><a href="http://duckduckgo.com/assets/wallpaper/wide_white.zip">Download this wallpaper</a><br /><br /><a href="http://duckduckgo.com/assets/wallpaper/black.zip"><img alt="" src="/customer/portal/attachments/40789" style="width: 400px; height: 300px;" /><br /><br />Download this wallpaper</a>',
				raw_html => 1,
				notes => 'Test for auto media import',
			},
			'test-blabalbal' => {
				sort => 10,
				title => "Zxiam vitae eleifend vestibulum.",
				teaser => "Sed elementum, diam at dapibus tincidunt, leo dui pretium leo, vel pretium tortor mi at diam.",
				content => "In nisi lorem, faucibus at dictum id, feugiat quis diam. <b>Vivamus velit lectus</b>, facilisis vitae nisl at, laoreet mollis erat. Integer blandit, lectus id consequat laoreet, est ante dictum velit, ut imperdiet odio nunc vel est. Nam in laoreet risus, nec tincidunt mi. In hac habitasse platea dictumst. Vestibulum auctor viverra orci eget viverra. In vel dolor ut enim scelerisque varius. Aliquam erat volutpat. Aliquam malesuada gravida eros a ullamcorper.",
				raw_html => 1,
				related => ['results/xxxxx-blub','settings/test-yyyyyy'],
			},
			'test-xxxxx' => {
				sort => 20,
				title => "Suspendisse potenti.",
				teaser => "Sed elementum, diam at dapibus tincidunt, leo dui pretium leo, vel pretium tortor mi at diam.",
				content => "In nisi lorem, faucibus at dictum id, feugiat quis diam. Vivamus velit lectus, facilisis vitae nisl at, laoreet mollis erat. Integer blandit, lectus id consequat laoreet, est ante dictum velit, ut imperdiet odio nunc vel est. Nam in laoreet risus, nec tincidunt mi. In hac habitasse platea dictumst. Vestibulum auctor viverra orci eget viverra. In vel dolor ut enim scelerisque varius. <b>Aliquam erat volutpat</b>. Aliquam malesuada gravida eros a ullamcorper.",
				raw_html => 1,
				related => ['results/xxxxx-blub','settings/test-yyyyyy'],
			},
		},
	},
	'settings' => {
		sort => 40,
		title => "Settings",
		description => "In nisi lorem, faucibus at dictum id, feugiat quis diam.",
		helps => {
			'test-afhifad' => {
				sort => 10,
				title => "Suspendisse potenti. Maecenas ultricies diam vitae eleifend vestibulum.",
				teaser => "Leo dui pretium leo, vel pretium tortor mi at diam.",
				content => "In nisi lorem, faucibus at dictum id, feugiat quis diam. Vivamus velit lectus, facilisis vitae nisl at, laoreet mollis erat. Integer blandit, lectus id consequat laoreet, est ante dictum velit, ut imperdiet odio nunc vel est. Nam in laoreet risus, nec tincidunt mi. In hac habitasse platea dictumst. Vestibulum auctor viverra orci eget viverra. <b>In vel dolor ut enim scelerisque varius</b>. Aliquam erat volutpat. Aliquam malesuada gravida eros a ullamcorper.",
				raw_html => 1,
			},
			'test-yyyyyy' => {
				sort => 20,
				title => "Maecenas ultricies diam vitae eleifend vestibulum.",
				teaser => "Tincidunt, leo dui pretium leo, vel pretium tortor mi at diam.",
				content => "In nisi lorem, [b]faucibus at dictum id, feugiat quis diam. Vivamus velit lectus, facilisis vitae nisl at, laoreet[/b] mollis erat. Integer blandit, lectus id consequat laoreet, est ante dictum velit, ut imperdiet odio nunc vel est. Nam in laoreet risus, nec tincidunt mi. In hac habitasse platea dictumst. Vestibulum auctor viverra orci eget viverra. In vel dolor ut enim scelerisque varius. Aliquam erat volutpat. Aliquam malesuada gravida eros a ullamcorper.",
				raw_html => 0,
			},
		},
	},
}}

sub add_helps {
	my ( $self ) = @_;
	$self->c->{help_categories} = {};
	my $rs = $self->db->resultset('Help::Category');
	my %rel; # relation storage
	for (sort keys %{$self->helps}) {
		my $key = $_;
		my %cat = %{$self->helps->{$key}};
		$cat{key} = $key;
		my %cat_con;
		for (qw( title description )) {
			$cat_con{$_} = delete $cat{$_};
		}
		my $ref_helps = delete $cat{'helps'};
		my %helps = %{$ref_helps};
		$self->c->{help_categories}->{$key} = $rs->create(\%cat);
		$self->next_step;
		$self->c->{help_categories}->{$key}->create_related('help_category_contents',{
			language_id => $self->c->{languages}->{us}->id,
			%cat_con,
		});
		$self->next_step;
		for my $help_key (keys %helps) {
			my %help_data = %{$helps{$help_key}};
			$help_data{key} = $help_key;
			my %help_con_data;
			for (qw( title teaser content raw_html )) {
				$help_con_data{$_} = delete $help_data{$_};
			}
			my @relations;
			if (defined $help_data{related}) {
				my $ref_rel = delete $help_data{related};
				@relations = @{$ref_rel};
			}
			my $help = $self->c->{help_categories}->{$key}->create_related('helps',{
				%help_data
			});
			$self->next_step;
			if (@relations) {
				$rel{$help->id} = \@relations;
			}
			$help->create_related('help_contents',{
				language_id => $self->c->{languages}->{us}->id,
				%help_con_data
			});
			$self->c->{help_categories}->{$key}->{$help_key} = $help;
			$self->next_step;
		}
	}
	for my $on_id (keys %rel) {
		for (@{$rel{$on_id}}) {
			my @rel_parts = split(/\//,$_);
			my $show_id = $self->c->{help_categories}->{$rel_parts[0]}->{$rel_parts[1]}->id;
			$self->db->resultset('Help::Relate')->create({
				on_help_id => $on_id,
				show_help_id => $show_id,
			});
			$self->next_step;
		}
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
		notes => 'Testuser, public, us, ar, de, nl_be, nl, fr_be, fr',
		languages => {
			us => 6,
			ar => 5,
			de => 4,
			nl_be => 5,
			nl => 5,
			fr_be => 5,
			fr => 5,
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
	$self->next_step;
	$testone->create_related('user_languages',{
		language_id => $self->c->{languages}->{'us'}->id,
		grade => 3,
	});
	$self->next_step;
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
	$self->next_step;
	for (qw(
		DDGC::DB::Result::Comment
		DDGC::DB::Result::Token::Language::Translation
		DDGC::DB::Result::Token
	)) {
		$testone->create_related('user_notifications',{
			context => $_,
			cycle => 2,
		});
		$self->next_step;
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
		$self->next_step;
		$user->$_($data->{$_}) for (keys %{$data});
		for (keys %{$languages}) {
			$user->create_related('user_languages',{
				language_id => $self->c->{languages}->{$_}->id,
				grade => $languages->{$_},
			});
			$self->next_step;
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
			$self->next_step;
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
	#my @events = $self->d->resultset('Event')->search({})->all;
	#$self->is(scalar @events, 298, "Checking amount of events gathered");
	#my @enos = $self->d->resultset('Event::Notification')->search({})->all;
	#$self->is(scalar @enos, 545, "Checking amount of event notifications gathered");
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
#                                           _
#   ___ ___  _ __ ___  _ __ ___   ___ _ __ | |_ ___
#  / __/ _ \| '_ ` _ \| '_ ` _ \ / _ \ '_ \| __/ __|
# | (_| (_) | | | | | | | | | | |  __/ | | | |_\__ \
#  \___\___/|_| |_| |_|_| |_| |_|\___|_| |_|\__|___/

sub add_comments {
	my ( $self, $context, $context_id, @comments ) = @_;
	while (@comments) {
		my $username = shift @comments;
		my $text = shift @comments;
		my @sub_comments;
		if (ref $text eq 'ARRAY') {
			@sub_comments = @{$text};
			$text = shift @sub_comments;
		}
		my $user = $self->c->{users}->{$username};
		my $comment = $self->d->add_comment($context, $context_id, $user, $text);
		$self->next_step;
		$self->isa_ok($comment,'DDGC::DB::Result::Comment');
		if (scalar @sub_comments > 0) {
			$self->add_comments('DDGC::DB::Result::Comment',$comment->id, @sub_comments);
		}
	}
}

##############################################
#  _____ _   _ ____  _____    _    ____  ____  
# |_   _| | | |  _ \| ____|  / \  |  _ \/ ___| 
#   | | | |_| | |_) |  _|   / _ \ | | | \___ \ 
#   | | |  _  |  _ <| |___ / ___ \| |_| |___) |
#   |_| |_| |_|_| \_\_____/_/   \_\____/|____/ 

sub threads {[
	testone => { 
		title => "Test thread",
		content => "Testing some BBCode\n[b]Bold[/b]\n[url=http://ddg.gg]URL[/url] / http://ddg.gg\nEtc.",
		comments => [
			testtwo => "ah ha!",
		],
		sticky => 1,
	},
	testone => { 
		title => "Test more thread",
		content => "Testing more some",
		comments => [
			testtwo => "ah ha 2!",
		],
		sticky => 1,
	},
	testone => { 
		title => "Test more more thread",
		content => "Testing more more some",
		comments => [
			testtwo => "ah ha 3!",
		],
		sticky => 1,
	},
	testtwo => {
		title => "Hello, World!",
		content => "Hello, World!\n[code=perl]#!/usr/bin/env perl\nprint \"Hello, World!\";[/code]\n[code=lua]print(\"Hello, World\")[/code]\n[code=javascript]alert('Hello, World!');[/code]\n[quote=shakespeare](bb|[^b]{2})[/quote]\n\@testtwo I love you!",
		comments => [
			testone => "Now you got me....",
		],
	},
	(map {( testtwo => {
		title => "I, ".$_.", will spam you all!",
		content => "Hello, World!",
		comments => [
			testone => [ "Now you got me ".$_."....",
				testtwo => "You're welcome! - ".$_,
			],
			testthree => "What the hell is ".$_." talking about?",
		],
	} )} 1..50),
	testthree => {
		title => "Syntax highlighting",
   	content => '[code=perl]#!/usr/bin/env perl
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
		comments => [
			testone => [ "He is soooo lame",
				testtwo => "totally agree here....",
			],
		],
	},
]}

sub add_threads {
	my $self = shift;
	my $rs = $self->db->resultset('Thread');
	my @threads = @{$self->threads};
	while (@threads) {
		my $username = shift @threads;
		my %hash = %{shift @threads};
		my @comments = defined $hash{comments} ? @{delete $hash{comments}} : ();
		my $user = $self->c->{users}->{$username};
		my $content = delete $hash{content};
		my $thread = $self->d->forum->add_thread($user,$content,%hash);
		$self->add_comments('DDGC::DB::Result::Comment', $thread->comment->id, @comments);
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
		languages => [qw( de es br ru fr se in da ar fr_be nl nl_be )],
		snippets => [
			'Hello %s', [
				testone => [
					us => 'Heeellloooo %s', [],
				],
				testthree => [
					de => 'Hallo %s', [qw( testthree testfour )],
					us => 'Welcome %s', [],
					nl_be => 'Rot op %s', [],
					nl => 'Zout op %s', [],
					fr_be => 'Ta geulle %s', [],
					fr => 'Fils de putte %s', [],
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
				},
				comments => {
					us => [
						testone => "This is lame",
						testtwo => [ "This is awesome!",
							testone => 'Ok, you are right',
							testthree => "Ugh ugh!",
							testfour => [ "Comment on me!",
								testone => 'oookkk',
							],
						],
					],
					de => [
						testthree => [ "Das ist total geil!",
							testfour => [ "Kommentier!",
								testthree => 'Jawohl!',
							],
						],
					],
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
					nl_be => 'Gij %2$s vannen %1$s', [],
					nl => 'Jij bent een %s van een %s', [],
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
					de => "Jawohl %s Der %s Herr %s", [],
					us => 'Yes dude %s %s %s', [],
				],
				testfive => [
					ru => 'Привет %s %s %s', [],
					us => 'Welcomee %s %s %s', [],
				],
				notes => {
					token => 'This is a token note',
				},
			],
			\'email', 'You have %d message', 'You have %d messages', [
				testone => [
					us => 'Yu hav %d meage', 'Yuuu hve %d meages', [],
				],
				testthree => [
					de => 'Du hast %d Nachricht', 'Du hast %d Nachrichten', [],
					us => 'You have %d message', 'You have %d messages', [],
					fr_be => 'Vous avez %d message', 'Vous avez %d messages', [],
					fr => 'T\'as %d message', 'T\'as %d messages putte', [],
				],
				testfive => [
					ru => 'У вас %d сообщение', 'У вас %d сообщения', 'У вас %d сообщений', [],
					us => 'You have %d mssage', 'You have %d messges', [],
				],
				notes => {
				},
			],
			'You have %d message', 'You have %d messages', [
				testone => [
					us => 'Yu hav %d meage', 'Yuuu hve %d meages', [],
				],
				testthree => [
					de => 'Du hast "%d" Nachricht', 'Du hast "%d" Nachrichten', [],
					us => 'You have %d message', 'You have %d messages', [],
					fr_be => 'Vous avez %d message', 'Vous avez %d messages', [],
					fr => 'T\'as %d message', 'T\'as %d messages putte', [],
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
			( map { $_ => [
				comments => {
					de => [ testfive => 'I am a spam comment' ],
					ru => [ testfive => 'I am a сообщения comment' ],
					ar => [ testfive => 'I am an arabic comment' ],
				},
			] } 'abominable','absorbed','accepting','aching','admiration','affected','affectionate','afflicted','aggressive','agonized','alarmed','alienated','alone','amazed','anguish','animated','annoyed','anxious','appalled','a sense of loss','ashamed','at ease','attracted','bad','bitter','blessed','boiling','bold','bored','brave','bright','calm','certain','challenged','cheerful','clever','close','cold','comfortable','comforted','concerned','confident','considerate','content','courageous','cowardly','cross','crushed','curious','daring','dejected','delighted','deprived','desolate','despair','desperate','despicable','determined','detestable','devoted','diminished','disappointed','discouraged','disgusting','disillusioned','disinterested','dismayed','dissatisfied','distressed','distrustful','dominated','doubtful','drawn toward','dull','dynamic','eager','earnest','easy','ecstatic','elated','embarrassed','empty','encouraged','energetic','engrossed','enraged','enthusiastic','excited','fascinated','fatigued','fearful','festive','forced','fortunate','free','free and easy','frightened','frisky','frustrated','fuming','gay','glad','gleeful','great','grief','grieved','guilty','hardy','hateful','heartbroken','hesitant','hopeful','hostile','humiliated','important','impulsive','in a stew','incapable','incensed','indecisive','in despair','indignant','inferior','inflamed','infuriated','injured','inquisitive','insensitive','inspired','insulting','intent','interested','intrigued','irritated','joyous','jubilant','keen','kind','liberated','lifeless','lonely','lost','lousy','loved','loving','lucky','menaced','merry','miserable','misgiving','mournful','nervous','neutral','nonchalant','nosy','offended','offensive','optimistic','overjoyed','pained','panic','paralyzed','passionate','pathetic','peaceful','perplexed','pessimistic','playful','pleased','powerless','preoccupied','provocative','provoked','quaking','quiet','reassured','rebellious','receptive','re-enforced','rejected','relaxed','reliable','repugnant','resentful','reserved','restless','satisfied','scared','secure','sensitive','serene','shaky','shy','skeptical','snoopy','sore','sorrowful','spirited','stupefied','sulky','sunny','sure','surprised','suspicious','sympathetic','sympathy','tearful','tenacious','tender','tense','terrible','terrified','thankful','threatened','thrilled','timid','tormented','tortured','touched','tragic','unbelieving','uncertain','understanding','uneasy','unhappy','unique','unpleasant','unsure','upset','useless','victimized','vulnerable','warm','wary','weary','woeful','wonderful','worked up','worried','wronged' )
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
					if ($_ eq 'token') {
						$token->notes($data->{$_});
						$token->update;
					}
					$self->next_step;
				} elsif ($user_or_notes eq 'comments') {
					for my $lang (keys %{$data}) {
						my $tl = $token->search_related('token_languages',{
							token_domain_language_id => $tcl{$lang}->id,
						})->first;
						my @comments = @{$data->{$lang}};
						$self->add_comments('DDGC::DB::Result::Token::Language', $tl->id, @comments);
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
						$self->next_step;
						for (@votes) {
							my $voteuser = $self->c->{users}->{$_};
							$tlt->set_user_vote($voteuser,1);
							$self->next_step;
						}
					}
				}
			}
		}
	}
}

########################
#  ____  _
# | __ )| | ___   __ _
# |  _ \| |/ _ \ / _` |
# | |_) | | (_) | (_| |
# |____/|_|\___/ \__, |
#                |___/

sub blogs {
	my $idx;
	{
	testone => [
		map {
			$idx = $_++;
			(
			"test-one-$idx" => {
				title => "Test One $idx",
				teaser => 'This is a teaser',
				content => 'This is a content',
				topics => ['Topic','Another Topic', 'Topic ' . $idx % 2],
				company_blog => 1,
				comments => [],
			},
			"my-other-test-one-$idx" => {
				title => "Other Test One $idx",
				teaser => 'Other This is a teaser',
				content => 'Other This is a content',
				topics => ['Another Topic'],
				company_blog => 1,
				comments => [
					testtwo => [ "Deep This is another awesome!",
						testone => 'Deep Ok, you are another right',
						testthree => "Deep Ugh another ugh!",
						testfour => [ "Deep Comment on another me!",
							testone => [ 'Deeeeper',
								testone => "Deeeeeeeper",
							],
							testtwo => [ 'Deeeeeeeeeper',
								testtwo => "Deeeeeeeeeeeeper",
							],
						],
					],
				],
			},
		) } (1..50)
	],
	testthree => [
		'test-three' => {
			title => 'Test One',
			teaser => 'This is a three',
			content => 'This is a three',
			topics => ['Topic','Another Topic'],
			comments => [],
		},
		'my-other-test-three' => {
			title => 'Ohter Test three',
			teaser => 'Ohter This is a three',
			content => 'Ohter This is a three',
			topics => ['Another Topic'],
			comments => [
				testtwo => [ "Deep This is another awesome!",
					testone => 'Deep Ok, you are another right',
					testthree => "Deep Ugh another ugh!",
					testfour => [ "Deep Comment on another me!",
						testone => [ 'Deeeeper',
							testone => "Deeeeeeeper",
						],
						testtwo => [ 'Deeeeeeeeeper',
							testtwo => "Deeeeeeeeeeeeper",
						],
					],
				],
			],
		},
	],
}}

sub add_blogs {
	my ( $self ) = @_;
	$self->c->{blogs} = {};
	for my $username (sort { $a cmp $b } keys %{$self->blogs}) {
		my $user = $self->c->{users}->{$username};
		my @posts = @{$self->blogs->{$username}};
		$self->c->{blogs}->{$username} = {};
		while (@posts) {
			my $uri = shift @posts;
			my $post = shift @posts;
			$post->{uri} = $uri;
			$post->{live} = 1 unless defined $post->{live};
			my @comments = defined $post->{comments} ? @{delete $post->{comments}} : ();
			$post->{fixed_date} = DateTime::Format::RSS->new->format_datetime($post->{fixed_date}) if defined $post->{fixed_date};
			my $blog = $user->create_related( user_blogs => $post );
			$self->isa_ok($blog,'DDGC::DB::Result::User::Blog');
			$self->next_step;
			$self->add_comments('DDGC::DB::Result::User::Blog', $blog->id, @comments);
			$self->c->{blogs}->{$username}->{$uri} = $blog;
		}
	}
}

#############################
#  ___    _
# |_ _|__| | ___  __ _ ___
#  | |/ _` |/ _ \/ _` / __|
#  | | (_| |  __/ (_| \__ \
# |___\__,_|\___|\__,_|___/
#

sub ideas {{
	testone => [{
		title => 'I Have A Dreamy Idea',
		content => "Lalalalala",
		type => 1,
		votes => [qw( testtwo testthree test5 test6 test8 )],
	},{
		title => 'I Have Another Dreamy Idea',
		content => "Lalalalala 2",
		type => 2,
		status => 3,
		comments => [
			testtwo => "Blabla",
			testthree => "blub",
		],
		votes => [qw( test5 test6 test8 )],
	}],
	testtwo => [{
		title => 'I, also, Have A Dreamy Idea',
		content => "Lalalalala testtwo",
		type => 1,
		votes => [qw( test10 testone test2 test23 test12 )],
	},{
		title => 'I Have Another Dreamy Idea, too',
		content => "Lalalalala testtwo 2",
		type => 2,
		status => 3,
		comments => [
			testone => "Blabla",
			testtwo => "blub",
		],
		votes => [qw( test10 testone test2 test23 test12 )],
	}],
}}

sub add_ideas {
	my ( $self ) = @_;
	$self->c->{ideas} = {};
	for my $username (sort { $a cmp $b } keys %{$self->ideas}) {
		my $user = $self->c->{users}->{$username};
		my @ideas = @{$self->ideas->{$username}};
		my @results;
		for my $idea (@ideas) {
			my @comments = defined $idea->{comments}
				? @{delete $idea->{comments}}
				: ();
			my @votes = defined $idea->{votes}
				? @{delete $idea->{votes}}
				: ();
			my $result_idea = $user->create_related( ideas => $idea );
			$self->isa_ok($result_idea,'DDGC::DB::Result::Idea');
			$self->next_step;
			push @results, $result_idea;
			for (@votes) {
				my $voteuser = $self->c->{users}->{$_};
				$result_idea->set_user_vote($voteuser,1);
				$self->next_step;
			}
		}
		$self->c->{ideas}->{$username} = \@results;
	}
}

no Moose;
__PACKAGE__->meta->make_immutable;
