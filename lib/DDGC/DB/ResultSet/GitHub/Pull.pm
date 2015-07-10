package DDGC::DB::ResultSet::GitHub::Pull;
# ABSTRACT: Resultset class for GitHub Pulls

use Moose;
extends 'DDGC::DB::Base::ResultSet';
use namespace::autoclean;

sub with_state {
    my ($self, $state) = @_;
	$self->search({ state => $state });
}

sub with_merged_at {
    my ($self, $operator, $date) = @_;
	$self->search({ merged_at => { $operator => $date } });
}

# ignore users who are members of the owners team on github.  these users are
# usually ddg employees:
# https://github.com/orgs/duckduckgo/teams/owners
sub ignore_staff_pull_requests {
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

sub prefetch_comments_not_by_pull_author {
    my ($self) = @_;
    $self->search({
    }, {
        prefetch => 'github_review_comments',
        # ignore comments made by the person who created the pr
        'github_review_comments.github_user_id' => { '!=' => 'me.github_user_id' },
        order_by => 'github_review_comments.created_at'
    });
}

no Moose;
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );
