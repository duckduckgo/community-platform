package DDGC::Script::GitHub::Issue;
# ABSTRACT: Utilities for working with GitHub Instant Answer issues.

BEGIN {
    require Exporter;
    our @ISA = qw(Exporter);
    our @EXPORT_OK = qw(get_mentions id_from_body);
}

sub get_mentions {
    my ($comment) = @_;

    my @mentions = $comment =~ /@(\w+)/g;
    return [@mentions];
}

# get the IA name from the link in the first comment
# Update this later for whatever format we decide on
# Match (roughly) the following formats:
# Instant Answer Page: Link   <- preferred standard link
# [Instant Answer Page](Link) <- GHFM link
sub id_from_body {
    my ($body) = @_;
    $body =~ qr{
    \[(?:Instant\s?Answer|IA)\sPage\]\(https?://duck\.co/ia/view/(?<id>\w+[^\s])\)
    | (?:Instant\s?Answer|IA)\sPage:?\s+ https?://duck\.co/ia/view/(?<id>\w+[^\s])}ix;

    return $+{id};
}

1;

__END__
