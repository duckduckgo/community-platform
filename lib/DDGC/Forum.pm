package DDGC::Forum;

use Moose;
use File::ShareDir::ProjectDistDir;
use DDGC::Comments::Comment;

my %categories = (
    1 => "discussion",
    2 => "idea",
    3 => "problem",
    4 => "question",
    5 => "announcement",
);


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
    
    my @threads = $self->ddgc->rs('Thread')->slice($pagenum*$count, $count-1);
    @threads;
}

sub get_thread {
    my ( $self, $id ) = @_;
    $self->ddgc->rs('Thread')->single({ id => $id });
}


1;
