package DDGC::Markup;
# ABSTRACT: DDGC BBCode parser using Parse::BBCode

use Moose;
use Text::VimColor;
use Parse::BBCode;
use URI::Escape;
use URI;

has ddgc => (
	isa => 'DDGC',
	is => 'ro',
	required => 1,
	weak_ref => 1,
	handles => [qw(
		privacy
		current_user
	)],
);

sub bbcode {
	my ( $self ) = @_;
	my %base = (
		GitHub => 'https://github.com/%s',
		Twitter => 'https://twitter.com/%s',
		Facebook => 'https://facebook.com/%s',
		CPAN => 'https://metacpan.org/module/%s',
                Help => '/help/search?help_search=%s&ducky=1',
                DDG => 'https://duckduckgo.com/?q=%s'
	);
	my %tags;
	for my $site (keys %base) {
		my $url_base = $base{$site};
		my $key = lc($site);
		$tags{$key} = {
			class => 'block',
			short => 1,
			classic => 0,
			code => sub {
				my $uri_component = uri_escape $_[1];
                                my $attr = Parse::BBCode::escape_html($_[1]);
				my $url = sprintf($url_base,$uri_component);
				return '<a href="'.$url.'">'.$attr.' @ '.$site.'</a>';
			},
		};
	}
	$tags{img} = {
		class => 'block',
		classic => 1,
		parse => 0,
		code => sub {
			my ( $content_ref, $attr ) = @_[2,3];
			my $content = Parse::BBCode::escape_html($$content_ref);
			my $uri = URI->new($attr);
			if ($uri->can('host')) {
				my $url = $uri->as_string;
				my $proxy_url = $self->ddgc->config->image_proxy_url .
				                uri_escape($url) . '&f=1';
				my $has_desc = $content ne $attr ? 1 : 0;
				my $desc = $content;
				'<a rel="nofollow" href="'.$url.'">'.
					'<img src="'.$proxy_url.'" alt="['.$desc.']" title="'.$desc.'">'.
				'</a>'
			} else {
				'<i class="p-link__icn icon-camera"></i>'.
				'<span class="p-link__url">'.Parse::BBCode::escape_html($attr).'</span>'.
				'<span class="p-link__txt">INVALID URL</span>'
			}
		},
	};
	$tags{url} = {
		code => sub { $self->url_parse(@_) },
		parse => 0,
		class => 'url',
	},
	my $url_finder_format = '<a href="%s" rel="nofollow">%s</a>';
	my %html_tags = Parse::BBCode::HTML->defaults;
	Parse::BBCode->new({
		close_open_tags => 1,
		attribute_quote => q('"),
		url_finder => {
			max_length  => 40,
			# sprintf format:
			format      => $url_finder_format,
		},
		tags => {
			%html_tags,
			code => {
				code  => sub { $self->code_parse(@_) },
				parse => 0,
				class => 'block',
			},
			quote => {
				parse => 1,
				class => 'block',
				code  => sub { $self->quote_parse(@_) },
			},
			%tags,
		},
	});
}

# Helper for plaintext rendering (i.e. stripping)
sub plain_bbcode {
	my $self = shift;
	my @keys = keys %{$self->bbcode->{tags}};
	my %tags = ();

	$tags{$_} = '%{parse}s' for @keys;

	my $parser = Parse::BBCode->new({
		close_open_tags => 1,
		url_finder => {
			format => '%s',
			max_length => 200_000,
		},
		tags => \%tags,
	});

	return $parser;
}

#
# Specific sub-parser functions
#
sub code_parse {
		my ($self, $parser, $attr, $content, $attribute_fallback) = @_;
		my $lang = "";

		my $highlight_ok = 1;
		$highlight_ok = 0 if length($$content) > 50_000; # it can handle a lot

		for(split /\n/, $$content) {
				if (length($_) > 600) { # >80s just because of a long line? I think not.
						$highlight_ok = 0;
						last;
				}
		}
		if ($attr && $highlight_ok) {
				my @lines = split /\n/, $$content;
				my $tvc = Text::VimColor->new( string => $$content, filetype => lc($attr) );
				$content = $tvc->html;
				$lang = Parse::BBCode::escape_html(ucfirst($attr))." ";
		} else {
				$content = Parse::BBCode::escape_html($$content);
		}
		"<div class='bbcode_code_header'>${lang}Code:<pre class='bbcode_code_body'><code>$content</code></pre></div>"
}

sub quote_parse {
		my ($self, $parser, $attr, $content, $attribute_fallback) = @_;
		my $username = $attribute_fallback =~ m{^[^/\s?+]+$} ? Parse::BBCode::escape_html($attribute_fallback) : '';
		"<div class='bbcode_quote_header'>Quote". ($username ? " from <a href='/$username'>$username</a>" : "") . ":<div class='bbcode_quote_body'>$$content</div></div>";
}

sub url_parse {
	my ($self, $parser, $attr, $content, $attribute_fallback, $tag) = @_;
	$content = Parse::BBCode::escape_html($$content) if ref $content;

	my $url = $attribute_fallback;
	my $alt = $content;

	for (@{$tag->get_attr}) {
		my @attr = @$_;
		next if @attr < 1 or !defined $attr[1];
		$url = $attr[1] if $attr[0] eq "href";
		$alt = Parse::BBCode::escape_html($attr[1]) if $attr[0] eq "alt";
	}

	my %default_escapes = Parse::BBCode::HTML->default_escapes;

	$url = $default_escapes{link}->($parser,$tag,$url); # URL validation sort of thing.

	return "$content" unless defined $url;

	my $uri = URI->new($url);
	if ($uri->can('host')) {
		my $url = $uri->as_string;
		my $desc = $alt ? $alt : $attr;
		my $has_desc = $desc ne $url ? 1 : 0;
		'<a href="'.$url.'" rel="nofollow">'.$desc.'</a>'
	} else {
		'<i class="p-link__icn icon-external-link"></i>'.
		'<span class="p-link__url">'.$url.'</span>'.
		'<span class="p-link__txt">INVALID URL</span>'
	}

}

sub duck_parse {
		my ($self, $parser, $attr, $content, $attribute_fallback, $tag, $info) = @_;
		$attr =~ s/(?:^\\|([\w\s])!|!([\w\s]))/$1$2/g;
		my $uri_q = uri_escape $attr;
		my $html_q = Parse::BBCode::escape_html($attr);
		qq|DuckDuckGo results for <a href="https://duckduckgo.com/?q=$uri_q">$html_q</a>:
		<iframe src="//duckduckgo.com/?q=$uri_q&kn=1&ks=s&kw=n&km=m&ko=-1&kk=l&ke=-1&kr=-1&kq=-1&k1=-1&kv=1&k4=-1&t=ddgc" width="100%"></iframe>|;
}

sub youtube_parse {
		my ($self, $parser, $attr, $content, $attribute_fallback, $tag, $info) = @_;
		$attr =~ s/.*(?:watch\?v=|youtu\.be\/)([[:alnum:]]+).*/$1/ if $attr =~ m/youtu\.?be/;
		$attr =~ m/^[[:alnum:]]+$/ ?
				"<iframe width='560' height='315' src='https://www.youtube.com/embed/$attr'"
						. "frameborder='0' allowfullscreen></iframe>" : Parse::BBCode::escape_html($attr);
}

sub vimeo_parse {
		my ($self, $parser, $attr, $content, $attribute_fallback, $tag, $info) = @_;
		$attr =~ s/.*vimeo\.com\/(?:video\/)?([[:alnum:]]+).*/$1/ if $attr =~ m/vimeo/;
		$attr =~ m/^[[:alnum:]]+$/ ?
				"<iframe src='//player.vimeo.com/video/$attr' width='560' height='315' "
						. "frameborder='0' webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>"
				: Parse::BBCode::escape_html($attr);
}

#
# The user-facing ->html, handles the bulk of rendering magic
#
sub html {
	shift->html_render((join ' ', @_));
}

sub html_render {
	my ( $self, $markup) = @_;
	my $html = $self->bbcode->render($markup);
	# Let's try to handle @mentions!
	$html =~ s#(?:^|(?<=[\s\."']))\@([\w\.]+)#<a href='/user/$1'>\@$1</a>#g;
	return $html;
}

#
# For returning a stripped plain-text version
#
sub plain {
	my ($self, @code_parts) = @_;
	my $markup = join ' ', @code_parts;
	return $self->plain_bbcode->render($markup);
}

no Moose;
__PACKAGE__->meta->make_immutable;
