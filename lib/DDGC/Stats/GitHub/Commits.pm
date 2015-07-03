package DDGC::Stats::GitHub::Commits;
use Moo;

use v5.16.0;
use DDP;

=head1 SYNOPSIS

    DDGC::Stats::GitHub::Commits->report(
        db             => $db, # a DDGC::DB obj; required
        since          => $date,
        include_owners => 1,
    );

=cut

has db => (is => 'ro', required => 1);

# This is a fine way to get the number of committers
# FIXME This is a bad way to get the number of commits.  Instead I should shell out
# to the command line to calculate that.  
sub report {
    my ($class, %args) = @_;
    my $self = $class->new(%args);

    my $rs = $self->db->rs('GitHub::Commit')
        ->search
        ->with_author_date('-between' => ['2015-05-01', '2015-06-01']);

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

#sub report {
#    my ($class, %args) = @_;
#    my $self = $class->new(%args);
#
#    my $rs = $self->db->rs('GitHub::Issue')
#        ->search
#        ->with_isa_pull_request(1)
#        ->with_state('closed')
#        ->with_created_at('-between' => ['2015-05-01', '2015-06-01']);
#
#    my %authors;
#    my $commits;
#    my $committers;
#
#    while (my $row = $rs->next) {
#        my $name = $row->author;
#        $commits++;
#        $committers++ unless $authors{$name};
#        $authors{$name}++;
#    }
#
#    return ( 
#        commits    => $rs->count,
#        committers => $committers,
#    );
#}

1;
