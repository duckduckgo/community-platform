package DDGC::DB::ResultSet::GitHub::Pull;
# ABSTRACT: Resultset class for GitHub Pulls

use Moose;
extends 'DDGC::DB::Base::ResultSet';
use namespace::autoclean;

sub most_recent {
    my ($self) = @_;
    return $self->search(
        {},
        {
            rows => 1,
            order_by => { -desc => 'updated_at' },
        }
    )->first;
}

no Moose;
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );
