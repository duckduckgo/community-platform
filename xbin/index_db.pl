use DDP;
use DDGC;
use DDGC::Search::Client;

my $ddgc = DDGC->new;
my $search = DDGC::Search::Client->new(
    ddgc => $ddgc,
    type => 'thread',
);

my $rs = $ddgc->rs('Thread');

STDOUT->autoflush(1);
my $c;
my $total = $rs->count;

while (my $thread = $rs->next) {
    print "\r" . ++$c . '/' . $total;
    $search->index(
            uri => $thread->id . '/' . $thread->get_url,
            body => $thread->comment->content,
            users_id => $thread->users_id,
            thread_id => $thread->id,
            title => $thread->title,
            is_markup => 1,
    );
}

