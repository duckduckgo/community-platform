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

sub with_created_at {
    my ($self, $operator, $date) = @_;
	$self->search({ 'me.created_at' => { $operator => $date } });
}

# ignore users who are members of the owners team on github.  these users are
# usually ddg employees:
# https://github.com/orgs/duckduckgo/teams/owners
sub ignore_staff_issues {
    my ($self) = @_;
    $self->search(
        { 'github_user.isa_owners_team_member' => 0 },
        { prefetch => 'github_user' }
    );
}

sub most_recent {
    my ($self) = @_;
    return $self->search(
        {},
        {
            order_by => { -desc => 'updated_at' },
        }
    )->one_row;
}

no Moose;
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );
