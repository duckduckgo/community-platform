package DDGC::Forum;

use Moose;
use File::ShareDir::ProjectDistDir;
use DDGC::Comments::Comment;
use Parse::BBCode;

my %categories = (
    1 => "discussion",
    2 => "idea",
    3 => "problem",
    4 => "question",
    5 => "announcement",
);

has bbcode => (
    isa => 'Parse::BBCode',
    is => 'ro',
    lazy_build => 1,
);
sub _build_bbcode {
    Parse::BBCode->new({
            close_open_tags => 1,
            attribute_quote => q('"),
            url_finder => {
                max_length  => 200,
                # sprintf format:
                format      => '<a href="%s" rel="nofollow">%s</a>',
            },
            tags => {
                Parse::BBCode::HTML->defaults,
                url => 'url:<a href="%{link}A">%{parse}s</a>',
            },
    });
}

has ddgc => (
	isa => 'DDGC',
	is => 'ro',
	weak_ref => 1,
	required => 1,
);

sub get_threads {
    my ( $self, $pagenum, $count ) = @_;
    $pagenum ||= 0;
    $count   ||= 20;
    
    my @threadsdb = $self->ddgc->rs('Thread')->slice($pagenum*$count, $count-1);
    my @threads;
    for (@threadsdb) {
        my $url = lc($_->title);
        $url =~ s/[^a-z0-9]+/-/g; $url =~ s/-$//;
        my %thread = (
            url     => $_->id . '-' . lc($url),
            title   => $_->title,
            user    => $_->user,
            category=> $categories{$_->category},
        );
        push @threads, \%thread;
    }
    return @threads;
}

sub get_thread {
    my ( $self, $id ) = @_;
    my $threaddb = $self->ddgc->rs('Thread')->single({ id => $id });
    
    my $rendered_text = $self->bbcode->render($threaddb->text);

    my %thread = (
        user            => $threaddb->user,
        title           => $threaddb->title,
        rendered_text   => $rendered_text,
        text            => $threaddb->text,
        id              => $threaddb->id,
        category        => $categories{$threaddb->category},
        created         => $threaddb->created,
    );

    %thread;
}

sub new_thread {
    ...
}

1;
