#!/usr/bin/env perl
use FindBin;
use lib $FindBin::Dir . '/../lib';

use strict;
use warnings;

use DDGC;
use DDGC::Search::Client;

my $ddgc = DDGC->new;
STDOUT->autoflush(1);

{
    my $search = DDGC::Search::Client->new(
        ddgc => $ddgc,
        type => 'thread',
    );
    my $rs = $ddgc->rs('Thread');

    my $c;
    my $total = $rs->count;

    while (my $thread = $rs->next) {
        print "\rThreads: " . ++$c . '/' . $total;
        $search->index(
                uri => $thread->id,
                body => $thread->comment->content,
                id => $thread->id,
                title => $thread->title,
                defined $thread->data && $thread->data->{___duckco_import___} ? (is_html => 1) : (is_markup => 1),
        )->is_success || warn "Could not index thread ".$thread->id;
    }
}

print "\n";

{
    my $search = DDGC::Search::Client->new(
        ddgc => $ddgc,
        type => 'help',
    );
    my $rs = $ddgc->rs('Help');

    my $c;
    my $total = $rs->count;

    while (my $article = $rs->next) {
        print "\rHelp: " . ++$c . '/' . $total;
        for ($article->help_contents->all) {
            $search->index(
                    uri => $article->id,
                    body => $_->content,
                    language_id => $_->language_id,
                    id => $article->id,
                    title => $_->title,
                    is_html => $_->raw_html,
                    is_markup => !$_->raw_html,
            )->is_success || warn "Could not index help article ".$article->id;
        }
    }
}

print "\n";

{
    my $search = DDGC::Search::Client->new(
        ddgc => $ddgc,
        type => 'idea',
    );
    my $rs = $ddgc->rs('Idea');

    my $c;
    my $total = $rs->count;

    while (my $idea = $rs->next) {
        print "\rIdeas: " . ++$c . '/' . $total;
        $search->index(
             uri => $idea->id,
             title => $idea->title,
             body => $idea->content,
             id => $idea->id,
             is_markup => 1,
        )->is_success || warn "Could not index idea ".$idea->id;
    }
}
print "\nALL DONE!\n";
