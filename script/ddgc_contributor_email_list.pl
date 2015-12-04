#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
use lib $FindBin::Dir . "/../lib";
use JSON;
use Data::Dumper;
use Net::GitHub::V3;
use Time::Local;
use LWP::Simple;
use Try::Tiny;
use Spreadsheet::ParseExcel;
use Spreadsheet::WriteExcel;

my $token = $ENV{DDGC_GITHUB_TOKEN} || $ENV{DDG_GITHUB_BASIC_OAUTH_TOKEN};
my $gh = Net::GitHub::V3->new(access_token => $token);

my $ia_json = get 'https://duck.co/ia/repo/all/json';
my $ia_data = from_json($ia_json);

my $devs;
my $from_excel;

my $reader = Spreadsheet::ParseExcel->new();
my $workbook = $reader->parse('/tmp2/ddg/forkers.xls');

for my $worksheet ($workbook->worksheets() ){
    next unless $worksheet->get_name eq 'User_lookup';
    
    my ( $row_min, $row_max ) = $worksheet->row_range();
    my ( $col_min, $col_max ) = $worksheet->col_range();
             
    for my $row ( $row_min .. $row_max ) {
        my $user = $worksheet->get_cell( $row, 0 );
        my $email = $worksheet->get_cell( $row, 2 );
        next unless ($user && $email);

        $from_excel->{ lc $user->value} = $email->value;
    }
}

while( my($id, $data) = each $ia_data){
    #get devs email
    my @dev_names;
    if(ref $data->{developer} eq 'ARRAY'){

        foreach my $dev (@{$data->{developer}}){
            my $name;

            if($dev->{name} =~ /ddg|duckduckgo/i){
                $name = "No Developer";
            }
            elsif($dev->{type} eq 'legacy'){
                $name = $dev->{name};
            }
            else{
                ($name) = $dev->{url} =~ /https?:\/\/(?:duck\.co|github\.com)(?:\/user)?\/(.+)/i;
                $name =~ s/\/$// if $name;
            }
            
            next unless $name;

            if(!exists $devs->{$name}){
                $devs->{$name} = {};
                $devs->{$name}->{ias} = [];
            }
            
            push($devs->{$name}->{ias}, $id);

            if($dev->{type} eq 'legacy'){
                $devs->{$name}->{email} = $dev->{url};
            }
        }

    }
}

foreach my $dev (keys $devs){
    my $email;
    try{
        my $user = $gh->user->show($dev);
        $email = $user->{email} || "No Email";
    }catch{
    };

    if(!$email){
        $email = $from_excel->{ lc $dev} || "No Email";
    }
    $devs->{$dev}->{email} = $email unless defined $devs->{$dev}->{email};
}

my $new_workbook = Spreadsheet::WriteExcel->new('/tmp2/ddg/emails.xls');
my $worksheet = $new_workbook->add_worksheet('IAs_with_devs');

my $row;
while( my ($name, $data) = each $devs){
    next if $name eq 'No Developer';
    $worksheet->write($row, 0, $name);
    $worksheet->write($row, 1, $data->{email});
    $worksheet->write($row, 2, join ',', @{$data->{ias}});
    $row++;
}

$row = 0;
$worksheet = $new_workbook->add_worksheet('IAs_without_devs');
foreach my $ia (@{$devs->{'No Developer'}->{ias}}){
    $worksheet->write($row, 0, $ia);
    $row++;
}
