package DDGC::Forum;

use Moose;
use File::ShareDir::ProjectDistDir;
use DDGC::Comments::Comment;

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
            user    => $_->users_id,
        );
        push @threads, \%thread;
    }
    return @threads;
}

sub get_thread {
    my ( $self, $id ) = @_;
    my $thread = $self->ddgc->rs('Thread')->single({ id => $id });

    $thread;
}

1;
