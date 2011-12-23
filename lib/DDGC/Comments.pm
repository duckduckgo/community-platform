package DDGC::Comments;

use Moose;
use DDGC::Comments::Comment;

has ddgc => (
	isa => 'DDGC',
	is => 'ro',
	weak_ref => 1,
	required => 1,
);

has context => (
	isa => 'Str',
	is => 'ro',
	required => 1,
);

has context_id => (
	isa => 'Int',
	is => 'ro',
	required => 1,
);

has _all_comments => (
	isa => 'HashRef[DDGC::DB::Result::Comment]',
	is => 'ro',
	lazy_build => 1,
	clearer => 'refresh_comments',
);
sub _ac { shift->_all_comments }
sub all_comments { shift->_all_comments }

sub _build__all_comments {
	my ( $self ) = @_;
	$self->_clear_comments_structure;
	my @comments = $self->ddgc->rs('Comment')->search({
		context => $self->context,
		context_id => $self->context_id,
	},{
		order_by => [qw/ created /],
	})->all;
	my %ac;
	my %children;
	my @roots;
	for (@comments) {
		$ac{$_->id} = $_;
		if ($_->parent_id) {
			$children{$_->parent_id} = [] if !$children{$_->parent_id};
			push @{$children{$_->parent_id}}, $_->id;
		} else {
			push @roots, $_->id;
		}
	}
	$self->_comments_structure($self->_make_comments_structure(\%ac, \%children, @roots));
	p($self->_comments_structure);
	return \%ac;
}

sub _make_comments_structure {
	my ( $self, $ac, $children, @ids ) = @_;
	my @struct = map { DDGC::Comments::Comment->new({
		db => $ac->{$_},
		comments_context => $self,
		children => $children->{$_} ? $self->_make_comments_structure($ac, $children,@{$children->{$_}}) : [],
	}) } @ids;
	return \@struct;
}

has _comments_structure => (
	isa => 'ArrayRef',
	is => 'rw',
	clearer => '_clear_comments_structure',
);
sub comments_structure {
	my ( $self ) = @_;
	$self->all_comments;
	return $self->_comments_structure;
}

sub list { @{shift->comments_structure} }

sub count {
	my ( $self ) = @_;
	return scalar keys %{$self->_ac};
}

1;