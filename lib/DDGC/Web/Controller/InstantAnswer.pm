package DDGC::Web::Controller::InstantAnswer;
# ABSTRACT: Instant Answer Pages

use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

sub base :Chained('/base') :PathPart('ia') :CaptureArgs(0) {
	my ( $self, $c ) = @_;
}

sub index :Chained('base') :PathPart('') :Args(0) {
	my ( $self, $c ) = @_;
	# Retrieve / stash all IAs for index page here?

    # my @x = $c->d->rs('InstantAnswer')->all();
    # $c->stash->{ialist} = \@x;
    @{$c->stash->{ialist}} = $c->d->rs('InstantAnswer')->all();
}

# this is just for testing
# I'm expecting the index to be returned as JSON. all of the data.
sub ialist_json :Chained('base') :PathPart('json') :Args(0) {
	my ( $self, $c ) = @_;

    # $c->stash->{x} = {
    #     ia_list => "this will be the list of all IAs"
    # };

    my @x = $c->d->rs('InstantAnswer')->all();
    my @ial;

    for (@x) {
        push (@ial, {
                name => $_->name,
                id => $_->id,
                repo => $_->repo,
                dev_milestone => $_->dev_milestone,
                perl_module => $_->perl_module,
                description => $_->description
            });
    }

    $c->stash->{x} = \@ial;
    $c->forward($c->view('JSON'));
}

sub ia_base :Chained('base') :PathPart('view') :CaptureArgs(1) {
	my ( $self, $c, $answer_id ) = @_;

	$c->stash->{ia} = $c->d->rs('InstantAnswer')->find($answer_id);

    use JSON;
    my $topics = $c->stash->{ia}->topic;
    $c->stash->{ia_topics} = decode_json($topics);

    my $code = $c->stash->{ia}->code;
    $c->stash->{ia_code} = decode_json($code);

    my $other_queries = $c->stash->{ia}->other_queries;
    if ($other_queries) {
        $c->stash->{ia_other_queries} = decode_json($other_queries);
    }

	unless ($c->stash->{ia}) {
		$c->response->redirect($c->chained_uri('InstantAnswer','index',{ instant_answer_not_found => 1 }));
		return $c->detach;
	}

	use DDP;
	$c->stash->{ia_pretty} = p $c->stash->{ia};
}

sub ia_json :Chained('ia_base') :PathPart('json') :Args(0) {
	my ( $self, $c) = @_;

    my $ia = $c->stash->{ia}; #$c->d->rs('InstantAnswer')->find($answer_id);

    $c->stash->{x} =  {
                name => $ia->name,
                id => $ia->id,
                repo => $ia->repo,
                example_query => $ia->example_query,
                other_queries => $c->stash->{ia_other_queries},
                dev_milestone => $ia->dev_milestone,
                perl_module => $ia->perl_module,
                code => $c->stash->{ia_code},
                topic => $c->stash->{ia_topics}
    };
    $c->forward($c->view('JSON'));
}

sub ia  :Chained('ia_base') :PathPart('') :Args(0) {
	my ( $self, $c ) = @_;
}


no Moose;
__PACKAGE__->meta->make_immutable;

