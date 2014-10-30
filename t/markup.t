#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;

my %tests = (
    '[quote]Hello, World.[/quote]' => [
      "<div class='bbcode_quote_header'>Quote:<div class='bbcode_quote_body'>Hello, World.</div></div>",
      "Hello, World.",
    ],
    '[quote=somebody]Hello, World.[/quote]' => [
      "<div class='bbcode_quote_header'>Quote from <a href='/somebody'>somebody</a>:<div class='bbcode_quote_body'>Hello, World.</div></div>",
      "Hello, World.",
    ],
    '@somebody' => [
      "<a href='/user/somebody'>\@somebody</a>",
      '@somebody',
    ],
    '@x.yz @a.bc' => [
      "<a href='/user/x.yz'>\@x.yz</a> <a href='/user/a.bc'>\@a.bc</a>",
      '@x.yz @a.bc',
    ],
    'http://duckduckgo.com/?q=@yegg' => [
        '<a href="http://duckduckgo.com/?q=@yegg" rel="nofollow">http://duckduckgo.com/?q=@yegg</a>',
        'http://duckduckgo.com/?q=@yegg'
    ],
    'foo@example.com' => [
        'foo@example.com',
        'foo@example.com'
    ],
    '[code=perl]my @foo;[/code]' => [
        '<div class=\'bbcode_code_header\'>Perl Code:<pre class=\'bbcode_code_body\'><code><span class="synStatement">my</span> <span class="synIdentifier">@foo</span>;'."\n".'</code></pre></div>',
        'my @foo;'
    ],
);

use DDGC;
my $ddgc = DDGC->new;

my $counter = 0;
for my $bbcode (keys %tests) {
  my $results = $tests{$bbcode};
  is $ddgc->markup->html($bbcode), $results->[0], "bbcode parse #$counter";
  is $ddgc->markup->plain($bbcode), $results->[1], "bbcode strip #$counter";
  $counter++;
}

done_testing;
