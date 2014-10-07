#!/usr/bin/env perl

use FindBin;
use lib $FindBin::Dir . "/../lib";

use strict;
use warnings;

use DDGC;
use Getopt::Long;
use DateTime;

my $doit;

GetOptions ("really-delete-comments", \$doit);

my $d = DDGC->new;
sub format_datetime { $d->db->storage->datetime_parser->format_datetime(shift) };

my $comments = $d->rs('Comment')->search_rs(
    {
        ghosted     => 1,
        checked     => { '!=' => undef },
        created     => { '<' => format_datetime( DateTime->now - DateTime::Duration->new( minutes => 30 ) )  },
        parent_id   => { '!=' => undef },
        context     => 'DDGC::DB::Result::Thread',
    },
    {},
);

if (my $no_comments = $comments->count) {
    if ($doit) {
        while (my $comment = $comments->next) {
            $comment->delete;
        }
        print "Deleted $no_comments comments\n";
    }
    else {
        while (my $comment = $comments->next) {
            print $comment->id . ": " . $comment->content . " by " . $comment->user->username . "\n";
        }
        print "\n\nRun with --really-delete-comments to delete these comments\n";
    }
}

