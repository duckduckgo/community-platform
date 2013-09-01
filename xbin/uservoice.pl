use URI;
use Web::Scraper;
use DDP;
use DDGC;
use DateTime::Format::Strptime;

# Stream flushing for progress
use IO::Handle; STDOUT->autoflush(1);

# datetime parser
my $dt = DateTime::Format::Strptime->new(pattern => '%d-%b-%Y %I:%M %p');

#my $ddgc = DDGC->new;


#my $import_user = $ddgc->find_user($ENV{DDGC_IMPORT_USERNAME} // 'duckco');

my $list_page = scraper {
    process "li.uvListItem.uvIdea", 'ideas[]' => scraper {
        process "h2.uvIdeaTitle a", link => '@href', title => 'TEXT';
    };
    process "a.next_page", next => '@href';
};

my $comment = scraper {
    process "div.uvUserActionHeader span.vcard span.fn", author => 'TEXT';
    process "div.uvUserActionBody div.typeset", body => 'HTML';
    process "span.uvStyle-meta time", date => '@datetime';
};

my $idea_page = scraper {
    process "div.uvIdeaDescription div.typeset", description => 'HTML';
    process "section.uvIdeaStatus", admin_comment => $comment;
    process "ul.uvList.uvList-comments li.uvListItem", 'comments[]' => $comment;
    process "div.uvIdeaVoteCount strong", votes => 'TEXT';
    process "span.uvStyle-status", status => 'TEXT';
};

my $next_page = "http://duckduckhack.uservoice.com/forums/5168-ideas-for-duckduckgo-instant-answer-plugins";
my $idea_count = 0;

sub process_idea {
    my ($idea, $title) = @_;
    p $idea;
}

while (1) {
    my $page = $list_page->scrape(URI->new($next_page));

    for my $idea (@{$page->{ideas}}) {
        process_idea $idea_page->scrape($idea->{link}), $idea->{title};
    }

    exit unless defined $page->{next};

    $next_page = "http://duckduckhack.uservoice.com/".$page->{next};
}
