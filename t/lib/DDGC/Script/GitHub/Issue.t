#!/usr/bin/env perl

use strict;
use warnings;

use Test::Deep;
use Test::More;

use DDGC::Script::GitHub::Issue qw(get_mentions);

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

done_testing;

1;
