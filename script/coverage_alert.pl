#!/usr/bin/env perl

use Moo;
use MooX::Options;

use FindBin;
use lib $FindBin::Dir . "/../lib";

use DDGC;
use DDGC::Util::Email;

option language => (
    is => 'ro',
    format => 's',
    repeatable => 1,
    default => sub { [ qw/ fr_FR de_DE / ] },
    doc => 'Languages to check coverage of'
);

option domain => (
    is => 'ro',
    format => 's',
    default => sub { 'duckduckgo' },
    coerce => sub {
        $_[0] =~ /test/
            ? $_[0]
            : 'duckduckgo-' . $_[0]
    },
    doc => 'Domain to check, e.g. duckduckgo',
);

option email => (
    is => 'ro',
    format => 's',
    repeatable => 1,
    required => 1,
    doc => 'Email addresses to send notifications to',
);

has ddgc => ( is => 'lazy' );
sub _build_ddgc {
    DDGC->new;
}

has smtp => ( is => 'lazy' );
sub _build_smtp {
    DDGC::Util::Email->new;
}

sub go {
    my ( $self ) = @_;
    my $uncovered_langs;
    my $languages = $self->ddgc->rs('Token::Domain::Language')->search(
        {
            'token_domain.key' => $self->domain,
            'language.locale' => { -in => $self->language },
        },
        {
            join => [ 'token_domain', 'language' ],
            '+columns' => {
            token_languages_undone_count => $self->ddgc->rs('Token::Language')->search({
                -and => [
                    'undone_count.id' =>  { -not_in =>
                        $self->ddgc->rs('Token::Language::Translation')->search({
                            check_result => '1',
                        },)->get_column('token_language_id')->as_query,
                    },
                    'undone_count.token_domain_language_id' => { -ident => 'me.id' },
                ],
            },{
                join => 'token_language_translations', alias => 'undone_count'
            })->count_rs->as_query,
            token_total_count => $self->ddgc->rs('Token')->search({
                'total_count.token_domain_id' => { -ident => 'me.token_domain_id' },
            },{
                join => 'token_domain', alias => 'total_count'
            })->count_rs->as_query,
            },
        }
    );

    while ( my $language = $languages->next ) {
        next if $language->done_percentage >= 100;
        $uncovered_langs->{ $language->language->locale } = $language->done_percentage;
    }

    if ( keys %{ $uncovered_langs } ) {
        for my $email ( @{ $self->email } ) {
            $self->smtp->send({
                to => $email,
                verified => 1,
                from => 'dax@duckduckgo.com',
                subject => sprintf('Translation coverage report for %s', $self->domain),
                template => 'email/translation_counts.tx',
                content => { languages => $uncovered_langs },
            });
        }
    }
}

main->new_with_options->go;
