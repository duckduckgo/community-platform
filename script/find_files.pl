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
    my ($data, $files, $share) = @_;
    my $repo = $data->{repo};
    my $zci = "zeroclickinfo-$repo";

    warn "pm $data->{perl_module} path $share";

    #find share files
    my @matches;
    push(@matches, File::Find::Rule->file->in("/usr/local/ddh/$zci/$share/")) if $share;
    
    push(@matches, File::Find::Rule
        ->name('*.t')
        ->grep( qr/$data->{perl_module}/)
        ->in("/usr/local/ddh/$zci/t/")
    );
    
    #find lib files
    $repo = ucfirst $repo;
    push(@matches, grep { $_ =~ /lib\/DDG\/$repo\/$data->{name}\./} @{$files->{$zci}} );

    my $result;

    $result->{$data->{id}} = \@matches;

    warn Dumper $result;
}

sub goodies_process {
    my ($data, $files, $share) = @_;
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

#    warn Dumper $result;
}


my $files;
my $module_to_share;
foreach my $repo (@repos){
    # file all files in the repo
    my @repo_files = $rule->relative->in("/usr/local/ddh/$repo");

    my @repo_share_dirs = File::Find::Rule->relative->directory->in("/usr/local/ddh/$repo/share");

    # map perl module to share dir to reliably look up share files later
    foreach my $dir (@repo_share_dirs){
        my @parts = split '/', $dir;
        next if scalar @parts == 1;

        map{ 
            s/_([a-z0-9])/\u$1/g;
            s/^([a-z0-9])/\u$1/;
        }@parts;

        my $pm = join('::', @parts);
        $pm = "DDG::$pm";

        # we have a potential module from share dir path but the actual
        # module names are not well standardized. case insensitive match 
        # on our metadata should find the right one.
        foreach my $id (keys $meta){
            my $module = $meta->{$id}->{perl_module};
            if($module =~ /$pm/i){
                $pm = $module;
            }
        }
        $module_to_share->{$pm} = "share/$dir";
    }
    $files->{$repo} = \@repo_files;
}

warn Dumper \$module_to_share;

while(my($id, $data) = each $meta){
    next unless $data->{dev_milestone} =~ /live/i;
    my $repo = $data->{repo};
    my $pm = $data->{perl_module};

    $process{$repo}->($data, $files, $module_to_share->{$pm});
}


