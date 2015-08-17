use strict;
use warnings;
package DDGC::Util::Script::Base::ServiceEmail;

# ABSTRACT: Common elements of service architecture based email script modules

use Moo::Role;

use DDGC::Util::Email;

has smtp => (
    is => 'ro',
    lazy => 1,
    builder => '_build_smtp'
);
sub _build_smtp {
    my ( $self ) = @_;
    DDGC::Util::Email->new(
        smtp_config => {
            host          => $self->ddgc_config->smtp_host,
            ssl           => $self->ddgc_config->smtp_ssl,
            sasl_username => $self->ddgc_config->smtp_sasl_username,
            sasl_password => $self->ddgc_config->smtp_sasl_password,
        }
    );
}

1;
