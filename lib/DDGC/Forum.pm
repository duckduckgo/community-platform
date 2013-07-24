package DDGC::Forum;
# ABSTRACT: 

use Moose;
use File::ShareDir::ProjectDistDir;
use DDGC::Comments::Comment;
use JSON;
use LWP::Simple;
use URL::Encode 'url_encode_utf8';

has ddgc => (
	isa => 'DDGC',
	is => 'ro',
	weak_ref => 1,
	required => 1,
);

sub search {
    my ( $self, $query ) = @_;
    my $json = get('http://localhost:5000/search?format=json&q='.url_encode_utf8($query));
    my $results;
    eval { $results = decode_json($json) };
    return $results or 0;
}

sub get_threads {
    my ( $self, $pagenum, $count ) = @_;
    $pagenum ||= 1;
    $count   ||= 20;

    return $self->ddgc->rs('Thread')->search({},{ order_by => { -desc => 'updated' } });#->page($pagenum);
}

sub get_thread {
    my ( $self, $id ) = @_;
    $self->ddgc->rs('Thread')->single({ id => $id });
}


1;
