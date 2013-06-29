package DDGC::DB::ResultSet::User::Blog;

use Moose;
extends 'DBIx::Class::ResultSet';

sub create_via_form {
	my ( $self, $values ) = @_;
	return $self->create($self->values_via_form($values));
}

sub values_via_form {
	my ( undef, $values ) = @_;
	if ($values->{topics}) {
		$values->{topics} = [grep {
			length($_) > 0
		} map {
			s/^\s+//; s/\s+$//; s/\s+/ /g; $_;
		} split(',',$values->{topics})];
	}
	$values->{live} = $values->{live} ? 1 : 0;
	for (qw( raw_html company_blog )) {
		if (defined $values->{$_}) {
			$values->{$_} = $values->{$_} ? 1 : 0;
		}
	}
	return $values;
}

sub sorted {
	my ( $self ) = @_;
	$self->search({},{
		order_by => { -desc => 'me.updated' },
	});
}

sub live {
	my ( $self ) = @_;
	$self->search({
		live => 1,
	});
}

sub posts_by_day {
	my ( $self ) = @_;
	my @posts = $self->all;
	my %days;
	for (@posts) {
		my $day = $_->updated->strftime('%d');
		my $month = $_->updated->strftime('%m');
		my $id = $month.$day + 0;
		$days{$id} = [] unless defined $days{$id};
		push @{$days{$id}}, $_;
	}
	return [map { $days{$_} } sort { $b <=> $a } keys %days ];
}

1;
