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

sub prefetch_comments_not_by_issue_author {
    my ($self) = @_;
    $self->search({
    }, {
        prefetch => 'github_comments',
        # ignore comments made by the person who created the issue
        'github_comments.github_user_id' => { '!=' => 'me.github_user_id' },
        order_by => 'github_comments.created_at'
    });
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
