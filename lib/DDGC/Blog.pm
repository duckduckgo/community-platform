package DDGC::Blog;
# ABSTRACT: A blog of a user or the company blog

use Moose;
use YAML qw( LoadFile );
use IO::All;
use DDGC::Blog::Post;
use Path::Class;

has ddgc => (
	isa => 'DDGC',
	is => 'ro',
	required => 1,
	weak_ref => 1,
);

has resultset => (
	isa => 'DDGC::DB::ResultSet::User::Blog',
	is => 'ro',
	required => 1,
);

has posts => (
	is => 'ro',
	isa => 'ArrayRef[DDGC::DB::Result::User::Blog]',
	lazy_build => 1,
);

sub _build_posts {
	[shift->resultset->sorted->all]
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
	return $self->resultset->find({ uri => $uri });
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
