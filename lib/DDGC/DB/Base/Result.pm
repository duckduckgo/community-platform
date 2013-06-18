package DDGC::DB::Base::Result;

use Moose;
use MooseX::NonMoose;
extends 'DBIx::Class::Core';
use namespace::autoclean;

__PACKAGE__->load_components(qw/
    TimeStamp
    InflateColumn::DateTime
    InflateColumn::Serializer
    EncodedColumn
  /);

sub default_result_namespace { 'DDGC::DB::Result' }

use overload '""' => sub {
	my $self = shift;
	return (ref $self).' #'.$self->id;
}, fallback => 1;

no Moose;
__PACKAGE__->meta->make_immutable;
