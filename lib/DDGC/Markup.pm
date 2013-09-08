package DDGC::Markup;
# ABSTRACT: DDGC BBCode parser using Parse::BBCode

use Moose;
use warnings; use strict;
use Text::VimColor;
use Parse::BBCode;

has ddgc => (
	isa => 'DDGC',
	is => 'ro',
	required => 1,
	weak_ref => 1,
);

has bbcode => (
	is => 'ro',
	isa => 'Parse::BBCode',
	lazy_build => 1,
);

has escapes => (
    is => 'ro',
    isa => 'HashRef',
    default => sub { my %e = shift->bbcode->default_escapes; \%e },
    lazy => 1,
);

sub _build_bbcode {
	my $self = shift;
	Parse::BBCode->new({
		close_open_tags => 1,
		attribute_quote => q('"),
		url_finder => {
			max_length  => 200,
			# sprintf format:
			format      => '<a href="%s" rel="nofollow">%s</a>',
		},
		tags => {
			Parse::BBCode::HTML->defaults,
			url => {
                            code => sub { $self->url_parse(@_) },
                            parse => 0,
                            class => 'url',
                        },
			img => '<a href="%{link}A"><img src="%{link}A" alt="[%{html}s]" title="%{html}s"></a>',
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
		},
	});
}

# Helper for plaintext rendering (i.e. stripping)
has plain_bbcode => (
	is => 'ro',
	isa => 'Parse::BBCode',
	lazy_build => 1,
);

sub _build_plain_bbcode {
	my $self = shift;
	my @keys = keys %{$self->bbcode->{tags}};
	my %tags = ();

	$tags{$_} = '%{parse}s' for @keys;

	my $parser = Parse::BBCode->new({
		close_open_tags => 1,
		url_finder => {
		    format => '%s',
		    max_length => 200,
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
			break();
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

    $url = $self->escapes->{link}->($parser,$tag,$url); # URL validation sort of thing.

    return "$content" unless defined $url;

    $content ||= $url;
    return sprintf('<a href="%s" rel="nofollow" alt="%s">%s</a>', $url, $alt, $content // $attr);
}

#
# The user-facing ->html, handles the bulk of rendering magic
#
sub html {
	my ( $self, @code_parts ) = @_;
	my $markup = join ' ', @code_parts;
	my $html = $self->bbcode->render($markup);

	# Let's try to handle @mentions!
	my @captures;
	$html =~ s#(?<!\w)\@(-|\w+)#push @captures, $1;"<a href='/$1'>\@$1</a>"#ge;
	
	for (@captures) {
		"...";
	}

	return $html;
}

#
# For returning a stripped plain-text version
#
sub plain {
	my ($self, @code_parts) = @_;
	$self->plain_bbcode;
	my $markup = join ' ', @code_parts;
	return $self->plain_bbcode->render($markup);
}

no Moose;
__PACKAGE__->meta->make_immutable;
