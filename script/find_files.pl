#!/usr/bin/env perl
# scan ddh repos and update files for each IA
package FindCodeLinks;
use FindBin;
use lib $FindBin::Dir . "/../lib";
use JSON;
use Data::Dumper;
use File::Find::Rule;
use DDG::Meta::Data;

# the repos we care about
my @repos = (
    'zeroclickinfo-spice',
    'zeroclickinfo-goodies',
    'zeroclickinfo-longtail',
    'zeroclickinfo-fathead',
);

my %process = (
    spice => \&process,
    goodies => \&process_goodies,
    fathead => \&process,
    longtail => \&process,
);

sub process {
    my ($data, $files) = @_;
    my $repo = $data->{repo};
    my $zci = "zeroclickinfo-$repo";

    #find share files
    my @matches = grep{ $_ =~ /share\/$repo\/(?:.+\/)?$data->{id}/ } @{$files->{$zci}};
    #find test files
    push(@matches, grep { $_ =~ /t\/$data->{name}/} @{$files->{$zci}} );
    #find lib files
    push(@matches, grep { $_ =~ /lib\/DDG\/Spice\/$data->{name}/} @{$files->{$zci}} );

    my $result;

    $result->{$data->{id}} = \@matches;

    warn Dumper $result;
}

sub process_goodies {

}

my $files;

my $rule = File::Find::Rule->new;

$rule->or(
    $rule->new
    ->name('*.png', '*.svg', '*.flf')
    ->prune
    ->discard,
    $rule->new
    ->directory
    ->name('share', 't', 'lib'),
    $rule->new
);

foreach my $repo (@repos){
    my @repo_files = $rule->relative->in("/usr/local/ddh/$repo");
    $files->{$repo} = \@repo_files;
}

warn Dumper \$files;

my $meta = DDG::Meta::Data->by_id;

my $newfiles;

while(my($id, $data) = each $meta){
    my $repo = $data->{repo};
    $process{$repo}->($data, $files);
}


