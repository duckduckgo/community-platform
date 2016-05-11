use strict;
use warnings;

BEGIN {
    $ENV{DDGC_DB_DSN} = 'dbi:SQLite:dbname=ddgc_test.db';
    $ENV{TESTING_GITHUB} = 1;
}

use Test::More;
plan skip_all => 'No Github API key in environment'
    unless ( $ENV{DDGC_GITHUB_TOKEN} );

use t::lib::DDGC::TestUtils;
use DDGC;
my $d = DDGC->new;

my $schema = DDGC::DB->connect( $d );
t::lib::DDGC::TestUtils::deploy( { drop => 1 }, $schema );

$d->github->update_repos( $d->config->github_org, 1 );
my $repo = $d->rs('GitHub::Repo')->search(
    {
        full_name => {
            -like => '%zeroclickinfo-longtail'
        }
    }
)->one_row;
isa_ok( $repo, 'DDGC::DB::Result::GitHub::Repo' );

my $issue = $d->github->gh_api->query(
    '/repos/duckduckgo/zeroclickinfo-longtail/issues/56'
);
ok( $issue->{id}, 'Issue returned from API' );

$issue = $d->github->update_repo_issue_from_data( $repo, $issue );
isa_ok( $issue, 'DDGC::DB::Result::GitHub::Issue' );

ok(
    grep( $_->{name} eq 'Maintainer Input Requested', @{ $issue->tags } ),
    'Maintainer Input Requested tag is present'
);

done_testing;
