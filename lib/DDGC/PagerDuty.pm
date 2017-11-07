package DDGC::PagerDuty;

use Moo;

use JSON::MaybeXS;
use HTTP::Request::Common;

has ddgc => ( is => 'ro' );

has json => ( is => 'lazy' );
sub _build_json { JSON::MaybeXS->new->utf8 }

has api_key => ( is => 'lazy' );
sub _build_api_key { $_[0]->ddgc->config->pagerduty_api_key }

sub on_call {
    my ( $self ) = @_;
    my $req = GET 'https://duckduckgo.pagerduty.com/api/v1/users/on_call';
    $req->authorization('Token token=' . $self->api_key);
    $req->content_type('application/json');

    my $res = $self->ddgc->http->request($req);
    if ($res->is_success) {
        my ( $on_call ) = grep {
            grep {
                $_->{escalation_policy}->{name} eq 'ops on-call' && $_->{level} == 1
            } @{ $_->{on_call} }
        } @{ $self->json->decode( $res->decoded_content )->{users} };

        return $on_call->{email};
    }
    return 0;
}

1;
