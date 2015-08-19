#!/usr/bin/env perl
# scan ddh repos and update files for each IA
package FindCodeLinks;
use FindBin;
use lib $FindBin::Dir . "/../lib";
use JSON;
use Data::Dumper;
use File::Find::Rule;
use DDG::Meta::Data;


my $rule = File::Find::Rule->new;
my $meta = DDG::Meta::Data->by_id;

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

# the repos we care about
my @repos = (
    'zeroclickinfo-spice',
    'zeroclickinfo-goodies',
    'zeroclickinfo-longtail',
    'zeroclickinfo-fathead',
);

my %process = (
    spice => \&normal_process,
    goodies => \&goodies_process,
    fathead => \&normal_process,
    longtail => \&normal_process,
);

sub normal_process {
    my ($data, $files) = @_;
    my $repo = $data->{repo};
    my $zci = "zeroclickinfo-$repo";

    #find share files
    my @matches = grep{ $_ =~ /share\/$repo\/(?:.+\/)?$data->{id}/ } @{$files->{$zci}};
    #find test files
    push(@matches, grep { $_ =~ /t\/$data->{name}\./} @{$files->{$zci}} );
    #find lib files
    $repo = ucfirst $repo;
    push(@matches, grep { $_ =~ /lib\/DDG\/$repo\/$data->{name}\./} @{$files->{$zci}} );

    my $result;

    $result->{$data->{id}} = \@matches;

    warn Dumper $result;
}

sub goodies_process {
    my ($data, $files) = @_;
    my $repo = 'goodie';
    my $zci = "zeroclickinfo-goodies";

    #find share files
    my @matches = grep{ $_ =~ /share\/$repo\/(?:.+\/)?$data->{id}\./ } @{$files->{$zci}};
    #find test files
    push(@matches, grep { $_ =~ /t\/$data->{name}\./} @{$files->{$zci}} );
    #find lib files
    $repo = ucfirst $repo;
    push(@matches, grep { $_ =~ /lib\/DDG\/$repo\/$data->{name}\./} @{$files->{$zci}} );

    # file cheat sheet json files
    if($data->{perl_module} =~ /cheatsheet/i){
        push(@matches, File::Find::Rule
            ->name('*.json')
            ->grep( qr/$data->{id}/)
            ->relative
            ->in("/usr/local/ddh/$zci/")
        );
    }

    my $result;

    $result->{$data->{id}} = \@matches;

    warn Dumper $result;
}


my $files;
foreach my $repo (@repos){
    my @repo_files = $rule->relative->in("/usr/local/ddh/$repo");
    $files->{$repo} = \@repo_files;
}



while(my($id, $data) = each $meta){
    next unless $data->{dev_milestone} =~ /live/i;
    my $repo = $data->{repo};
    $process{$repo}->($data, $files);
}


