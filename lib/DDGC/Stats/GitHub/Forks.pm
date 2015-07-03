package DDGC::Stats::GitHub::Forks;
use Moo;

use v5.16.0;
use DDP;
use DDGC::Stats::GitHub::Utils qw/duration_to_minutes human_duration/;

=head1 SYNOPSIS

    DDGC::Stats::GitHub::Forks->report(
        db             => $db, # a DDGC::DB obj; required
        since          => $date,
        include_owners => 1,
    );

=cut

has db => (is => 'ro', required => 1);

sub report {
    my ($class, %args) = @_;
    my $self = $class->new(%args);

    my $rs = $self->db->rs('GitHub::Fork')
        ->search
        ->with_created_at('-between' => ['2015-05-01', '2015-06-01']);

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

1;
