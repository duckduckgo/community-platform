package DDGC::Web::Controller::Admin::Stats;
# ABSTRACT: Statistics web controller class

use Moose;
use Time::Piece;
use Time::Seconds;
use List::MoreUtils qw/ uniq /;

BEGIN { extends 'Catalyst::Controller'; }

use namespace::autoclean;

sub base :Chained('/admin/base') :PathPart('stats') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
    $c->add_bc('Statistics', $c->chained_uri('Admin::Stats','index'));
}

sub index :Chained('base') :PathPart('') :Args(0) {
    my ( $self, $c ) = @_;
    $c->bc_index;
}

sub unique_contributors {
    my ($self, $contribs, $start_date, $end_date) = @_;
    uniq map  { $_->get_column('users_id') }
         grep { ( $_->created ge $start_date && $_->created lt $end_date ) }
         map  { @{$contribs->{$_}} } keys $contribs;
}

sub b_not_in_a {
    my ($self, $a, $b) = @_;
    my %in_a;
    $in_a{$_}++ for @{$a};
    grep { !$in_a{$_} } @{$b};
}

sub unique_contributors_by_type {
    my ($self, $contribs, $start_date, $end_date, $type) = @_;
    uniq map  { $_->get_column('users_id') }
         grep { ( $_->created ge $start_date && $_->created lt $end_date ) }
         @{$contribs->{$type}};

}

sub unique_comment_contributors_by_context {
    my ($self, $contribs, $start_date, $end_date, $context) = @_;
    uniq map  { $_->get_column('users_id') }
         grep { ( $_->created ge $start_date && $_->created lt $end_date && $_->context eq $context ) }
         @{$contribs->{comment}};

}


sub contributions :Chained('base') :Args(0) {
    my ( $self, $c ) = @_;
    $c->add_bc('Community Platform Contributions');
    my $contribs;
    my $now = localtime;
    my $month_start = Time::Piece->strptime(
        $now->year . " " . $now->mon . " 1",
        "%Y %m %d"
    );
    my @months_ago = ($month_start, map { $month_start->add_months(-$_) } (1..9));

    for my $contribtype ( qw/
        Idea::Vote
        User::Report
        Token::Language::Translation::Vote
    / ) {
        @{$contribs->{$contribtype}} =
            $c->d->rs($contribtype)->search(
                {
                    created => { '>=' => $months_ago[9]->ymd },
                },
                {   columns => [ qw/ created users_id / ] },
            )->all;
    }

    @{$contribs->{'Token::Language::Translation'}} =
        $c->d->rs('Token::Language::Translation')->search_rs(
            {
                'me.created' => { '>=' => $months_ago[9]->ymd },
            },
            {
                select => [
                    'user.id',
                    'me.created',
                ],
                as => [
                    'users_id',
                    'created',
                ],
                join => 'user',
            },
        )->all;

    for my $contribtype ( qw/
        Comment
        Idea
        Thread
    / ) {
        @{$contribs->{$contribtype}} =
            $c->d->rs($contribtype)->search_rs(
                {
                    created => { '>=' => $months_ago[7]->ymd },
                    ghosted => 0,
                },
                {   columns => [ qw/ created users_id /,
                    ($contribtype eq 'Comment')? 'context' : '' ] },
            )->all;
    }

    $c->stash->{date} = $month_start->strftime('%d %B %Y');
    my @a = $self->unique_contributors($contribs, $months_ago[3]->ymd, $months_ago[0]->ymd);
    my @b;
    push @{$c->stash->{churn_stats}}, {
        title => "Contributors from " . $months_ago[3]->strftime('%d %B %Y')
                . " to " . ($months_ago[0] - ONE_DAY)->strftime('%d %B %Y'),
        value => scalar @a,
    };
    for (3, 6) {
        @b = $self->unique_contributors($contribs, $months_ago[$_+3]->ymd, $months_ago[$_]->ymd);
        push @{$c->stash->{churn_stats}}, {
            title => "Contributors from " . $months_ago[$_+3]->strftime('%d %B %Y')
                    . " to " . ($months_ago[$_] - ONE_DAY)->strftime('%d %B %Y'),
            value => scalar @b,
        };
        push @{$c->stash->{churn_stats}}, {
            title => "   ...not seen from " . $months_ago[$_]->strftime('%d %B %Y')
                    . " to " . ($months_ago[$_-3] - ONE_DAY)->strftime('%d %B %Y'),
            value => scalar $self->b_not_in_a(\@a, \@b),
        };
        @a = @b;
    }

    for my $context (qw/
         DDGC::DB::Result::Idea
         DDGC::DB::Result::Thread
         DDGC::DB::Result::Token::Language
         DDGC::DB::Result::User::Blog
    /) {
        @a = $self->unique_comment_contributors_by_context
            ($contribs, $months_ago[3]->ymd, $months_ago[0]->ymd, $context);
        push @{$c->stash->{churn_stats}}, {
            title => "$context comment contributors from " . $months_ago[3]->strftime('%d %B %Y')
                     . " to " . ($months_ago[0] - ONE_DAY)->strftime('%d %B %Y'),
            value => scalar @a,
        };

        for (3, 6) {
            @b = $self->unique_comment_contributors_by_context
                ($contribs, $months_ago[$_+3]->ymd, $months_ago[$_]->ymd, $context);

            push @{$c->stash->{churn_stats}}, {
                title => "$context comment contributors from " . $months_ago[$_+3]->strftime('%d %B %Y')
                        . " to " . ($months_ago[$_] - ONE_DAY)->strftime('%d %B %Y'),
                value => scalar @b,
            };

            push @{$c->stash->{churn_stats}}, {
                title => "   ...not seen from " . $months_ago[$_]->strftime('%d %B %Y')
                        . " to " . ($months_ago[$_-3] - ONE_DAY)->strftime('%d %B %Y'),
                value => scalar $self->b_not_in_a(\@a, \@b),
            };
            @a = @b;
        }
    }

    for my $type (qw/
        Thread
        Idea
        User::Report
        Token::Language::Translation
        Token::Language::Translation::Vote
        Idea::Vote
    /) {

        @a = $self->unique_contributors_by_type
            ($contribs, $months_ago[3]->ymd, $months_ago[0]->ymd, $type);
        push @{$c->stash->{churn_stats}}, {
            title => "$type contributors from " . $months_ago[3]->strftime('%d %B %Y')
                     . " to " . ($months_ago[0] - ONE_DAY)->strftime('%d %B %Y'),
            value => scalar @a,
        };

        for (3, 6) {
            @b = $self->unique_contributors_by_type
                ($contribs, $months_ago[$_+3]->ymd, $months_ago[$_]->ymd, $type);

            push @{$c->stash->{churn_stats}}, {
                title => "$type contributors from " . $months_ago[$_+3]->strftime('%d %B %Y')
                        . " to " . ($months_ago[$_] - ONE_DAY)->strftime('%d %B %Y'),
                value => scalar @b,
            };

            push @{$c->stash->{churn_stats}}, {
                title => "   ...not seen from " . $months_ago[$_]->strftime('%d %B %Y')
                        . " to " . ($months_ago[$_-3] - ONE_DAY)->strftime('%d %B %Y'),
                value => scalar $self->b_not_in_a(\@a, \@b),
            };
            @a = @b;
        }
    }

}

no Moose;
__PACKAGE__->meta->make_immutable;
