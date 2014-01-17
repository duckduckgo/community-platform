package DBIx::Class::InflateColumn::Serializer::AnyJSON;

use strict;
use warnings;
use JSON::MaybeXS;
use Carp;

my $json = JSON::MaybeXS->new->convert_blessed(1)->utf8(1);

sub get_freezer {
  my ($class, $column, $info, $args) = @_;
  if (defined $info->{'size'}){
    my $size = $info->{'size'};
    return sub {
      my $s = $json->encode(shift);
      croak "serialization too big" if (length($s) > $size);
      return $s;
    };
  } else {
    return sub {
      return $json->encode(shift);
    };
  }
}

sub get_unfreezer {
  return sub {
    return $json->decode(shift);
  };
}


1;