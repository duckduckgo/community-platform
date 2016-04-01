package DDGC::DB::ResultSte::GitHub::Issue::Event;

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

# ignore users who are members of the core team on github. these users are
# usually ddg employees:
# https://github.com/orgs/duckduckgo/teams/core
sub ignore_staff_issue_events {
    my ($self) = @_;
    $self->search(
        { 'me.github_user.isa_owners_team_member' => 0 },
        { prefetch => 'github_user' }
    );
}

sub most_recent {
    my ($self) = @_;
    return $self->search(
        {},
        {
            order_by => { -desc => 'created_at' },
        }
    )->one_row;
}

no Moose;
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );
