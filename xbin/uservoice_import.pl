#!/usr/bin/env perl

$|=1;

use strict;
use warnings;

use FindBin;
use lib $FindBin::Dir . "/../lib"; 

use DDP;
use Text::CSV;
use DDGC;
use DateTime::Format::Strptime;
use Digest::MD5 qw( md5_hex );

my $types = DDGC::DB::Result::Idea::types;
delete $$types{0};
my %type = reverse %$types;
$type{substr($_,0,1)} = delete $type{$_} for keys %type;

# datetime parser
my $dt = DateTime::Format::Strptime->new(pattern => '%Y-%m-%d %H:%M');

my $ddgc = DDGC->new;

my $csv = Text::CSV->new({binary => 1});

my $import_user = $ddgc->find_user($ENV{DDGC_IMPORT_USERNAME} // 'import');

die "didnt found import user" unless $import_user;

sub parse_file {
	my ($filename, $callback) = @_;
	open my $fh, "<:encoding(utf8)", "$filename" or die "$filename: $!";

	my @header;

	while (my $row = $csv->getline($fh)) {
		unless (@header) {
			@header = @{$row};
			next;
		}
		my %hash;
		$hash{$header[$_]} = $row->[$_] for 0..$#header;
		$callback->(%hash);
	}
	close $fh;
	print "\n";
}

my $sug_count;
my %sug_id;
my $total_comments;

sub suggestion {
	my (%sug) = @_;
	$sug{$_} = $dt->parse_datetime($sug{$_}) for ('Created At', 'Updated At', 'Response Created At');

	$sug_count++;
	$total_comments += $sug{Comments};
	print "\rSuggestions: $sug_count";

	$sug{Category} = substr($sug{Category}, 0, 1);
	my $idea = $import_user->create_related('ideas',{
			title => $sug{Title},
			content => $sug{Description},
			type => $type{$sug{Category}} // 0,
			created => $sug{'Created At'},
			updated => $sug{'Updated At'},
			old_vote_count => $sug{Votes},
			old_url => "https://duckduckhack.uservoice.com/forums/$sug{'Forum ID'}/suggestions/$sug{Id}",
			data => {
				$sug{'User Email'} ? (uservoice_email => $sug{'User Email'}) : (),
				$sug{'User Name'} ? (uservoice_user => $sug{'User Name'}) : (),
				$sug{'User Email'} ? (uservoice_claim => md5_hex(int(rand(1_000_000_000)))) : (),
				import => 'UserVoice',
				import_user => $sug{'User Name'} ? $sug{'User Name'} : 'no name',
				___uservoice_import___ => 1,
			},
		});
	$sug_id{$sug{Id}} = $idea->id;
}

my $comment_count;

my @missed;

sub comment {
	my (%comment) = @_;
	$comment_count++;
	print "\rComments: $comment_count\t/ $total_comments";
	if (defined $sug_id{$comment{'Suggestion ID'}}) {
		$ddgc->add_comment(
			'DDGC::DB::Result::Idea',
			$sug_id{ $comment{'Suggestion ID'} },
			$import_user,
			$comment{Text},
			data => {
				$comment{'User Email'} ? (uservoice_email => $comment{'User Email'}) : (),
				$comment{'User Name'} ? (uservoice_user => $comment{'User Name'}) : (),
				$comment{'User Email'} ? (uservoice_claim => md5_hex(int(rand(1_000_000_000)))) : (),
				import => 'UserVoice',
				import_user => $comment{'User Name'} ? $comment{'User Name'} : 'no name',
				___uservoice_import___ => 1,
			},
		);
	}
}

$ddgc->without_events(sub {
	parse_file 'suggestions_4458_export_20130901205259.csv' => \&suggestion;
	parse_file 'comments_4458_export_20130901205315.csv' => \&comment;
});
