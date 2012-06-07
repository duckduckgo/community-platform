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

sub title_to_path { # construct a id-title-of-thread string from $id and $title
    shift; # knock off $self, don't need it
    my $url = substr(lc($_[1]),0,50);
    $url =~ s/[^a-z0-9]+/-/g; $url =~ s/-$//;
    return $_[0] . "-" . $url;
}

sub get_threads {
    my ( $self, $pagenum, $count ) = @_;
    $pagenum ||= 0;
    $count   ||= 20;
    
    my @threadsdb = $self->ddgc->rs('Thread')->slice($pagenum*$count, $count-1);
    my @threads;
    use DDP;
    for (@threadsdb) {
        my %thread = (
            url     => $self->title_to_path($_->id, $_->title),
            title   => $_->title,
            user    => $_->user,
            category=> $_->category_key,
            updated => $_->updated,
            started => $_->started_term,
            status  => $_->status_key,
        );
        push @threads, \%thread;
    }
    return @threads;
}

sub get_thread {
    my ( $self, $id ) = @_;
    my $threaddb = $self->ddgc->rs('Thread')->single({ id => $id });
    
    my $rendered_text = $self->bbcode->render($threaddb->text);

    my $category = $threaddb->category_key;

    use DDP;
    my $statuses = $threaddb->_statuses;
    p($statuses);
    my $cat_stat = $$statuses{$category};
    p($cat_stat);
    my @status_keys = values %{$cat_stat};

    p(@status_keys);

    my %thread = (
        user            => $threaddb->user,
        title           => $threaddb->title,
        rendered_text   => $rendered_text,
        text            => $threaddb->text,
        id              => $threaddb->id,
        category        => $category,
        created         => $threaddb->created,
        closed          => $threaddb->data->{"${category}_status_id"} == 0,
        status          => $threaddb->status_key,
        statuses        => \@status_keys,
    );

    %thread;
}


1;
