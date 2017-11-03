package DDGC::Asana;

use Moo;

use JSON::MaybeXS;
use HTTP::Request::Common;

has ddgc => ( is => 'ro' );

has json => ( is => 'lazy' );
sub _build_json { JSON::MaybeXS->new->utf8 }

has personal_access_token => ( is => 'lazy' );
sub _build_personal_access_token { $_[0]->ddgc->config->asana_personal_access_token }

has workspace_id => ( is => 'lazy' );
sub _build_workspace_id { $_[0]->ddgc->config->asana_workspace_id }

sub add_task {
    my ( $self, $title, $content, $extra ) = @_;
    $extra //= {};
    my $req = HTTP::Request->new(
        POST => 'https://app.asana.com/api/1.0/tasks'
    );
    $req->authorization('Bearer ' . $self->personal_access_token);
    $req->content_type('application/json');
    $req->content(
        $self->json->encode( { data =>
          {
            workspace => $self->workspace_id,
            name      => $title,
            notes     => $content,
            %{ $extra }
          }
        } )
    );

    my $res = $self->ddgc->http->request($req);
    if ($res->is_success) {
        return $self->json->decode( $res->decoded_content );
    }
    return 0;
}

1;
