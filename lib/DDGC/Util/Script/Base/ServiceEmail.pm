use strict;
use warnings;
package DDGC::Util::Script::Base::ServiceEmail;

# ABSTRACT: Common elements of service architecture based email script modules

use Moo::Role;
with 'DDGC::Util::Script::Base::Service';

use DDGC::Util::Email;

has smtp => (
    is => 'ro',
    lazy => 1,
    builder => '_build_now_rounded'
);
sub _build_smtp {
    DDGC::Util::Email->new(
        smtp_config => {
            host          => $ddgc_config->smtp_host,
            ssl           => $ddgc_config->smtp_ssl,
            sasl_username => $ddgc_config->smtp_username,
            sasl_password => $ddgc_config->smtp_password,
        }
    );
}

1;
