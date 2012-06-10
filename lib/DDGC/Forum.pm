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
    $pagenum ||= 1;
    $count   ||= 20;

    return $self->ddgc->rs('Thread')->search({},{ order_by => { -desc => 'updated' } })->page($pagenum);
}

sub get_thread {
    my ( $self, $id ) = @_;
    $self->ddgc->rs('Thread')->single({ id => $id });
}


1;
