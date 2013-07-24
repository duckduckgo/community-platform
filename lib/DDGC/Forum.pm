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

sub new_thread {
    my ( $self, %params ) = @_;

    my $thread = $self->ddgc->rs('Thread')->new({
        title => $params{title},
        category_id => $params{category_id},
        users_id => $params{user}->id,
    });

    my $category = $thread->category_key;
    $thread->data({ "${category}_status_id" => 1 });
    $thread->insert;

    $self->ddgc->add_comment('DDGC::DB::Result::Thread', $thread->id, $params{user}, $params{content});

    $self->ddgc->db->txn_do(sub { $thread->update });
}

sub get_thread {
    my ( $self, $id ) = @_;
    $self->ddgc->rs('Thread')->single({ id => $id });
}


1;
