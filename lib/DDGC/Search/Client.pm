package DDGC::Search::Client;

use Moose;
use Dezi::Doc;
use DDGC::Config;
use HTML::Strip;
use Encode 'decode';
use JSON qw(encode_json decode_json);
use URI::Query;
use HTML::Entities;

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

has stripper => (
    is => 'ro',
    lazy_build => 1,
);

sub _build_stripper {
    HTML::Strip->new
}

sub suggest {
    my ($self, $q, %args) = @_;
    my $search_uri = $self->{search_uri};
    %args = (
        t => 'JSON',
        p => 4,                # maximum of 4 results
        h => 0,                # do not highlight matches
        x => [qw(swishtitle)], # only return the title
        b => 'OR',             # put an OR between terms instead of AND
        q => $q,
        %args,
    );
    my $query = URI::Query->new(%args);
    my $resp = $self->{ua}->get($search_uri . '?' . $query);
    return eval {
        my $results = decode_json($resp->decoded_content)->{results};
        for (@{$results}) {
            $_->{summary} = (split '<br>', decode_entities($_->{summary}))[0];
        }
        return $results;
    } // [];
    return [];
}

sub resultset {
    my ($self, $c, $query, $rs, %args) = @_;
    die 'resultset() needs $c, $query, $rs.' unless defined $c || defined $query || defined $rs;

    %args = () unless %args;
    $args{q} = $query;
    my $result = $self->search(%args);
    unless ($result) {
        my $err;
        if($self->last_response->code == 500 && $self->last_response->decoded_content =~ qr/^\{.+\}$/) { 
            $err = decode_json($self->last_response->decoded_content)->{error} . 
                '<br/>This seems like a problem with your query. If you disagree, please <a href="mailto:ddgc@duckduckgo.com">contact us</a>.'
            ;
        } else {
            $err = $self->last_response->message . ($c->debug ?
            '<br/>Have you run `script/dezi_server.pl &`?' :
            '<br/>Please contact <a href="mailto:ddgc@duckduckgo.com">ddgc@duckduckgo.com</a> if the issue persists.');
        }
        $c->stash->{error} = $err;
    }

    my %results;
    my $resultset;
    my $order_by;
    # This will become:
    # CASE id
    #   WHEN x THEN i
    #   ELSE last_i+1
    # END
    # With an additional when line for each x (id) in results.
    # It is used as the ORDER BY clause to retain the search
    # engine's ranking.
    my $case = "CASE id";

    if ($result && $result->total) {
        my @ids;
        push @ids, $_->get_field('id')->[0] for @{$result->results};

        $results{$_->get_field('id')->[0]} = $_ for @{$result->results};
        my $i;

        $case .= ' WHEN '.$_.' THEN '.++$i for @ids;
        $case .= ' ELSE '.++$i.' END, id';

        $order_by = \do { $case };
        
        $resultset = $rs->search_rs({id => \@ids},
            { order_by => {
                  -desc => $order_by
                }
        });

        if (my $ducky = $c->req->param('ducky')) {
            my $first = $resultset->first;
            if (defined $first && $first->can('u')) {
                $c->response->redirect($c->chained_uri(@{$first->u}));
                return $c->detach;
            }
        }
    }

    return \%results, $resultset, $order_by;
}

sub rs { shift->resultset(@_) }

around index => sub {
    my ($orig, $self) = (shift, shift);
    return $self->$orig(@_) if ref $_[0] eq 'Dezi::Doc';

    my %args = @_;
    my $is_markup = defined $args{is_markup} ? delete $args{is_markup} : 0;
    my $is_html = defined $args{is_html} ? delete $args{is_html} : 0;
    my $uri = delete $args{uri};

    if ($is_markup && defined $args{body}) {
        $args{body} = $self->ddgc->markup->plain($args{body});
    }
    elsif ($is_html && defined $args{body}) {
        $args{body} = $self->stripper->parse($args{body});
        $self->stripper->eof;
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

around search => sub {
    my ($orig, $self, %params) = @_;
    die "->search needs a q parameter." unless defined $params{q};

    $params{q} =~ s/(?:^|(?<=\s))!(\S+)/"!$1"/g;
    print "\n\nQuery: $params{q}\n\n";

    my $result = $self->$orig(%params);

    if ($result && $result->results) {
        for my $doc (@{$result->results}) {
            $doc->{$_} = decode('UTF-8', $doc->{$_}) for qw(title summary);
        }
    }

    return $result;
};


__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: A Dezi-based search/indexing abstraction

__DATA__

=pod

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

=head1 METHODS

=over 4

=item B<index>

B<Arguments:> %data

B<Return Value:> L<HTTP::Response>

This method takes a hash of data which will be encoded to JSON and passed to L<Dezi::Client>.

=item B<search>

B<Arguments:> %query

B<Return Value:> L<Dezi::Response> or false

Not overridden -- see L<Dezi::Client>.

=item B<resultset>

B<Arguments:> $c, $query, $rs, %params?

B<Return Value:> {id=>L<Dezi::Doc>} from Dezi, ordered $resultset, $order_by

Builds a new ordered resultset by searching $rs for the IDs returned by Dezi
for $query. %params are passed along to Dezi::Client->search. This also
handles a C<ducky> parameter, and attempts to do an "I'm feeling ducky" search
if it is present and the ResultSource from $rs C<can('u')>.

=item B<suggest>

B<Arguments:> $query, %params?

B<Return Value:> ArrayRef of HashRefs

This is really just a strictly limited version of B<search>. It passes some
special parameters to Dezi to get a tiny, fast response suitable for auto-
suggestions. This method does NOT use Dezi::Client->search, it returns decoded
JSON directly from the Dezi server.

=back

=cut
