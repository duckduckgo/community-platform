package DDGC::Stats::GitHub;
use Moo;
use 5.16.0;

use DDP;
use Number::Format qw/round/;
use DDGC::Stats::GitHub::Utils qw/duration_to_minutes human_duration/;

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
        first_response        => '--',
        first_review          => '--',
        lifespan              => '--',
        commits               => '--',
        committers            => '--',
        commenters            => '--',
        forks_with_commits    => '--',
        forks_without_commits => '--',
        $self->comments_report,
        $self->commits_report,
        $self->forks_report,
        $self->issues_report,
        $self->pull_requests_report;
}

sub comments_report {
    my $self = shift;

    my $rs = $self->db->rs('GitHub::Comment')
        ->search
        ->with_created_at('-between' => $self->between);

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

    return ( 
        comments       => $rs->count,
        commenters     => $commenters,
    );
}

# This is a fine way to get the number of committers
# FIXME This is a bad way to get the number of commits.  Instead I should shell out
# to the command line to calculate that.  
sub commits_report {
    my $self = shift;

    my $rs = $self->db->rs('GitHub::Commit')
        ->search
        ->with_author_date('-between' => $self->between);

    my %authors;
    my $committers;

    while (my $row = $rs->next) {
        my $name = $row->author_name;
        $committers++ unless $authors{$name};
        $authors{$name}++;
    }

    return ( 
        commits    => $rs->count,
        committers => $committers,
    );
}

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

    return (
        forks_with_commits    => $forks_with_commits,
        forks_without_commits => $forks_without_commits,
    );
}

sub issues_report {
    my $self = shift;

    my $rs = $self->db->rs('GitHub::Issue')
        ->search({}, {
            prefetch => 'github_comments',
            order_by => 'github_comments.created_at'
          })
        ->with_closed_at('-between' => $self->between);


    my $count = 0;
    my $total_mins = 0;

    while (my $row = $rs->next) {
        my $first_comment = $row->github_comments->first;
        next unless $first_comment;  # FIXME  - should us a duration of zero instead of skipping?

        my $duration = $first_comment->created_at - $row->created_at;
#p $duration;
        my $mins     = duration_to_minutes($duration);
        $total_mins += $mins;
        $count++;
    }

    my $avg = human_duration($total_mins / $count);

    return (first_response => $avg);
}

sub pull_requests_report {
    my $self = shift;

    my $rs = $self->db->rs('GitHub::Pull')
        ->search
        ->with_state('closed')
        ->with_merged_at('-between' => $self->between);

    my $total  = 0;
    my $count  = 0;
    my $format = DateTime::Format::RFC3339->new;

    while (my $row = $rs->next) {
        my $duration = $row->merged_at - $row->created_at;
        my $mins = duration_to_minutes($duration);
        $total += $mins;
        $count++;
    }

    my $avg = round($total / $count, 2);
    my $lifespan = human_duration($avg);

    return (lifespan => $lifespan);
}

1;
