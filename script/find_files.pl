#!/usr/bin/env perl
# scan ddh repos and update files for each IA
package FindCodeLinks;
use strict;
use warnings;
use FindBin;
use lib $FindBin::Dir . "/../lib";
use JSON;
use Data::Dumper;
use File::Find::Rule;
use DDG::Meta::Data;
use IO::All;

my $rule = File::Find::Rule->new;
my $meta = DDG::Meta::Data->by_id;
my $results;

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

sub process {
    my ($data, $files, $share) = @_;
    my $repo = $data->{repo};
    my $zci = "zeroclickinfo-$repo";
    my @matches;

    # find share files
    if($share && $data->{perl_module} !~ /cheatsheet/i){
        push(@matches, File::Find::Rule->file->in("/usr/local/ddh/$zci/$share/"));
    }
    elsif($share){
        # file cheat sheet json files
        push(@matches, File::Find::Rule
            ->name('*.json')
            ->grep( qr/$data->{id}/)
            ->in("/usr/local/ddh/$zci/share/goodie/cheat_sheets")
        );

        # special case for cheat sheet controller
        push(@matches, File::Find::Rule
            ->file
            ->maxdepth(1)
            ->in("/usr/local/ddh/$zci/share/goodie/cheat_sheets/")
        ) if $data->{id} eq "cheat_sheets";
    }
    push(@matches, File::Find::Rule
        ->name('*.t')
        ->grep( qr/$data->{perl_module}/)
        ->in("/usr/local/ddh/$zci/t/")
    );
    
    #find lib files
    push(@matches, File::Find::Rule
            ->grep( qr/$data->{perl_module}/)
            ->in("/usr/local/ddh/$zci/lib")
        );

    if($repo =~ /fathead|longtail/){
        push(@matches, File::Find::Rule
            ->file
            ->in("/usr/local/ddh/$zci/share/$repo/$data->{id}/")
        );
    }

    @matches = clean_and_normalize(@matches);
    $results->{$data->{id}} = to_json(\@matches);
}

sub clean_and_normalize {
    my (@matches) = @_;
    my $skip_qr = qr/\.(?:png|svg|flf)$/;
    my @clean;
    
    foreach my $file (@matches){
        next if $file =~ $skip_qr;
        $file =~ s/\/usr\/local\/ddh\/zeroclickinfo-.+?\///;
        push (@clean, $file);
    }

    return @clean;
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

        s/_//g for @parts;

        my $pm = join('::', @parts);
        $pm = "DDG::$pm";

        # we have a potential module from share dir path but the actual
        # module names are not well standardized. case insensitive match 
        # on our metadata should find the right one.
        foreach my $id (keys $meta){
            my $module = $meta->{$id}->{perl_module};
            if(lc $module eq lc $pm){
                $pm = $module;
            }
        }
        $module_to_share->{$pm} = "share/$dir";
    }
    $files->{$repo} = \@repo_files;
}

while(my($id, $data) = each $meta){
    next unless $data->{dev_milestone} =~ /live/i;
    my $repo = $data->{repo};
    my $pm = $data->{perl_module};
    process($data, $files, $module_to_share->{$pm});
}

# write sql 
my $sql = "BEGIN;\n";
while(my($id, $files) = each $results){
    $sql = $sql . qq(update instant_answer set code = '$files' where meta_id = '$id';\n);
}

$sql = $sql . "COMMIT;";

$sql > io("files.sql");

