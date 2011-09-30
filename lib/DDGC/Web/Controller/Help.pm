package DDGC::Web::Controller::Help;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

sub base :Chained('/base') :PathPart('help') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
	push @{$c->stash->{template_layout}}, 'centered_content.tt';
}

sub view :Chained('base') :PathPart('') :Args(1) {
    my ( $self, $c, $id ) = @_;
}

sub do :Chained('base') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
}

sub list :Chained('do') :Args(0) {
    my ( $self, $c ) = @_;
	my $page = $c->req->params->{page}+0;
	$page = 1 if $page < 1;
	$c->stash->{screens} = [$c->model('DB::Screen')->search({
		deleted => 0,
	},{
		page => $page,
		rows => 20,
	})->all];
}

__PACKAGE__->meta->make_immutable;

1;
