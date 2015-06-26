package Dancer2::Plugin::DDGC::Markup;

# ABSTRACT: Return a DDGC::Util::Markup instance

use strict;
use warnings;

use DDGC::Util::Markup;
use Dancer2::Plugin;

my $markup = DDGC::Util::Markup->new;

register markup => sub { $markup };

register_plugin;

1;

__END__

=pod

=head1 NAME

Dancer2::Plugin::DDGC::Markup - HTML Rendering / Cleaning with Markdown,
BBCode support

=head1 SYNOPSIS

    use Dancer2;
    use Dancer2::Plugin::DDGC::Markup;

    my $html = markup->markdown( $markdown_string );

=head1 DESCRIPTION

Dancer2::Plugin::DDGC::Markup provides HTML Rendering for BBCode and
Markdown content. It can also clean and render existing HTML (i.e.
run images through 

=head1 FUNCTIONS

=head2 markdown

Returns a DDGC::Util::Markdown instance

=head1 METHODS

Use the method which matches the format of your source string.

=head2 html

=head2 bbcode

=head2 markdown

=head1 SEE ALSO

See L<DDGC::Util::Markup> for more detail.

=cut
