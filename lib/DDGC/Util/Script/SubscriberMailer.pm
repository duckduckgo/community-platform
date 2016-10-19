use strict;
use warnings;
package DDGC::Util::Script::SubscriberMailer;

use DateTime;
use Moo;

with 'DDGC::Util::Script::Base::Service';
with 'DDGC::Util::Script::Base::ServiceEmail';

has campaigns => ( is => 'lazy' );
sub _build_campaigns {
    {
        'a' => {
            live => 1,
            verify => {
                subject => 'Please verify your email address',
                template => 'email/a/v.tx'
            },
            mails => {
                1 => {
                    days     => 1,
                    subject  => 'Placeholder 1',
                    template => 'email/a/1.tx',
                },
                2 => {
                    days     => 3,
                    subject  => 'Placeholder 2',
                    template => 'email/a/2.tx',
                },
                3 => {
                    days     => 5,
                    subject  => 'Placeholder 3',
                    template => 'email/a/3.tx',
                },
                4 => {
                    days     => 7,
                    subject  => 'Placeholder 4',
                    template => 'email/a/4.tx',
                },
                5 => {
                    days     => 9,
                    subject  => 'Placeholder 5',
                    template => 'email/a/5.tx',
                },
                6 => {
                    days     => 11,
                    subject  => 'Placeholder 6',
                    template => 'email/a/6.tx',
                },
                7 => {
                    days     => 15,
                    subject  => 'Placeholder 7',
                    template => 'email/a/7.tx',
                },
            }
        }
    },
}

sub email {
    my ( $self, $log, $subscriber, $subject, $template, $verified ) = @_;

    my $status = $self->smtp->send( {
        to       => $subscriber->email_address,
        verified => $verified
                    || ( $subscriber->verified && !$subscriber->unsubscribed ),
        from     => '"DuckDuckGo" <info@duckduckgo.com>',
        subject  => $subject,
        template => $template,
        content  => {
            subscriber => $subscriber,
        }
    } );

    if ( $status->{ok} ) {
        $subscriber->update_or_create_related( 'logs', { email_id => $log } );
    }
}

sub execute {
    my ( $self ) = @_;

    for my $campaign ( keys %{ $self->campaigns } ) {
        next if !$self->campaigns->{ $campaign }->{live};
        for my $mail ( keys %{ $self->campaigns->{ $campaign }->{mails} } ) {
            my @subscribers = rset('Subscriber')
                ->campaign( $campaign )
                ->subscribed
                ->verified
                ->mail_unsent( $campaign, $mail )
                ->by_days_ago( $self->campaigns->{ $campaign }->{mails}->{ $mail }->{days} )
                ->all;

            for my $subscriber ( @subscribers ) {
                $self->email(
                    $mail,
                    $subscriber,
                    $self->campaigns->{ $campaign }->{mails}->{ $mail }->{subject},
                    $self->campaigns->{ $campaign }->{mails}->{ $mail }->{template},
                );
            }
        }
    }

    return $self->smtp->transport;
}

sub verify {
    my ( $self ) = @_;

    for my $campaign ( keys %{ $self->campaigns } ) {
        next if !$self->campaigns->{ $campaign }->{live};
        my @subscribers = rset('Subscriber')
            ->campaign( $campaign )
            ->unverified
            ->verification_mail_unsent_for( $campaign )
            ->all;

        for my $subscriber ( @subscribers ) {
            $self->email(
                'v',
                $subscriber,
                $self->campaigns->{ $campaign }->{verify}->{subject},
                $self->campaigns->{ $campaign }->{verify}->{template},
                1
            );
        }
    }

    return $self->smtp->transport;
}

1;
