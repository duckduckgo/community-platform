package DDGC::Stats::GitHub::PullRequests;
use Moo;

use v5.16.0;
use DDP;
use Number::Format qw/round/;
use DDGC::Stats::GitHub::Utils qw/duration_to_minutes human_duration/;

=head1 SYNOPSIS

    DDGC::Stats::GitHub::PullRequests->report(
        db             => $db, # a DDGC::DB obj; required
        since          => $date,
        include_owners => 1,
    );

=cut

has db => (is => 'ro', required => 1);

sub report {
    my ($class, %args) = @_;
    my $self = $class->new(%args);

    my $rs = $self->db->rs('GitHub::Pull')
        ->search
        ->with_state('closed')
        ->with_merged_at('-between' => ['2015-05-01', '2015-06-01']);

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
