use strict;
use warnings;
package DDGC::Util::Script::SubscriberMailer;

use DateTime;
use DDGC::Schema::Result::Subscriber;
use Moo;

with 'DDGC::Util::Script::Base::Service';
with 'DDGC::Util::Script::Base::ServiceEmail';

has campaigns => ( is => 'lazy' );
sub _build_campaigns {
    {
        'a' => {
            live => 1,
            verify => {
                subject => 'Privacy Newsletter | DuckDuckGo',
                template => 'email/a/v.tx'
            },
            mails => {
                1 => {
                    days     => 1,
                    subject  => 'Tracking In Incognito?',
                    template => 'email/a/1.tx',
                },
                2 => {
                    days     => 2,
                    subject  => 'Are Ads Following You?',
                    template => 'email/a/2.tx',
                },
                3 => {
                    days     => 4,
                    subject  => 'Are Ads Costing You Money?',
                    template => 'email/a/3.tx',
                },
                4 => {
                    days     => 6,
                    subject  => 'Have You Deleted Your Google Search History Yet?',
                    template => 'email/a/4.tx',
                },
                5 => {
                    days     => 8,
                    subject  => 'Is Your Data Being Sold?',
                    template => 'email/a/5.tx',
                },
                6 => {
                    days     => 11,
                    subject  => 'Who Decides What Websites You Visit?',
                    template => 'email/a/6.tx',
                },
                7 => {
                    days     => 12,
                    subject  => 'Was This Useful?',
                    template => 'email/a/7.tx',
                },
            }
        }
    },
}

sub email {
    my ( $self, $log, $subscriber, $subject, $template, $verified, $nolog, $extra ) = @_;

    my $status = $self->smtp->send( {
        to       => $subscriber->email_address,
        verified => $verified
                    || ( $subscriber->verified && !$subscriber->unsubscribed ),
        from     => '"DuckDuckGo Dax" <dax@duckduckgo.com>',
        subject  => $subject,
        template => $template,
        content  => {
            subscriber => $subscriber,
            $extra ? %{ $extra } : (),
        }
    } );

    if ( $status->{ok} && !$nolog ) {
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
                ->unbounced
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

sub testrun {
    my ( $self, $campaign, $email ) = @_;
    my $junk = time;

    my $subscriber = DDGC::Schema::Result::Subscriber->new( {
        email_address => $email,
        campaign      => $campaign,
        verified      => 1,
    } );

    my $mails = $self->campaigns->{ $campaign }->{mails};
    for my $mail ( keys $mails ) {
        $self->email(
            $mail,
            $subscriber,
            $mails->{ $mail }->{subject},
            $mails->{ $mail }->{template},
            1, 1,
            {
                getjunk => $junk
            }
        );
    }
}

1;
