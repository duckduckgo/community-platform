use strict;
use warnings;
package DDGC::Util::Email;
# ABSTRACT: Send Xslate template email

use Text::Xslate;
use HTML::FormatText::WithLinks;
use Email::MIME;
use Email::Sender::Simple qw/ try_to_sendmail /;
use Email::Sender::Transport::SMTP::Persistent;
use Email::Simple;
use HTTP::Validate qw/ :keywords :validators /;

use Moo;

has plaintext_renderer => (
    is  => 'ro',
    lazy => 1,
    builder => '_build_plaintext_renderer',
);
sub _build_plaintext_renderer {
    HTML::FormatText::WithLinks->new(
        unique_links => 1,
    );
}

has xslate => (
    is => 'ro',
    lazy => 1,
    builder => '_build_xslate',
);
sub _build_xslate {
    Text::Xslate->new(
        path => 'views',
    );
}

has smtp_config => (
    is => 'ro',
);

has transport => (
    is => 'ro',
    lazy => 1,
    builder => '_build_transport',
);
sub _build_transport {
    my ( $self ) = @_;
    Email::Sender::Transport::SMTP::Persistent->new({
        $self->transport_config,
    });
}

has validator => (
    is => 'ro',
    lazy => 1,
    builder => '_build_validator',
);
sub _build_validator {
    my ( $self ) = @_;
    my $v = HTTP::Validate->new;

    $v->define_ruleset( 'send_parameters',
        {   mandatory => 'to',
            valid     => ANY_VALUE,
            errmsg    => 'To: address required',
        },
        {   mandatory => 'verified',
            valid     => POS_VALUE,
            errmsg    => 'Cannot send email without verification',
        },
        {   mandatory => 'from',
            valid     => ANY_VALUE,
            errmsg    => 'From: address required',
        },
        {   mandatory => 'subject',
            valid     => ANY_VALUE,
            errmsg    => 'Subject line required',
        },
        {   mandatory => 'content',
            valid     => ANY_VALUE,
            errmsg    => 'Email content required',
        },
        {   mandatory => 'template',
            valid     => ANY_VALUE,
            errmsg    => 'Template filename required',
        },
    );
}

sub send {
    my ( $self, $params ) = @_;
    my $v = $self->validator->check_params( 'send_parameters', $params );

    if ( scalar $v->errors ) {
        return +{
            ok => 0,
            errors => [
                $v->errors,
            ]
        }
    }

    my $body = $self->xslate( $params->{template}, $params->{content} );
    my $html_part = Email::MIME->create(
        attributes => {
            content_type => 'text/plain; charset="UTF-8"',
            content_transfer_encoding => '8bit',
        },
        body => $body,
    );

    my $plaintext_body = $self->plaintext_renderer( $body );
    my $plaintext_part = Email::MIME->create(
        attributes => {
            content_type => 'text/html; charset="UTF-8"',
            content_transfer_encoding => '8bit',
        },
        body => $plaintext_body,
    );

    my $header = [
        map { $_ => $params->{$_} } (qw/ to from subject /),
    ];

    my $email = Email::MIME->create(
        attributes => {
            content_type => 'multipart/alternative',
        },
        header_str => $header,
        parts => [
            $html_part.
            $plaintext_part,
        ],
    );

    if ( !try_to_sendmail( $email, { transport => $self->transport } ) ) {
        return {
            ok => 0,
            errors => [
                'sendmail error'
            ],
        }
    }
}

sub DESTROY {
    my ( $self ) = @_;
    $self->smtp->disconnect;
}

1;
