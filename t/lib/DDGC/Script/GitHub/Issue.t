#!/usr/bin/env perl

use strict;
use warnings;

use List::Util qw(pairs);

use Test::Deep;
use Test::More;

use DDGC::Script::GitHub::Issue qw(
    get_dev_milestone
    get_mentions
    id_from_body
    perl_module_from_files
);

subtest get_mentions => sub {
    subtest 'no mentions' => sub {
        my %cases = (
            ''              => 'empty',
            '@$'            => 'symbol mention',
            'No @ mentions' => 'no valid @mentions',
            'Simple'        => 'no @ at all',
        );
        map { cmp_deeply(get_mentions($_), [], $cases{$_}) } (sort keys %cases);
    };
    cmp_deeply(get_mentions('@foo'), ['foo'], 'single mention');
    cmp_deeply(get_mentions('@foo @bar'), ['foo', 'bar'], 'multiple mentions');
};

subtest id_from_body => sub {
    subtest 'no IDs' => sub {
        my %cases = (
            ''                            => 'empty',
            'duck.co/ia/view/foo'         => 'no protocol',
            'https://duck.co/ia/view/foo' => 'no indication of main link',
        );
        map { cmp_deeply(id_from_body($_), undef, $cases{$_}) } (sort keys %cases);
    };

    subtest formats => sub {
        my %cases = (
            'IA Page:  https://duck.co/ia/view/foo'              => 'double spacing',
            'IA Page: http://duck.co/ia/view/foo'                => 'http',
            'IA Page: https://duck.co/ia/view/foo'               => 'short',
            'Instant Answer Page: https://duck.co/ia/view/foo'   => 'long',
            '[IA Page](https://duck.co/ia/view/foo)'             => 'markdown',
            '[Instant Answer Page](https://duck.co/ia/view/foo)' => 'full markdown',
        );
        map { cmp_deeply(id_from_body($_), 'foo', $cases{$_}) } (sort keys %cases);
    };

    cmp_deeply(id_from_body(<<'EOF'
Some description

---
IA Page: https://duck.co/ia/view/foo
Maintainer: @foo
EOF
            ), 'foo', 'typical issue body');
    cmp_deeply(id_from_body(<<'EOF'
This issue mentions [bar](https://duck.co/ia/view/bar), but it's really
about foo.

---
IA Page: https://duck.co/ia/view/foo
Maintainer: @foo
EOF
    ), 'foo', 'proper mention with mixed mentions');

};

subtest get_dev_milestone => sub {
    my @cases = (
        [qw(deprecated online open)]  => '',
        [qw(ghosted online open)]     => '',
        [qw(live online open)]        => '',
        [qw(planning offline closed)] => 'planning',
        [qw(planning offline open)]   => 'development',
        [qw(planning online merged)]  => 'complete',
        [qw(planning online open)]    => 'development',
    );
    map {
        my ($args, $expect) = @$_;
        cmp_deeply(get_dev_milestone(@$args), $expect,
            join(' ', map { qq{"$_"} } @$args));
    } (pairs @cases);
};

subtest perl_module_from_files => sub {
    subtest 'single files' => sub {
        my @cases = (
            ['Goodie', '']                          => [undef, 'empty'],
            ['Goodie', 'lib/DDG/Goodie/Foo.pm']     => ['DDG::Goodie::Foo', 'standard path'],
            ['Goodie', 'lib/DDG/Goodie/Foo/Bar.pm'] => ['DDG::Goodie::Foo::Bar', 'nested path'],
            ['Spice', 'lib/DDG/Goodie/Foo.pm']      => [undef, 'wrong repo'],
            ['Spice', 'lib/DDG/Spice/Foo.pm']       => ['DDG::Spice::Foo', 'spice repo'],
        );
        map {
            my ($args, $res) = @$_;
            my ($expected, $comment) = @$res;
            my ($repo, $file) = @$args;
            cmp_deeply(perl_module_from_files($repo, [{ filename => $file}]),
                $expected, "$comment: $file");
        } (pairs @cases);
    };
    cmp_deeply(perl_module_from_files('Goodie',
        [ map { { filename => $_ } }
            ('lib/DDG/Goodie/Foo.pm', 'lib/DDG/Goodie/Bar.pm')
        ]), 'DDG::Goodie::Foo', 'multiple files same repo');
    cmp_deeply(perl_module_from_files('Goodie',
        [ map { { filename => $_ } }
            ('lib/DDG/Spice/Bar.pm', 'lib/DDG/Goodie/Foo.pm')
        ]), 'DDG::Goodie::Foo', 'multiple files different repos');

};

done_testing;

1;
