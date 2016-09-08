package DDGC::Script::GitHub::Issue;
# ABSTRACT: Utilities for working with GitHub Instant Answer issues.

BEGIN {
    require Exporter;
    our @ISA = qw(Exporter);
    our @EXPORT_OK = qw(get_mentions);
}

sub get_mentions {
    my ($comment) = @_;

    my @mentions = $comment =~ /@(\w+)/g;
    return [@mentions];
}

1;

__END__
