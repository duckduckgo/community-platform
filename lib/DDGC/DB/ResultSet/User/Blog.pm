package DDGC::DB::ResultSet::User::Blog;
# ABSTRACT: Resultset class for blog posts

use Moose;
use namespace::autoclean;
use DateTime::Format::RSS;
use List::MoreUtils qw( uniq );

extends qw(
  DDGC::DB::Base::ResultSet
  DBIx::Class::Helper::ResultSet::Me
  DBIx::Class::Helper::ResultSet::Shortcut::OrderBy
);

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
	} else {
		$values->{topics} = undef;
	}
	$values->{live} = $values->{live} ? 1 : 0;
	if ($values->{fixed_date}) {
		$values->{fixed_date} = DateTime::Format::RSS->new->parse_datetime($values->{fixed_date});
	} else {
		$values->{fixed_date} = undef;
	}
	for (qw( raw_html company_blog )) {
		if (defined $values->{$_}) {
			$values->{$_} = $values->{$_} ? 1 : 0;
		}
	}
	return $values;
}

sub most_recent_updated {
  my $self = shift;
  return $self->order_by({ -desc => $self->me . 'updated' });
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
		my $day = $_->date->strftime('%d');
		my $month = $_->date->strftime('%m');
		my $id = $month.$day + 0;
		$days{$id} = [] unless defined $days{$id};
		push @{$days{$id}}, $_;
	}
	return [map { $days{$_} } sort { $b <=> $a } keys %days ];
}

sub company_blog {
  my ( $self, $user ) = @_;
  return $self->search({
    $self->me . 'company_blog' => 1,
    $user && $user->admin ? () : ( $self->me . 'live' => 1 ),
  });
}

sub topics {
  my $self = shift;
  my @all_posts = $self->all;
  my @topics;
  for (@all_posts) {
    if ($_->topics) {
      push @topics, @{$_->topics} if @{$_->topics};
    }
  }
  return [ sort { lc($a) cmp lc($b) } uniq @topics ];
}

no Moose;
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );
