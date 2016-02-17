package DDGC::DB::ResultSet::InstantAnswer::LastUpdated;
# ABSTRACT: Tracking IA updates across all relationships

use Moose;
extends 'DDGC::DB::Base::ResultSet';
use namespace::autoclean;

sub touch {
    my ( $self ) = @_;
    my $row = $self->search->one_row;
    my $token = $self->ddgc->uid;
    return eval { $row->update({ token => $token }) } if $row;
    $self->create({ token => $token });
}

1;
