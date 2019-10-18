package DDGC::Script::GitHub::Issue;
# ABSTRACT: Utilities for working with GitHub Instant Answer issues.

BEGIN {
    require Exporter;
    our @ISA = qw(Exporter);
    our @EXPORT_OK = qw(
        get_dev_milestone
        get_mentions
        id_from_body
        perl_module_from_files
    );
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

sub get_dev_milestone {
    my ($ia_milestone, $production_state, $issue_state) = @_;
    if ($ia_milestone eq 'planning' && $issue_state eq 'open'){
        return 'development';
    } elsif ($ia_milestone !~ /^(live|deprecated|ghosted)$/) {
        if ($issue_state eq 'merged') {
            return 'complete';
        } elsif ($issue_state eq 'closed' && $production_state eq 'offline') {
            return 'planning';
        }
    }
}

sub perl_module_from_file {
    my ($repo, $file) = @_;
    my $tmp_repo = ucfirst $repo;
    $tmp_repo =~ s/s$//g;

    if(my ($name) = $file->{filename} =~ /lib\/DDG\/$tmp_repo\/(.+)\.pm/i ){
        my @parts = split('/', $name);
        $name = join('::', @parts);
        return "DDG::${tmp_repo}::$name";
    }
    return;
}

sub perl_module_from_files {
    my ($repo, $files_data) = @_;
    my @modules = map { perl_module_from_file($repo, $_) } @$files_data;
    $modules[0];
}

1;

__END__
