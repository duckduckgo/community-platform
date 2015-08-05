package DDGC::Stats::GitHub;
use Moo;
use 5.16.0;

use DDP;
use Number::Format qw/round/;
use DDGC::Stats::GitHub::Utils qw/duration_to_minutes human_duration/;
use DateTime;
use List::AllUtils qw/any/;

=head1 SYNOPSIS

    my %report = DDGC::Stats::GitHub->report(
        db      => $db,              # required; a DDGC::DB obj
        between => [$date1, $date2], # required
    );

=cut

has db      => (is => 'ro', required => 1);
has between => (is => 'ro', required => 1);

sub report {
    my ($class, %args) = @_;
    my $self = $class->new(%args);
    return
        $self->issues_report,
        $self->code_review_report,
        $self->lifespan_report,
        $self->committers_report,
        $self->comments_report,
        $self->forks_report;
}

sub comments_report {
    my $self = shift;

    my $rs = $self->db->rs('GitHub::Comment')
        ->search
        ->with_created_at('-between' => $self->between)
        ->ignore_staff_comments();

    my %authors;
    my $comments;
    my $commenters;
    my $total_mins = 0;

    while (my $row = $rs->next) {
        my $user_id = $row->github_user_id;
        $comments++;
        $commenters++ unless $authors{$user_id};
        $authors{$user_id}++;
    }

    return
        {label => ' '},
        { label => 'Comments',   value => $rs->count },
        { label => 'Commenters', value => $commenters };
}

sub committers_report {
    my $self = shift;

    my $rs = $self->db->rs('GitHub::Pull')
        ->search( {}, { prefetch => 'github_issue' } )
        ->with_merged_at('<' => $self->between->[0])
        ->ignore_staff_pull_requests;

    my $unique_committers    = scalar keys %{ $self->authors };
    my $unique_committers_ia = scalar keys %{ $self->ia_authors };
    my %old_committers;
    my %old_committers_ia;

    while (my $github_pull = $rs->next) {
        if ($github_pull->github_issue->isa_new_instant_answer) {
            my $user_id = $github_pull->github_user_id;
            $old_committers{$user_id}++;
        }
        else {
            my $user_id = $github_pull->github_user_id;
            $old_committers_ia{$user_id}++;
        }
    }

    my @old_user_ids    = keys %old_committers;
    my @old_user_ids_ia = keys %old_committers_ia;

    my $repeat_committers = 0;
    for my $user_id (keys %{ $self->authors }) {
        $repeat_committers++ unless any { $_ == $user_id } @old_user_ids;
    }

    my $repeat_committers_ia = 0;
    for my $user_id (keys %{ $self->ia_authors }) {
        $repeat_committers_ia++ unless any { $_ == $user_id } @old_user_ids_ia;
    }

    return
        { label => ' '},
        { label => 'Unique contributers: non IA PRs', value => $unique_committers},
        { label => 'Unique contributers: IA PRs',     value => $unique_committers_ia},
        { label => ' '},
        { label => 'Repeat contributers: non IA PRs', value => $repeat_committers},
        { label => 'Repeat contributers: IA PRs',     value => $repeat_committers_ia};
}

# + avg time to first response - daily
# + avg time to code review - daily
# + committers - # of people who created prs last week
# - people who have returned after 90 days
# + repeat committers
# - red arrows/green arrows

sub forks_report {
    my $self = shift;

    my $rs = $self->db->rs('GitHub::Fork')
        ->search
        ->with_created_at('-between' => $self->between);

    my $forks_with_commits = 0;
    my $forks = 0;

    while (my $row = $rs->next) {
        my $duration = $row->updated_at - $row->created_at;
        my $mins     = duration_to_minutes($duration);
        $forks_with_commits++ if $mins > 5;
        $forks++;
    }

    my $forks_without_commits = $forks - $forks_with_commits;

    return
        { label => ' ' },
        { label => 'Forks created', value => $forks };
}

