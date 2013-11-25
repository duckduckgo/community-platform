package DDGC::Markup;
# ABSTRACT: DDGC BBCode parser using Parse::BBCode

use Moose;
use warnings; use strict;
use Text::VimColor;
use Parse::BBCode;
use URI::Escape;

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
    my %shorttags = (
        github  => '<a href="https://github.com/%{uri}A">%s</a>',
        twitter => '<a href="http://twitter.com/%{uri}A">%s</a>',
        cpanm   => '<a href="https://metacpan.org/module/%{uri}A">%s</a>',
        youtube => sub { $self->youtube_parse(@_) },
        vimeo   => sub { $self->vimeo_parse(@_) },
        duck    => sub { $self->duck_parse(@_) },
        help    => 'url:<a href="/help/search?help_search=%{uri}A&ducky=1">[%{html}A help article]</a>',
    );
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
            (map {
                $_ => {
                    class => 'block',
                    short => 1,
                    classic => 0,
                    ref $shorttags{$_} eq 'CODE'
                        ? (code => $shorttags{$_})
                        : (output => $shorttags{$_}),
                }
            } keys %shorttags),
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
    my ( $self, @code_parts ) = @_;
    my $markup = join ' ', @code_parts;
    my $html = $self->bbcode->render($markup);

    # Let's try to handle @mentions!
    $html =~ s#(?<!\w)\@(-|\w+)#<a href='/$1'>\@$1</a>#g;
    
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
