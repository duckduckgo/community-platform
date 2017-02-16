use strict;
use warnings;
package DDGC::Util::Script::SubscriberMailer;

use DateTime;
use Moo;
use Hash::Merge qw/ merge /;

with 'DDGC::Util::Script::Base::Service';
with 'DDGC::Util::Script::Base::ServiceEmail';

has campaigns => ( is => 'lazy' );
sub _build_campaigns {
    my $campaigns = +{
        'a' => {
            single_opt_in => 1,
            live => 1,
            verify => {
                subject => 'Tracking in Incognito?',
                template => 'email/a/1.tx'
            },
            mails => {
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
        },
        'b' => {
            base => 'a',
            verify => {
                subject => 'Tracking in Incognito?',
                template => 'email/a/1b.tx'
            }
        },
        'c' => {
            base => 'a',
            single_opt_in => 0,
            verify => {
                subject => 'Tracking in Incognito?',
                template => 'email/a/v.tx'
            }
        }
    };

    for my $campaign ( keys %{ $campaigns } ) {
        if ( my $base = $campaigns->{ $campaign }->{base} ) {
            if ( $campaigns->{ $base } ) {
                $campaigns->{ $campaign } = merge( $campaigns->{ $campaign }, $campaigns->{ $base } );
            }
            else {
                die "Base $base does not exist - cannot build campaign $campaign"
            }
        }
    };

    return $campaigns;
}

sub email {
    my ( $self, $log, $subscriber, $subject, $template, $verified ) = @_;

    my $status = $self->smtp->send( {
        to       => $subscriber->email_address,
        verified => $verified
                    || ( $subscriber->verified && !$subscriber->unsubscribed ),
        from     => '"DuckDuckGo Dax" <dax@duckduckgo.com>',
        subject  => $subject,
        template => $template,
        content  => {
            subscriber => $subscriber,
        }
    } );

    if ( $status->{ok} ) {
        $subscriber->update_or_create_related( 'logs', { email_id => $log } );
    }

    return $status;
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
            ->unverified( $self->campaigns->{ $campaign }->{single_opt_in} )
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

sub add {
    my ( $self, $params ) = @_;
    my $email = Email::Valid->address($params->{email});
    return unless $email;

    my $campaigns = [ $params->{campaign} ];
    push @{ $campaigns }, $self->campaigns->{ $params->{campaign} }->{base}
        if $self->campaigns->{ $params->{campaign} }->{base};
    my $exists = rset('Subscriber')->exists( $email, $campaigns );
    return $exists if $exists;

    return rset('Subscriber')->create( {
        email_address => $email,
        campaign      => $params->{campaign},
        flow          => $params->{flow},
        verified      => $self->campaigns->{ $params->{campaign} }->{single_opt_in},
    } );
}

1;
