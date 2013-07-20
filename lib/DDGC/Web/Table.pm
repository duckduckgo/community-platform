package DDGC::Web::Table;
# ABSTRACT: Class with helping functions for managing a table inside a session

use Moose;
use Digest::MD5 qw( md5_hex );
use List::MoreUtils qw( natatime );

has c => (
	is => 'ro',
	isa => 'DDGC::Web',
	required => 1,
);

has u => (
	is => 'ro',
	isa => 'ArrayRef',
	required => 1,
);
sub u_page {
	my ( $self, $page ) = @_;
	my @u = @{$self->u};
	if (ref $u[-1] eq 'HASH') {
		$u[-1]->{$self->key_page} = $page;
	} else {
		push @u, { $self->key_page, $page };
	}
	return \@u;
}

sub u_pagesize {
	my ( $self, $pagesize ) = @_;
	my @u = @{$self->u};
	if (ref $u[-1] eq 'HASH') {
		$u[-1]->{$self->key_pagesize} = $pagesize;
	} else {
		push @u, { $self->key_pagesize, $pagesize };
	}
	return \@u;
}

has resultset => (
	is => 'ro',
	isa => 'DBIx::Class::ResultSet',
	required => 1,
);
sub resultset_search { shift->resultset->search({}) }

has fields_keys => (
	is => 'ro',
	isa => 'ArrayRef[Str|CodeRef]',
	lazy => 1,
	default => sub {
		my @keys;
		my $it = natatime 2, @{shift->fields};
		while (my @field_label = $it->()) {
			push @keys, $field_label[0];
		}
		return \@keys;
	},
);

sub row_values {
	my ( $self, $row ) = @_;
	my @values;
	for my $key (@{$self->fields_keys}) {
		if (ref $key eq 'CODE') {
			for ($row) { push @values, $_->($self, $self->c) }
		} else {
			push @values, $row->get_column($key);
		}
	}
	return \@values;
}

has fields_labels => (
	is => 'ro',
	isa => 'ArrayRef[Str]',
	lazy => 1,
	default => sub {
		my @labels;
		my $it = natatime 2, @{shift->fields};
		while (my @field_label = $it->()) {
			push @labels, $field_label[1];
		}
		return \@labels;
	},
);

has fields => (
	is => 'ro',
	isa => 'ArrayRef[Str|CodeRef]',
	required => 1,
);

has page => (
	is => 'ro',
	isa => 'Int',
	lazy => 1,
	default => sub {
		my ( $self ) = @_;
		my $page = $self->c->req->param($self->key_page)
			|| $self->c->session->{$self->key_page}
			|| 1;
		$self->c->session->{$self->key_page} = $page;
		return $self->c->session->{$self->key_page};
	},
);

has default_pagesize => (
	is => 'ro',
	isa => 'Int',
	lazy => 1,
	default => sub { 20 },
);

has pagesizes => (
	is => 'ro',
	isa => 'ArrayRef[Int]',
	lazy => 1,
	default => sub {[qw(
		5
		10
		20
		50
	)]},
);

has pagesize => (
	is => 'ro',
	isa => 'Int',
	lazy => 1,
	default => sub {
		my ( $self ) = @_;
		my $pagesize = $self->c->req->param($self->key_pagesize)
			|| $self->c->session->{$self->key_pagesize}
			|| $self->default_pagesize;
		$self->c->session->{$self->key_pagesize} = $pagesize;
		return $self->c->session->{$self->key_pagesize};
	},
);

has paged_rs => (
	is => 'ro',
	isa => 'DBIx::Class::ResultSet',
	lazy => 1,
	default => sub {
		my ( $self ) = @_;
		$self->resultset->search({},{
			page => $self->page,
			rows => $self->pagesize,
		});
	},
);

has key_page => (
	is => 'ro',
	isa => 'Str',
	lazy => 1,
	default => sub {
		my ( $self ) = @_;
		$self->key.'_page_'.$self->pagesize;
	},
);

has key_pagesize => (
	is => 'ro',
	isa => 'Str',
	lazy => 1,
	default => sub { 'tablepagesize_'.md5_hex(shift->id_pagesize) },
);

has key => (
	is => 'ro',
	isa => 'Str',
	lazy => 1,
	default => sub { 'table_'.md5_hex(shift->id) },
);

has id_pagesize => (
	is => 'ro',
	isa => 'Str',
	lazy => 1,
	default => sub {
		my ( $self ) = @_;
		my @id_pagesize;
		for my $part_u (@{$self->u}) {
			if (ref $part_u eq '') {
				push @id_pagesize, $part_u;
			} elsif (ref $part_u eq 'HASH') {
				for (sort { $a cmp $b } keys %{$part_u}) {
					push @id_pagesize, $_;
					push @id_pagesize, $part_u->{$_};
				}
			}
		}
		return join('|',@id_pagesize);
	},
);

has id => (
	is => 'ro',
	isa => 'Str',
	lazy => 1,
	default => sub {
		my ( $self ) = @_;
		my $rs_as_query = $self->resultset_search->as_query;
		my $arrayref_rs_as_query = ${$rs_as_query};
		my @as_query = @{$arrayref_rs_as_query};
		my $id = "";
		for my $qp (@as_query) {
			if (ref $qp eq 'HASH') {
				for (sort { $a cmp $b } keys %{$qp}) {
					$id .= $_;
					$id .= $qp->{$_};
				}
			} elsif (ref $qp eq '') {
				$id .= "$qp";
			} else {
				die __PACKAGE__." cant use a specific part of as_query for this resultset (it is a ".(ref $qp).")";
			}
		}
		return $id;
	},
);

has pager_pages => (
	is => 'ro',
	isa => 'ArrayRef[Int|Undef]',
	lazy => 1,
	default => sub {
		my ( $self ) = @_;
		my @p;
		for (1..$self->last_page) {
			if ($_ == $self->first_page ||
				( $_ >= $self->current_page - 4 &&
				  $_ <= $self->current_page + 4 )
				|| $_ == $self->last_page) {
				push @p, $_;
			} else {
				push @p, undef if defined $p[-1];
			}
		}
		return \@p;
	},
);

has data_page => (
	is => 'ro',
	isa => 'Data::Page',
	lazy => 1,
	default => sub { shift->paged_rs->pager },
	handles => [qw(
		total_entries
		entries_per_page
		current_page
		first_page
		last_page
		first
		last
		previous_page
		next_page
		splice
		skipped
	)],
	# change_entries_per_page - i think i dont want this
);

no Moose;
__PACKAGE__->meta->make_immutable;
