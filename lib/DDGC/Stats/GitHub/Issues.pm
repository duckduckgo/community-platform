package DDGC::Stats::GitHub::Issues;
use Moo;

use v5.16.0;
use DDP;
use DDGC::Stats::GitHub::Utils qw/duration_to_minutes human_duration/;

=head1 SYNOPSIS

    DDGC::Stats::GitHub::Issues->report(
        db             => $db, # a DDGC::DB obj; required
        since          => $date,
        include_owners => 1,
    );

=cut

has db => (is => 'ro', required => 1);

sub report {
    my ($class, %args) = @_;
    my $self = $class->new(%args);

    my $rs = $self->db->rs('GitHub::Issue')
        ->search({}, {
            prefetch => 'github_comments',
            order_by => 'github_comments.created_at'
          })
        ->with_closed_at('-between' => ['2015-05-01', '2015-06-01']);


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

1;
