package DDGC::User::Page;
# ABSTRACT: Class for the user page information

use Moose;
use DDGC::User::Page::Field;
use URI;

# default type = text

my @attributes = (

############################ About

	headline => 'Userpage headline, instead of username' => {},
	about => 'About you' => { type => 'textarea' },
	whyddg => 'Why DuckDuckGo?' => { type => 'textarea' },
	gravatar_email => '<a href="https://gravatar.com/">Gravatar</a> email (user picture)' => { type => 'email' },
	realname => 'If you want to make your real name public, do it here:' => {},
	country => 'Living in country' => { type => 'country' },
	city => 'Living in city/town' => {},
	birth_country => 'Born in country' => { type => 'country' },

########################### Links

	email => 'Your public email' => { type => 'email' },
	web => 'Your website' => { type => 'url' },
	twitter => 'Your Twitter username' => {
		type => 'remote',
		validators => [sub {
			m/^[\w_-]{1,15}$/ ? () : ("Invalid Twitter username")
		}],
		params => {
			url_prefix => 'https://twitter.com/',
			icon => 'twitter',
			user_prefix => '@',
		},
	},
	facebook => 'Your Facebook profile url' => {
		type => 'remote',
		validators => [sub {
			m/^[\w\.\/-_]+$/ ? () : ("Invalid facebook url")
		}],
		params => {
			url_prefix => 'https://facebook.com/',
			icon => 'facebook',
			user => 'Facebook profile',
		},
	},
	github => 'Your GitHub username' => {
		type => 'remote',
		validators => [sub {
			m/^[\w\.-_]+$/ ? () : ("Invalid GitHub username")
		}],
		params => {
			url_prefix => 'https://github.com/',
			icon => 'github',
		},
	},
	reddit => 'Your reddit username' => {
		type => 'remote',
		validators => [sub {
			m/^[\w\.-_]+$/ ? () : ("Invalid reddit username")
		}],
		params => {
			url_prefix => 'http://www.reddit.com/user/',
			user_suffix => ' on reddit',
		},
	},
	deviantart => 'Your deviantART username' => {
		type => 'remote',
		validators => [sub {
			m/^[\w\.-_]+$/ ? () : ("Invalid deviantART username")
		}],
		params => {
			url_prefix => 'http://',
			url_suffix => '.deviantart.com/',
			user_suffix => ' on deviantART',
		},
	},
	imgur => 'Your imgur username' => {
		type => 'remote',
		validators => [sub {
			m/^[\w\.-_]+$/ ? () : ("Invalid imgur username")
		}],
		params => {
			url_prefix => 'http://',
			url_suffix => '.imgur.com/',
			user_suffix => ' on imgur',
		},
	},
	youtube => 'Your YouTube channel' => {
		type => 'remote',
		validators => [sub {
			m/^[\w\.-_]+$/ ? () : ("Invalid YouTube username")
		}],
		params => {
			url_prefix => 'https://youtube.com/user/',
			user_suffix => ' on YouTube',
		},
	},
	flickr => 'Your flickr username' => {
		type => 'remote',
		validators => [sub {
			m/^[\w\.-_]+$/ ? () : ("Invalid flickr username")
		}],
		params => {
			url_prefix => 'http://www.flickr.com/photos/',
			user_suffix => ' on flickr',
		},
	},
	linkedin => 'Your LinkedIn username' => {
		type => 'remote',
		validators => [sub {
			m/^[\w\.-_]+$/ ? () : ("Invalid LinkedIn username")
		}],
		params => {
			url_prefix => 'http://linkedin.com/in/',
			user_suffix => ' on LinkedIn',
		},
	},

############ Meta

	openid_server => 'OpenID server meta tag for your userpage' => { type => 'url' },
	openid_delegate => 'OpenID delegate meta tag for your userpage' => { type => 'url' },

############ Other widgets

	languages => 'Show your languages and translation counts public?' => { type => 'noyes',
		view => 'languages',
		export => sub {
			my ( $self ) = @_;
			return "" unless $self->value;
			return { map { $_->language->locale => $_->grade } $self->page->user->user_languages };
		},
	},

	blog => 'Show your blog posts on the userpage?' => { type => 'noyes',
		view => 'blog',
		no_export => 1,
	},

);

has data => (
	is => 'ro',
	isa => 'HashRef',
	lazy => 1,
	default => sub {{}},
);

sub export {
	my ( $self ) = @_;
	my %export;
	my %errors;
	for (keys %{$self->attribute_fields}) {
		next if $self->field($_)->no_export;
		$export{$_} = $self->field($_)->export_value;
		$errors{$_} = $self->field($_)->errors if $self->field($_)->error_count;
	}
	$export{errors} = \%errors if %errors;
	return \%export;
}

has user => (
	is => 'ro',
	isa => 'DDGC::User',
	required => 1,
);

has attribute_fields => (
	is => 'ro',
	isa => 'HashRef[DDGC::User::Page::Field]',
	lazy_build => 1,
);

sub field {
	my ( $self, $name ) = @_;
	return $self->attribute_fields->{$name};
}

sub _build_attribute_fields {
	my ( $self ) = @_;
	my %fields;
	my @attrs = @attributes;
	while (@attrs) {
		my $name = shift @attrs;
		my $desc = shift @attrs;
		my %extra = %{shift @attrs};
		my $value = defined $self->data->{$name}
			? $self->data->{$name}
			: '';
		$fields{$name} = DDGC::User::Page::Field->new(
			page => $self,
			name => $name,
			description => $desc,
			value => $value,
			%extra,
		);
	}
	return \%fields;
}

sub update_data {
	my ( $self, $data ) = @_;
	my $error_count;
	for (keys %{$data}) {
		my $key = $_;
		my $value = $data->{$_};
		my $field = $self->field($_);
		if ($field) {
			$field->value($value);
			if ($field->error_count) {
				$error_count += $field->error_count;
			} else {
				$self->data->{$key} = $value;
			}
		}
	}
	return $error_count;
}

sub new_from_user {
	my ( $class, $user ) = @_;
	my $data = defined $user->data->{userpage}
		? $user->data->{userpage}
		: {};
	return $class->new(
		data => $data,
		user => $user,
	);
}

sub update {
	my ( $self ) = @_;
	my $data = $self->user->data;
	$data->{userpage} = $self->data;
	$self->user->data($data);
	$self->user->update;
}

sub has_value_for {
	my ( $self, @fields ) = @_;
	for (@fields) {
		return 1 if $self->field($_)->value;
	}
	return 0;
}

1;