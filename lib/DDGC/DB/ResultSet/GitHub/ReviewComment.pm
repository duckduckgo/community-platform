package DDGC::DB::ResultSet::GitHub::ReviewComment;
# ABSTRACT: Resultset class for GitHub Review Comments

use Moose;
extends 'DDGC::DB::Base::ResultSet';
use namespace::autoclean;

sub with_created_at {
    my ($self, $operator, $date) = @_;
	$self->search({ 'me.created_at' => { $operator => $date } });
}

sub with_github_user_id {
    my ($self, $operator, $github_user_id) = @_;
	$self->search({ 'me.github_user_id' => { $operator => $github_user_id } });
}

# ignore users who are members of the owners team on github.  these users are
# usually ddg employees:
# https://github.com/orgs/duckduckgo/teams/owners
sub ignore_staff_comments {
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
            rows => 1,
            order_by => { -desc => 'updated_at' },
        }
    )->first;
}

no Moose;
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );
