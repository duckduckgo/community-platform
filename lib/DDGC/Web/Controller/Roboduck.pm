package DDGC::Web::Controller::Roboduck;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

sub base :Chained('/base') :PathPart('roboduck') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
}

sub index :Chained('base') :PathPart('') :Args(0) {
    my ( $self, $c ) = @_;
    my $query = $c->req->param('q');
    if ($query) {
    	my ( $answer, $id ) = $c->d->roboduck->tell(
    		$query, $c->user ? $c->user->username : 'Stranger'
    	);
    	$c->stash->{answer} = $answer;
    }
}

__PACKAGE__->meta->make_immutable;

1;
