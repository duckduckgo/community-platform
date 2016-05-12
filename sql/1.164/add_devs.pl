#!/usr/bin/env perl

use strict;
use FindBin;
use lib $FindBin::Dir . "/../../lib";
use DDGC;
use Data::Dumper;
use JSON;

my $d = DDGC->new;

my @gh_prs = $d->rs('GitHub::Issue')->search({
                    'me.isa_pull_request' => 1
                },
                {
                    columns => [ qw/ number / ],
                    result_class => 'DBIx::Class::ResultClass::HashRefInflator'
                });

for my $pr (@gh_prs) {
    if (my $ia_issue = $d->rs('InstantAnswer::Issues')->search({ issue_id => $pr->{number} })->one_row ) {

        if ( ( my $ia = $d->rs('InstantAnswer')->find({ meta_id => $ia_issue->{instant_answer_id} }) ) && ( $ia_issue->{status} eq 'merged' ) ) {

            warn "IA Page: " . $ia->meta_id;
            
            unless ($ia->{developer} && ( $ia->{developer} =~ /$ia_issue->{author}/g ) ) {
               
                my $data = $ia->{developer} ? from_json($ia->{developer}) : [];
                
                warn "JSON dev column before update: " . $ia->{developer};

                my $new_dev = {
                    name => $ia_issue->{author},
                    type => 'github',
                    url => 'https://github.com/' . $ia_issue->{author}
                };

                push(@{ $data }, $new_dev);
                $data = to_json($data);

                warn "JSON dev column updated: " . $data;
                $ia->update({ developer => $data });
            }
        }
    }
}
