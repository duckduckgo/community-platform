#!/usr/bin/env perl

$|=1;

use strict;
use warnings;

use FindBin;
use lib $FindBin::Dir . "/../lib"; 

use URI;
use Web::Scraper;
use DDP;
use DDGC;
use DateTime::Format::Strptime;
use Parallel::ForkManager;

# Stream flushing for progress
use IO::Handle; STDOUT->autoflush(1);

# datetime parser
my $dt = DateTime::Format::Strptime->new(pattern => '%d-%b-%Y %I:%M %p');

my $ddgc = DDGC->new;

my %user_map = $ENV{DDGC_IMPORT_USERNAME} ? () : (
	yegg13       => 'yegg',
	bizarre      => 'crazedpsyc',
	gettygermany => 'getty',
	zacbrannigan => 'zac',
);

my $import_user = $ddgc->find_user($ENV{DDGC_IMPORT_USERNAME} // 'import');


my $list_page = scraper {
	process "li.ndsingleList", "topics[]" => scraper {
		process 'a[purpose="postTitle"]',
			link => '@href',
			title => 'TEXT';
	};
	
	process "li.navBtnEnabled:nth-child(2)", next => '@onclick';
};

my $topic_page = scraper {
	process "div.postContainer, div.spsingleReplyContainer", 'posts[]' => scraper {
		process 'div.dimText em.ndboldem', datetime => '@title';
		process 'div.responseHeight', content => 'HTML';
		process 'div.sppostAuthor span a', author => '@authorname';
		process '.', class => '@class';
	};
};



my $next_page = "http://duck.co";
my $topic_count = 0;

sub get_user {
	my ($username) = @_;

	return defined $user_map{$username}
		? $ddgc->find_user($user_map{$username})
		: $import_user;
}

# Let's... get sticky
my $stickies = $list_page->scrape(URI->new('https://duck.co/filter/sticky'))->{topics};

my $pm = Parallel::ForkManager->new(25);

my $no = 1;

while (1) {

	my $page = $list_page->scrape(URI->new($next_page));

	if ($pm->start) {

		print "[".$no."]"; $no++;

		if (defined $page->{next}) {
			$page->{next} =~ /='(.+)'$/; # damn thing is document.location.href='...'
			$next_page = $1;
		} else {
			$pm->wait_all_children;
			exit;
		}

	} else {

		for my $li (@{$page->{topics}}) {

			eval {

				my $topic = $topic_page->scrape(URI->new($li->{link}));

				#print "\rTopics: ", ++$topic_count, " ($topic->{posts}->[-1]->{datetime})";

				my $user = get_user $topic->{posts}->[1]->{author};

				my @comments = (

						map { [
							get_user($_->{author}),
							$_->{content},
							$dt->parse_datetime($_->{datetime}),
							$_->{author},
							$_->{class} ? ($_->{class} =~ /\bthread\b/) : (), # If this is a sub-comment
						] if $_->{content} } (@{$topic->{posts}}[2..$#{$topic->{posts}}])

				) if @{$topic->{posts}} > 2;

				my $datetime = $dt->parse_datetime($topic->{posts}->[1]->{datetime});

				my $sticky = 0;

				grep { $sticky = 1 if $_->{link} eq $li->{link} } @$stickies;

				my $thread = $ddgc->forum->add_thread(
					$user,
					$topic->{posts}->[1]->{content},
					title => $li->{title},
					data => {
						$user->id == $import_user->id
							? (
								import => "Old Forum",
								import_user => $topic->{posts}->[1]->{author},
							) : (),
						___duckco_import___ => 1,
					},
					created => $datetime, updated => $datetime,
					sticky => $sticky,
					old_url => $li->{link},
					comment_params => {
						is_html => 1,
						readonly => 1,
						data => {
							$user->id == $import_user->id
								? (
									import => "Old Forum",
									import_user => $topic->{posts}->[1]->{author},
								) : (),
							___duckco_import___ => 1,
						},
					},
				);
				print "#";

				my $last_comment;
				for my $comment (@comments) {
					my $next = 0;
					$next = 1 unless ref $comment eq 'ARRAY';
					$next = 1 if $next == 0 && defined $comment->[4] && !defined $last_comment;
					if ($next) {
						print "!";
					} else {
						my $c = $ddgc->add_comment(
							'DDGC::DB::Result::Comment',
							defined $comment->[4] ? $last_comment->id : $thread->comment->id,
							$comment->[0], # user
							$comment->[1], # content
							created => $comment->[2],
							updated => $comment->[2],
							data => {
								is_html => 1,
								readonly => 1,
								$comment->[0]->id == $import_user->id
									? (
										import => "Old Forum",
										import_user => $comment->[3],
									) : (),
								___duckco_import___ => 1,
							},
						);
						print ".";
						$last_comment = $c unless defined $comment->[4];
					}
				}

			};

			print "\n".$@."\n" if $@;

		}

		$pm->finish;

	}

}
