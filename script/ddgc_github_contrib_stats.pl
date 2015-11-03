#!/usr/bin/env perl

# Github contributor stats, in this repo because why not?

use strict;
use warnings;
use IPC::Open3;
use File::Temp qw/ tempfile tempdir /;
use Term::ReadKey;
use Net::GitHub;
use Time::Piece;
use Time::Seconds;
use Try::Tiny;

$|=1;

my $repository_url = 'https://github.com/duckduckgo/';

my $core_team_github = {
    bsstoner    =>  {
        name =>  'Brian Stoner'
    },
    b1ake       =>  {
        name =>  'Blake Jennelle'
    },
    davidmascio =>  {
    },
    chrismorast => {
    },
    faraday     =>  {
        name =>  'Çağatay Çallı'
    },
    friedo      =>  {
        name =>  'Mike Friedman'
    },
    getty       =>  {
        name =>  'Torsten Raudssus'
    },
    hunterlang  =>  {
        name =>  'Hunter Lang'
    },
    jagtalon    =>  {
        name =>  'Jag Talon'
    },
    jbarrett    =>  {
        name =>  'John Barrett'
    },
    jkanarek    =>  {
    },
    kevinpelgrims => {
        name =>  'Kevin Pelgrims'
    },
    koenmetsu   =>  {
        name =>  'Koen Metsu'
    },
    malbin      =>  {
        name =>  'Jaryd Malbin'
    },
    moollaza    =>  {
        name =>  'Zaahir Moolla'
    },
    mrshu       =>  {
        name =>  'Marek Šuppa'
    },
    nilnilnil   =>  {
        name =>  'Caine Tighe'
    },
    pswam       =>  {
        name =>  'Prakash S'
    },
    russellholt =>  {
        name =>  'Russell Holt'
    },
    sdougbrown  =>  {
        name =>  'Doug Brown'
    },
    yegg        =>  {
        name =>  'Gabriel Weinberg'
    },
    zekiel      =>  {
        name =>  'Zac Pappis'
    },
    ddh5        => {
        name =>  'DuckDuckHack Five',
    },
    dax => {
        name => 'Dax the Duck',
    },
    ddg => {
        name => 'DuckDuckGo',
    },
    abeyang     =>  {
        name =>  'Abe Yang',
    },
    jdorweiler  =>  {
        name =>  'Jason',
    },
    thm => {
        name =>  'Thom',
    },
    tommytommytommy => {
        name => 'Tommy Leung',
    },
    'AdamSC1-ddg' => {
    },
    'andrey-p' => {
        name => 'Andrey Pissantchev',
    },
    MariagraziaAlastra => {
        name => 'Maria Grazia Alastra',
    },
    zachthompson => {
        name => 'Zach Thompson',
    },
    tagawa => {
        name => 'Daniel Davis',
    },
};

# Should come from API in future:
my @projects = qw/
    zeroclickinfo-goodies
    zeroclickinfo-spice
    zeroclickinfo-longtail
    zeroclickinfo-fathead
    zeroclickinfo-goodie-spell
    zeroclickinfo-goodie-math
    zeroclickinfo-goodie-isvalid
    zeroclickinfo-goodie-chords
    zeroclickinfo-goodie-qrcode
/;

sub github_creds {
    ($ENV{DDGC_GITHUB_TOKEN}) && return ( access_token => $ENV{DDGC_GITHUB_TOKEN} );

    print "GitHub API limits requests to 60 per hour, please provide login so this script doesn't fail\n\n";

    print "Username : ";
    chomp (my $u = <STDIN>);

    ReadMode('noecho');
    print "Password : ";
    chomp (my $p = <STDIN>);
    ReadMode(0); print "\n";

    return ( login => $u, pass => $p );
}

my $gh = Net::GitHub->new( github_creds() );
my $today = localtime;
my $periods = [
    { start => $today - (ONE_DAY * 90),  end => $today },
    { start => $today - (ONE_DAY * 180), end => $today - (ONE_DAY * 90) },
];
my $log;

print "working";

for my $project (@projects) {
    next if $project eq 'nodejs-duckpan-npm'; # empty, API bombs
MONTH:
    for (0..$#$periods) {
        my $since = $periods->[$_]->{start}->ymd . "T00:00:00Z";
        my $until = $periods->[$_]->{end}->ymd . "T00:00:00Z";
        my $commits = undef;
        do {
            my $request = "/repos/duckduckgo/$project/commits";
            $request .= "?since=" . $since;
            $request .= "&until=" . $until;
            $request .= "&per_page=100";
            my $page = 1;
            my $err = 0;

            try {
                $commits = $gh->query('GET', $request);
            } catch {
                $err = 1;
                print STDERR "$request failed - skipping\n";
            };
            next if $err;

            print ".";

            for my $commit (@{$commits}) {
                #my $author = $commit->{author}->{login} || $commit->{committer}->{login} || "";
                my $author = $commit->{author}->{login} || $commit->{committer}->{login} ||
                    $commit->{commit}->{author}->{name} || $commit->{commit}->{committer}->{name} || "";

                $author or next;
                unless ( grep { $_ =~ /$author/i ||
                                ( $core_team_github->{$_}->{name} &&
                                  $core_team_github->{$_}->{name} =~ /$author/ )
                              } (keys $core_team_github) ) {
                    $log->[$_]->{authors}->{$author} = 1;
                }
            }
            $page++; #print "$project commits : " . scalar @{$commits} . "\n";
            if ( scalar @{$commits} >= 100 ) {
                $until = $commits->[-1]->{commit}->{author}->{date} ||
                         $commits->[-1]->{commit}->{committer}->{date} || die; # pagination really not working... Move date pointer
                next MONTH if ($until le $since);
                #print "New $since\n";
            }
        } while (scalar @{$commits} >= 100);
    }

    my $request = "/repos/duckduckgo/$project/pulls?state=open&sort=created";
    my $pulls = undef;

    try {
        $pulls = $gh->query('GET', $request);
    } catch {
        print "$request failed - skipping\n";
        next;
    };

    for (0..$#$periods) {
        my $since = $periods->[$_]->{start}->ymd . "T00:00:00Z";
        my $until = $periods->[$_]->{end}->ymd . "T00:00:00Z";

        for my $pull (@{$pulls}) {

            next unless ( $pull->{created_at} lt $until &&
                          $pull->{created_at} ge $since );

            my $author = $pull->{user}->{login}; # PRs should always have a login.
            $author or next;

            unless ( grep { $_ =~ /^$author$/i } (keys $core_team_github) ) {
                $log->[$_]->{authors}->{$author} = 1;
            }
        }
    }
}

for (0..$#$periods) {
    print "\nUnique GitHub contributors " . $periods->[$_]->{start}->mdy . " through " . ($periods->[$_]->{end} - ONE_DAY )->mdy . "\t";
    print scalar (keys $log->[$_]->{authors}) . "\n";
    print "Logins : " . join(', ', sort keys $log->[$_]->{authors}) . "\n";
}

