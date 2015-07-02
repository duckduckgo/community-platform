package DDGC::DB::ResultSet::GitHub::Issue;
# ABSTRACT: Resultset class for GitHub Issues

use Moose;
extends 'DDGC::DB::Base::ResultSet';
use namespace::autoclean;

sub with_state {
    my ($self, $state) = @_;
	$self->search({ state => $state });
}

sub with_isa_pull_request {
    my ($self, $value) = @_;
	$self->search({ isa_pull_request => $value });
}

sub with_closed_at {
    my ($self, $operator, $date) = @_;
	$self->search({ closed_at => { $operator => $date } });
}

sub most_recent {
    my ($self) = @_;
    return $self->search(
        {},
        {
            rows => 1,
            order_by => { -desc => 'updated_at' },
        }
    )->first;
}

no Moose;
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );
