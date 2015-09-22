package DDGC::DB::ResultSet::InstantAnswer;
# ABSTRACT: Resultset class for Instant Answer Pages

use Moose;
extends 'DDGC::DB::Base::ResultSet';
use namespace::autoclean;
use DateTime;
use DateTime::Format::Pg;

sub last_modified {
    my ( $self ) = @_;
    my $last_modified =  $self->search( {}, {
        columns => [
            { last_modified => { max => 'updated' } },
        ],
    } )->one_row->get_column('last_modified');

    return DateTime::Format::Pg->parse_datetime(
        $last_modified
    ) if $last_modified;

    return DateTime->new( year => 1970 );
}

1;
