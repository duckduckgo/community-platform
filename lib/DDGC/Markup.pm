package DDGC::Markup;

use Moose;
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

sub _build_bbcode {
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
			url => 'url:<a href="%{link}A">%{parse}s</a>',
			img => '<a href="%{link}A"><img src="%{link}A" alt="[%{html}s]" title="%{html}s"></a>',
			code => {
				code => sub {
				    my ($parser, $attr, $content, $attribute_fallback) = @_;
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
				        $lang = ucfirst($attr)." ";
				    } else {
				        $content = Parse::BBCode::escape_html($$content);
				    }
				    "<div class='bbcode_code_header'>${lang}Code:<pre class='bbcode_code_body'>$content</pre></div>"
				},
				parse => 0,
				class => 'block',
			},
			quote => {
			    parse => 1,
			    slass => 'block',
			    code => sub {
			        my ($parser, $attr, $content, $attribute_fallback) = @_;
			        "<div class='bbcode_quote_header'>Quote from {{#USER $attribute_fallback #}}:<div class='bbcode_quote_body'>$$content</div></div>";
			    },
			},
	    },
	});
}

sub html {
	my ( $self, @code_parts ) = @_;
	return $self->bbcode->render(join(' ',@code_parts));
}

1;