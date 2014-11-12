#!/usr/bin/env perl

use strict;
use FindBin;
use lib $FindBin::Dir . "/../lib";
use DDGC;
use DDGC::Web::Controller::InstantAnswer;
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
        my $updates = $ia->get_column('updates');
        $updates = from_json($updates);
        if(@{$updates}){
            print qq(\t$name\n);
        }
    }
}

sub commit_edits {

    my $edits = DDGC::Web::Controller::InstantAnswer::get_edits($d, ucfirst $argv);
    my $results = $d->rs('InstantAnswer')->search({name => ucfirst $argv});
    my $ia = $results->first();
    my $edits_to_remove = 0;

        my $ia_name = $argv;
        print "IA: $ia_name\n";

        foreach my $edit (@{ $edits }){
            my $time  = '';
            my $field = '';
            my $value = '';
            my $input = '';

            #get time for the edit
            foreach $time (keys %{$edit}) {

                # each field in the edit
                foreach $field (keys %{ $edit->{$time} } ){
                    $value = $edit->{$time}->{$field};
                    my $orig_val = $ia->get_column($field);

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
                        DDGC::Web::Controller::InstantAnswer::commit_edit($ia, $field, $value);
                    }
                }
            }
            $edits_to_remove++;
        }

        # remove edits so we have an empty array when finished
        for(my $i; $i < $edits_to_remove; $i++){
            shift @{$edits} ;
        }

        $ia->update({'updates' => $edits});

}

sub check_input {
    my $input = shift;
    if($input eq "y" or $input eq "n"){
        return 0;
    }
    return 1;
}
