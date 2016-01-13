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

    # to int and sum the two types
    for(my $i = 0; $i < scalar @counts-1; $i++) {
        my $total = $counts[$i] + $counts[$i+1];
        push(@int_counts, $total + 0); 
        $i++
    }

    my @combined_dates;
    # combine dates
    for(my $i = 0; $i < scalar @dates-1; $i++){
        push(@combined_dates, $dates[$i]);
        $i++;
    }

    return {dates => \@combined_dates, counts => \@int_counts};
 }

1;