sub issues_report {
    my $self = shift;

    my $rs = $self->db->rs('GitHub::Issue')
        ->search
        ->with_created_at('-between' => $self->between)
        ->with_isa_pull_request(1)
        ->prefetch('github_comments');

    my $count = 0;
    my $total_mins = 0;

    while (my $github_issue = $rs->next) {
        my $first_comment = $github_issue->github_comments
            ->with_github_user_id('!=' => $github_issue->github_user_id)
            ->order_by('created_at')
            ->first;

        next unless $first_comment;  # FIXME  - should us a duration of zero instead of skipping?

        my $duration = $first_comment->created_at - $github_issue->created_at;
        my $mins     = duration_to_minutes($duration);
        $total_mins += $mins;
        $count++;
    }

    my $avg = $count 
        ? human_duration($total_mins / $count)
        : 0;

    return { label => 'Avg time to first response', value => $avg };
}

has authors    => (is => 'rw', default => sub { {} });
has ia_authors => (is => 'rw', default => sub { {} });

sub code_review_report {
    my $self = shift;

    my $rs = $self->db->rs('GitHub::Pull')
        ->search
        ->with_created_at('-between' => $self->between)
        ->ignore_staff_pull_requests
        ->prefetch('github_review_comments');

    my $review_total = 0;
    my $review_count = 0;
    my $ia_review_total = 0;
    my $ia_review_count = 0;
    my $ia_count = 0;
    my $count    = 0;

    while (my $github_pull = $rs->next) {
        my $user_id = $github_pull->github_user_id;

        if ($github_pull->github_issue->isa_new_instant_answer) {
            $self->ia_authors->{$user_id}++;
            $ia_count++
        }
        else {
            $self->authors->{$user_id}++ ;
            $count++;
        }

        my $comment = $github_pull->github_review_comments
            ->with_github_user_id('!=' => $github_pull->github_user_id)
            ->order_by('created_at')
            ->first
            || next;

        my $duration = $comment->created_at - $github_pull->created_at;
        my $mins = duration_to_minutes($duration);

        if ($github_pull->github_issue->isa_new_instant_answer) {
            $ia_review_total += $mins;
            $ia_review_count++;
        }
        else {
            $review_total += $mins;
            $review_count++;
        }
    }

    my $code_review    = $self->avg_human_duration($review_total, $review_count);
    my $ia_code_review = $self->avg_human_duration($ia_review_total, $ia_review_count);

    return 
        {label => ' '},
        {label => 'Avg time to first code review: IAs', value => $ia_code_review},
        {label => 'Avg time to first code review: Other PRs', value => $code_review},
        {label => ' '},
        {label => 'PRs created: IAs',       value => $ia_count},
        {label => 'PRs created: Other PRs', value => $count};
}

sub lifespan_report {
    my $self = shift;

    my $rs = $self->db->rs('GitHub::Pull')
        ->search( {}, { prefetch => 'github_issue' } )
        ->with_state('closed')
        ->with_merged_at('-between' => $self->between)
        ->ignore_staff_pull_requests;

    my $lifespan_total = 0;
    my $lifespan_count = 0;
    my $ia_lifespan_total = 0;
    my $ia_lifespan_count = 0;
    my $ia_count = 0;
    my $count    = 0;

    while (my $github_pull = $rs->next) {

        my $duration = $github_pull->merged_at - $github_pull->created_at;
        my $mins = duration_to_minutes($duration);

        if ($github_pull->github_issue->isa_new_instant_answer) {
            $ia_lifespan_total += $mins;
            $ia_lifespan_count++;
            $ia_count++;
        }
        else {
            $lifespan_total += $mins;
            $lifespan_count++;
            $count++;
        }
    }

    my $lifespan    = $self->avg_human_duration($lifespan_total, $lifespan_count);
    my $ia_lifespan = $self->avg_human_duration($ia_lifespan_total, $ia_lifespan_count);

    return 
        {label => ' '},
        {label => 'Avg PR lifespan: IAs',       value => $ia_lifespan},
        {label => 'Avg PR lifespan: Other PRs', value => $lifespan},
        {label => ' '},
        {label => 'PRs merged: IAs',            value => $ia_count},
        {label => 'PRs merged: Other PRs',      value => $count};
}

sub avg_human_duration {
    my ($self, $total, $count) = @_;
    return 0 if $count == 0;
    my $avg = round($total / $count, 2);
    return human_duration($avg);
}

1;
