package t::lib::DDGC::TestUtils::AWS;
use strict;
use warnings;

# ABSTRACT: Mock AWS messages

use JSON::MaybeXS;

sub _packet {
    my $message = $_[0];
    return encode_json(
        {
            Type => 'Notification',
            Message => $message,
        }
    );
}

sub sns_complaint {
    my $email = $_[1];
    die "Need an email address parameter" unless $email;
    my $message = encode_json(
        {
            notificationType => 'Complaint',
            complaint => {
                complainedRecipients => [
                    {
                        emailAddress => $email,
                    },
                ]
            }
        }
    );
    return _packet( $message );
}

sub sns_permanent_bounce {
    my $email = $_[1];
    die "Need an email address parameter" unless $email;
    my $message = encode_json(
        {
            notificationType => 'Bounce',
            bounce => {
                bounceType => 'Permanent',
                bouncedRecipients => [
                    {
                        emailAddress => $email,
                    },
                ]
            }
        }
    );
    return _packet( $message );
}

sub sns_transient_bounce {
    my $email = $_[1];
    die "Need an email address parameter" unless $email;
    my $message = encode_json(
        {
            notificationType => 'Bounce',
            bounce => {
                bounceType => 'Transient',
                bouncedRecipients => [
                    {
                        emailAddress => $email,
                    },
                ]
            }
        }
    );
    return _packet( $message );
}

1;
