package DDGC::PagerDuty;

use Moo;

use JSON::MaybeXS;
use HTTP::Request::Common;

has ddgc => ( is => 'ro' );

has json => ( is => 'lazy' );
sub _build_json { JSON::MaybeXS->new->utf8 }

has api_key => ( is => 'lazy' );
sub _build_api_key { $_[0]->ddgc->config->pagerduty_api_key }

sub _build_req {
    my ( $self, $url ) = @_;
    my $req = GET $url;
    $req->header('Accept', 'application/vnd.pagerduty+json;version=2');
    $req->authorization('Token token=' . $self->api_key);
    $req->content_type('application/json');
    return $req;
}

sub on_call {
    my ( $self ) = @_;
    my $req = $self->_build_req('https://api.pagerduty.com/oncalls');
    my $res = $self->ddgc->http->request($req);
    if ($res->is_success) {
        my ( $on_call ) = grep {
            $_->{escalation_policy}->{summary} eq 'ops on-call' && $_->{escalation_level} == 1
        } @{ $self->json->decode( $res->decoded_content )->{oncalls} };
        $req = $self->_build_req('https://api.pagerduty.com/users/' . $on_call->{user}->{id});
        $res = $self->ddgc->http->request($req);
        if ($res->is_success) {
            return $self->json->decode( $res->decoded_content )->{user}->{email};
        }

    }
    return 0;
}

1;
