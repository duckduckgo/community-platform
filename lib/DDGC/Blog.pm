package DDGC::Blog;
# ABSTRACT: 

use Moose;
use YAML qw( LoadFile );
use IO::All;
use DDGC::Blog::Post;
use Path::Class;

has posts_dir => (
	is => 'ro',
	isa => 'Str',
	required => 1,
);

has posts => (
	is => 'ro',
	isa => 'ArrayRef[DDGC::Blog::Post]',
	lazy_build => 1,
);

sub _build_posts {
	my ( $self ) = @_;
	my $dir = io(dir($self->posts_dir)->stringify);
	my @posts;
	for (keys %$dir) {
		if ($_ =~ s/\.yml$// and not $_ =~ /^\./) {
			push @posts,
				DDGC::Blog::Post->new(
					%{LoadFile(file($self->posts_dir,$_.'.yml')->stringify)},
					content_file => file($self->posts_dir,$_.'.html')->stringify,
					uri => $_,
				);
		}
	}
	@posts = sort { $b->date <=> $a->date } @posts;
	return \@posts;
}

has topics => (
	is => 'ro',
	isa => 'ArrayRef[Str]',
	lazy_build => 1,
);

sub _build_topics {
	my ( $self ) = @_;
	my %topics;
	for (@{$self->posts}) {
		for (@{$_->topics}) {
			$topics{$_} = 0 unless defined $topics{$_};
			$topics{$_}++;
		}
	}
	return [sort { $topics{$a} <=> $topics{$b} } keys %topics];
}

sub get_post {
	my ( $self, $uri ) = @_;
	my ( $post ) = grep { $_->uri eq $uri } @{$self->posts};
	return $post;
}

sub posts_by_day {
	my ( $self, $page, $pagesize, $filter ) = @_;
	my @all_posts = @{$self->posts};
	if ($filter) {
		@all_posts = $filter->(@all_posts);
	}
	my $max = scalar @all_posts;
	my $start = ($page-1)*$pagesize;
	my $end = ($page*$pagesize)-1;
	$end = $max-1 if $end > $max-1;
	my @posts = @all_posts[$start..$end];
	my %days;
	for (@posts) {
		my $day = $_->date->strftime('%d');
		my $month = $_->date->strftime('%m');
		my $id = $month.$day + 0;
		$days{$id} = [] unless defined $days{$id};
		push @{$days{$id}}, $_;
	}
	return [map { $days{$_} } sort { $b <=> $a } keys %days ];
}

sub topic_posts_by_day {
	my ( $self, $topic, $page, $pagesize, $filter ) = @_;
	return $self->posts_by_day($page, $pagesize, sub {
		grep { grep { lc(join('-',split(/\s+/,$_))) eq $topic } @{$_->topics} } @_
	});
}

1;
