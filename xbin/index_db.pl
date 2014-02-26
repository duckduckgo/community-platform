use DDP;
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
                uri => $thread->id . '/' . $thread->get_url,
                body => $thread->comment->content,
                id => $thread->id,
                title => $thread->title,
                is_markup => 1,
        );
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
                    uri => $_->language_id . '/' . $article->help_category->key . '/' . $article->key,
                    body => $_->content,
                    language_id => $_->language_id,
                    id => $article->id,
                    title => $_->title,
                    is_html => $_->raw_html,
                    is_markup => !$_->raw_html,
            );
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
             uri => join('/', @{$idea->u}[-2,-1]),
             title => $idea->title,
             body => $idea->content,
             id => $idea->id,
             is_markup => 1,
        );
    }
}
print "\nALL DONE!\n";
