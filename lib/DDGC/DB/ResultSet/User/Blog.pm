package DDGC::DB::ResultSet::User::Blog;
# ABSTRACT: Resultset class for blog posts

use Moose;
extends 'DDGC::DB::Base::ResultSet';
use DateTime::Format::RSS;
use List::MoreUtils qw( uniq );
use JSON;
use DateTime;
use namespace::autoclean;

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
  return $self->order_by({ -desc => [ $self->me . 'fixed_date', $self->me . 'created' ] });
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

sub metadata {
  my $self = shift;
  my (@topics,$archives);
  for ($self->all) {
    push @topics, @{$_->topics||[]};
    my $created = $_->created;
    $archives->{$created->strftime('%Y-%m')} = $created;
  }
  return {
    topics => [ sort { lc($a) cmp lc($b) } uniq @topics ],
    archives => $archives,
  };
}

sub filter_by_date {
  my ( $self, $dt ) = @_;
  my ( $year, $month ) = split(/\-/, $dt);
  $dt = DateTime->new(year => $year, month => $month);
  my $dt_parser = $self->schema->storage->datetime_parser;
  return $self->search({
    ($self->me . 'created') => {
      -between => [
        $dt_parser->format_datetime($dt),
        $dt_parser->format_datetime(
          $dt->clone->add(months => 1)->subtract(days => 1)
        ),
      ],
    },
  });
}

sub util_json_string { JSON->new->allow_nonref(1)->encode(shift) }

sub filter_by_topic {
  my ( $self, $topic ) = @_;
  $topic = util_json_string($topic);
  return $self->search({
      $self->me . 'topics' => { like => sprintf('%%%s%%', $topic) }
  });
}

no Moose;
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );
