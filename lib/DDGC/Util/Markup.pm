use strict;
use warnings;
package DDGC::Util::Markup;
# ABSTRACT: BBCode, Markdown and HTML renderer for comments and blog posts.

use Text::Markdown;
use HTML::TreeBuilder::LibXML;
use Hash::Merge::Simple qw/ merge /;
use URI::Escape;
use String::Util 'trim';

use Moo;

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
    my $tags;

    my $sites = +{
        GitHub   => 'https://github.com/%{uri}A',
        Twitter  => 'https://twitter.com/%{uri}A',
        Facebook => 'https://facebook.com/%{uri}A',
        CPAN     => 'https://metacpan.org/module/%{uri}A',
        Help     => '/help/search?help_search=%{uri}A&ducky=1',
        DDG      => 'https://duckduckgo.com/?q=%{uri}A',
    };
    while ( my ( $site, $url ) = each $sites ) {
        $tags->{ $site } = {
             short   => 1,
             classic => 0,
             class   => 'url',
             output  => "<a href='$url'>%{parse}s</a>",
        }
    }

    $tags->{code} = {
        parse => 0,
        class => 'block',
        code => \&_code_block,
    };

    return $tags;
}

sub _code_block {
    my ( $parser, $attr, $content ) = @_;
    $attr ||= 'perl';
    my $lang = lc(Parse::BBCode::escape_html($attr));
    my $langname = ucfirst($lang);
    $content = Parse::BBCode::escape_html($$content);
    # TODO: Xslate these.
    return <<"EOM";
        <div class="bbcode_code_header">$langname Code:
            <pre><code class="language-$lang">$content</code></pre>
        </div>
EOM
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
            next if $src =~ /^$self->image_proxy_base/;
            next if $src !~ /^http/i;
            $node->attr(
                'src',
                sprintf($self->image_proxy_url, uri_escape($src))
            );
        }
    }

    if ( $opts->{links_new_window} ) {
        for my $node ( $tree->findnodes('//a') ) {
            next if (!$node->attr('href'));
            $node->attr('target', '_blank');
        }
    }

    my $markup = $tree->guts->as_XML;
}

1;
