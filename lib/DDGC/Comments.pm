package DDGC::Comments;

use Moose;

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
	$self->_clear_structure;
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
	my @struct = $self->_make_structure(\%ac, \%children, @roots);
	$self->_structure(\@struct);
	return \%ac;
}

sub _make_structure {
	my ( $self, $ac, $children, @ids ) = @_;
	my @struct;
	for (@ids) {
		push @struct, $ac->{$_};
		if ($children->{$_}) {
			push @struct, $self->_make_structure($ac, $children,@{$children->{$_}});
		}
	}
	return \@struct;
}

has _structure => (
	isa => 'ArrayRef',
	is => 'rw',
	clearer => '_clear_structure',
);
sub structure {
	my ( $self ) = @_;
	$self->all_comments;
	return $self->_structure;
}

sub count {
	my ( $self ) = @_;
	return scalar keys %{$self->_ac};
}

1;