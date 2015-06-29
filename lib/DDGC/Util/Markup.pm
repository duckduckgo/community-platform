use strict;
use warnings;
package DDGC::Util::Markup;
# ABSTRACT: BBCode, Markdown and HTML renderer for comments and blog posts.

use Text::Markdown;
use Text::Xslate;
use HTML::TreeBuilder::LibXML;
use Hash::Merge::Simple qw/ merge /;
use URI::Escape;
use URI;
use Parse::BBCode;
use String::Util 'trim';

use Moo;

has xslate => (
    is => 'ro',
    lazy => 1,
    builder => '_build_xslate',
);
sub _build_xslate {
    Text::Xslate->new(
        path => 'views',
    );
}

has image_proxy_url => (
    is => 'ro',
    lazy => 1,
    builder => '_build_image_proxy_url',
);
sub _build_image_proxy_url {
    'https://images.duckduckgo.com/iu/?u=%s&f=1'
}

has image_proxy_base => (
    is => 'ro',
    lazy => 1,
    builder => '_build_image_proxy_base',
);
sub _build_image_proxy_base {
    my ( $self ) = @_;
    ( my $image_proxy_base = $self->image_proxy_url ) =~
      s{(https?://[A-Za-z.]+).*}{$1};
    return $image_proxy_base;
}

sub _canonical_uri {
    my ( $self, $uri ) = @_;
    URI->new($uri)->canonical =~ s/'/%27/gr;
}

has opts => (
    is => 'ro',
    lazy => 1,
    builder => '_build_opts',
);
sub _build_opts {
    +{
        proxify_images   => 1,
        highlight_code   => 1,
        links_new_window => 0,
        plain_bbcode     => 0,
    }
}

has bbcode_tags => (
    is => 'ro',
    lazy => 1,
    builder => '_build_bbcode_tags',
);
sub _build_bbcode_tags {
    my ( $self ) = @_;
    my $tags;

    $tags->{code} = {
        parse => 0,
        class => 'block',
        code => sub { $self->_bbcode_code_block( @_ ) },
    };

    $tags->{url} = {
        code  => sub { $self->_bbcode_url( @_ ) },,
        parse => 0,
        class => 'url',
    };

    return $tags;
}

sub _bbcode_code_block {
    my ( $self, $parser, $lang, $content ) = @_;
    $lang ||= 'perl';
    my $langname = ucfirst($lang);
    $self->xslate->render(
        'includes/bbcode/code.tx', {
            lang        => $lang,
            content     => $$content,
            langname    => $langname,
        }
    );
}

# Support for [url href=...]
sub _bbcode_url {
    my ( $self, $parser, $attr, $content, $fallback, $tag ) = @_;

    my $url = $attr;
    $url ||= ( map {
        ( $_->[0] && $_->[0] eq 'href' ) ? $_->[1] : () ;
    } @{ $tag->get_attr } )[0];

    $url or return '';

    $self->xslate->render(
        'includes/bbcode/url.tx', {
            url     => $self->_canonical_uri($url),
            content => $$content || $url,
        }
    );
}

sub _ddg_bbcode {
    my ( $self, $opts ) = @_;
    my %defaults = Parse::BBCode::HTML->defaults;
    Parse::BBCode->new({
        tags => {
            %defaults,
            ( $self->bbcode_tags )
                ? %{ $self->bbcode_tags }
                : (),
        },
        url_finder => {
            max_length  => 80,
            format      => '<a href="%s" rel="nofollow">%s</a>',
        },
        close_open_tags => 1,
        attribute_quote => q/'"/,
    });
}

sub bbcode {
    my ( $self, $string, $opts ) = @_;
    $opts = merge $self->opts, $opts;
    my $bbcode;

    if ( $opts->{plain_bbcode} ) {
        $bbcode = Parse::BBCode->new();
    }
    else {
        $bbcode = $self->_ddg_bbcode( $opts );
    }

    my $html = $bbcode->render( $string );

    return $self->html( $html, {
            %{ $opts },
            proxify_images => 1,
        }
    );
}

sub markdown {
    my ( $self, $string, $opts ) = @_;
    $opts = merge $self->opts, $opts;
    my $markdown = Text::Markdown->new;
    my $html = $markdown->markdown( $string );

    return $self->html( $html, {
            %{ $opts },
            proxify_images => 1,
        }
    );
}

sub html {
    my ( $self, $string, $opts ) = @_;
    $opts = merge $self->opts, $opts;
    my $tree = HTML::TreeBuilder::LibXML->new;
    $tree->parse( $string );
    $tree->eof;

    if ( $opts->{proxify_images} ) {
        for my $node ( $tree->findnodes('//img') ) {
            my $src = trim($node->attr('src'));
            if (index(lc($src), $self->image_proxy_base) != 0 && index(lc($src), 'http') == 0) {
                $node->attr(
                    'src',
                    sprintf($self->image_proxy_url, uri_escape($src))
                );
            }
        }
    }

    if ( $opts->{links_new_window} ) {
        for my $node ( $tree->findnodes('//a') ) {
            next if (!$node->attr('href'));
            $node->attr('target', '_blank');
        }
    }
    my $guts = $tree->guts;

    if ($guts) {
        # as_HTML reliably closes empty tags supplied by BBCode and other
        # generators, e.g. [b][/b] -> <b></b>
        # as_XML would return a self-closed tag, <b /> which is interpreted
        # by renderer as <b>, so we have an open tag hanging.
        # as_HTML does *not* currently understand non-nested tags (like img,
        # hr, br) and generates closing tags for these. Only </br> is
        # actually problematic in our case so we ditch these by hand.
        # Is this worth it for a fast performing HTML munger?
        return $guts->as_HTML =~ s{</br>}{}gmr;
    }
    return ' ';
}

1;
