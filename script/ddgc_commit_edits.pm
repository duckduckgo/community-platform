#!/usr/bin/env perl

use strict;
use FindBin;
use lib $FindBin::Dir . "/../lib";
use DDGC;
use Data::Dumper;
use JSON;

my $d = DDGC->new;


my $argv = $ARGV[0];

if($argv){
    commit_edits($argv);
}
else{
    list_ia_with_edits();
}


sub list_ia_with_edits {
    my $results = $d->rs('InstantAnswer')->search( {updates => { '!=', undef}});
    print "No staged edits\n" if $results == 0;
    print "The following IAs have staged edits\n" if $results != 0;
    while( my $ia = $results->next() ){
        my $name = $ia->get_column('name');
        print qq(\t$name\n);
    }
}

sub commit_edits {

    my $results = $d->rs('InstantAnswer')->search( {name => ucfirst $argv});

    if($results == 0){
        print "No IA named $argv\n";
        exit 0;
    }

    # each IA that has an update
    while( my $ia = $results->next() ){


        my $edits = $ia->get_column('updates');

        if(!$edits){
            print "No staged edits for $argv\n";
            exit 0;
        }

        $edits = from_json($edits);

        my $ia_name = $ia->get_column('name');
        print "IA: $ia_name\n";

        # each edit
        foreach my $edit (@{ $edits }){
            my $time  = '';
            my $field = '';
            my $value = '';
            my $input = '';

            # get time for the edit
            foreach $time (keys %{$edit}) {

                # each field in the edit
                foreach $field (keys %{ $edit->{$time} } ){
                    $value = $edit->{$time}->{$field};
                    my $orig_val = $ia->get_column($field);

                    # see if this field has changed
                    if($value eq $orig_val){
                        # warn "Skipping  unchanged field\n";
                    }
                    else{
                        print "Field: $field\n";
                        print "\tEdit: $edit->{$time}->{$field}\n";
                        print "\tOrig: $orig_val\n\n";

                        while(check_input($input)){
                            print "Accept Edit? [y/n]: ";
                            $input = <STDIN>;
                            chomp $input;
                        }
                        print "\n";

                        # update the data in the db
                        if($input eq "y" || $input eq "Y"){
                            print "updating field\n\n";
                            $ia->update({$field => $value});
                        }
                    }
                }
            }
        }
        $ia->update({updates => undef});
    }
}

sub check_input {
    my $input = shift;
    if($input eq "y" or $input eq "n"){
        return 0;
    }
    return 1;
}
