package DDGC::DB::ResultSet::InstantAnswer::Traffic;
# ABSTRACT: Resultset class for Instant Answer Topics

use Moose;
extends 'DDGC::DB::Base::ResultSet';
use namespace::autoclean;

sub get_array_by_pixel {
    my ($self, $type) = @_;
    my @counts = $self->get_column('count')->all;
    my @dates = $self->get_column('date')->all;
    my @int_counts;

    foreach my $count (@counts) {
        push(@int_counts, $count + 0);    
    }

    return {dates => \@dates, counts => \@int_counts};
 }

1;

