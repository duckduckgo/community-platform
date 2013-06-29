#!/usr/bin/env perl

$|=1;

use FindBin;
use lib $FindBin::Dir . "/../lib"; 

use strict;
use warnings;

use DDGC;

use Moose;
use YAML qw( LoadFile );
use IO::All;
use Path::Class;
use File::ShareDir::ProjectDistDir;
use DateTime::Format::Flexible;

my $dirname = dir(file(__FILE__)->dir,'..','share','blog')->stringify;
my $dir = io($dirname);
my @posts;
for (keys %$dir) {
	if ($_ =~ s/\.yml$// and not $_ =~ /^\./) {
		my $post = {
			%{LoadFile(file($dirname,$_.'.yml')->stringify)},
			content => scalar io(file($dirname,$_.'.html')->stringify)->slurp,
			uri => $_,
		};
		$post->{date} = DateTime::Format::Flexible->parse_datetime($post->{date});
		push @posts, $post;
	}
}
@posts = sort { $a->{date} <=> $b->{date} } @posts;

my $ddgc = DDGC->new;

for my $post (@posts) {
	my $user = $ddgc->find_user($post->{author});
	$user->create_related('user_blogs',{
		created => $post->{date},
		updated => $post->{date},
		content => $post->{content},
		company_blog => 1,
		raw_html => 1,
		topics => $post->{topics},
		uri => $post->{uri},
		title => $post->{title},
		live => 1,
		teaser => $post->{content},
	});
}

