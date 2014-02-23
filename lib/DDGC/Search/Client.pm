package DDGC::Search::Client;

use Moose;
use Dezi::Doc;
use DDGC::Config;
use JSON 'encode_json';

use MooseX::NonMoose;
extends 'Dezi::Client';

sub FOREIGNBUILDARGS {
    my $class = shift;
    my %args  = @_;

    my $server = $args{ddgc}->config->dezi_uri . '/' . $args{type} . '/';

    return (server => $server, search => 'search', index => 'index');
};

has type => (
    is => 'ro',
    required => 1,
);

has ddgc => (
    is => 'ro',
    required => 1,
    weak_ref => 1,
);

around index => sub {
    my ($orig, $self) = (shift, shift);
    return $self->$orig(@_) if ref $_[0] eq 'Dezi::Doc';

    my %args = @_;
    my $is_markup = defined $args{is_markup} ? delete $args{is_markup} : 0;
    my $uri = delete $args{uri};

    if ($is_markup && defined $args{body}) {
        $args{body} = $self->ddgc->markup->plain($args{body});
    }

    my $doc = encode_json({
        mtime => time,
        content_type => 'application/json',
        %args,
    });

    return $self->$orig(
        \$doc,
        $uri,
        'application/json',
    );
};


__PACKAGE__->meta->make_immutable;
1;

__DATA__

=pod

=encoding UTF-8

=head1 NAME

DDGC::Search - A Dezi-based search/indexing abstraction

=head1 SYNOPSIS

    my $search = DDGC::Search::Client->new(
        ddgc => $ddgc,
        type => 'foo',
    );

    $search->index(
        title   => "I am a document",
        body => "... and this is my body.",
    );

    my $response = $search->search( q => "document" );

B<$response> is a L<Dezi::Response>.

=head1 DESCRIPTION

This is the client part of DDGC's search engine abstraction layer. It inherits L<Dezi::Client>.

=head1 OVERRIDDEN METHODS

=over 4

=item B<index(%data)>

This method takes a hash of options which will be encoded to JSON and passed to L<Dezi::Client>.

=back

=cut
