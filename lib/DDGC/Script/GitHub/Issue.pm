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

my $ia_re = qr/(?:Instant\s?Answer|IA)\sPage/i;
my $duck_co_re = qr{https?://duck\.co/ia/view/(?<id>\w+[^\s])}i;
# get the IA name from the link in the first comment
# Update this later for whatever format we decide on
# Match (roughly) the following formats:
# Instant Answer Page: Link   <- preferred standard link
my $norm_form = qr{$ia_re:?\s+$duck_co_re}i;
# [Instant Answer Page](Link) <- GHFM link
my $gh_form = qr{\[$ia_re\]\($duck_co_re\)}i;
sub id_from_body {
    my ($body) = @_;
    $body =~ qr{$gh_form|$norm_form}i;
    return $+{id};
}

1;

__END__
