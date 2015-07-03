package DDGC::Stats::GitHub::Comments;
use Moo;

use v5.16.0;
use DDP;

=head1 SYNOPSIS

    DDGC::Stats::GitHub::Comments->report(
        db             => $db, # a DDGC::DB obj; required
        since          => $date,
        include_owners => 1,
    );

=cut

has db => (is => 'ro', required => 1);

sub report {
    my ($class, %args) = @_;
    my $self = $class->new(%args);

    my $rs = $self->db->rs('GitHub::Comment')
        ->search
        ->with_created_at('-between' => ['2015-05-01', '2015-06-01']);

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

1;
