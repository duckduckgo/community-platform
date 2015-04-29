package DDGC::Schema::Result;

use Carp;
use Moo;
extends 'DBIx::Class::Core';

__PACKAGE__->load_components(qw/
    InflateColumn::Serializer
    TimeStamp
/);

1;
