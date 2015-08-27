package DDGC::Web::Controller::Admin::Stats;
# ABSTRACT: Statistics web controller class

use Moose;
use Time::Piece;
use Time::Seconds;
use List::MoreUtils qw/ uniq /;
use DDGC::Stats::GitHub;
use DateTime::Format::Flexible;

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
    if ($context eq 'DDGC::DB::Result::Thread') {
        return uniq map  { $_->get_column('users_id') }
             grep { ( $_->created ge $start_date && $_->created lt $end_date &&
             $_->context eq $context && ($_->parent_id) ) }
             @{$contribs->{Comment}};
     }
     uniq map  { $_->get_column('users_id') }
          grep { ( $_->created ge $start_date && $_->created lt $end_date && $_->context eq $context ) }
          @{$contribs->{Comment}};
}

sub _context_name {
    +{
         'DDGC::DB::Result::Idea'               => 'Idea',
         'DDGC::DB::Result::Thread'             => 'Thread',
         'DDGC::DB::Result::Token::Language'    => 'Token',
         'DDGC::DB::Result::User::Blog'         => 'Blog',
    }
}

sub _contrib_name {
    +{
        'Thread'                                => 'Thread',
        'Idea'                                  => 'Idea',
        'User::Report'                          => 'Report',
        'Token::Language::Translation'          => 'Translation',
        'Token::Language::Translation::Vote'    => 'Translation vote',
        'Idea::Vote'                            => 'Idea vote',
    }
}


sub contributions :Chained('base') :Args(0) {
    my ( $self, $c ) = @_;
    $c->add_bc('Community Platform Contributions');
    my $contribs;
    my $now = localtime;
    my $periods = [
        { start => $now - (ONE_DAY * 90),  end => $now },
        { start => $now - (ONE_DAY * 180), end => $now - (ONE_DAY * 90) },
    ];
    my $created = $periods->[-1]->{start}->ymd;

    for my $contribtype ( qw/
        Idea::Vote
        User::Report
        Token::Language::Translation::Vote
    / ) {
        @{$contribs->{$contribtype}} =
            $c->d->rs($contribtype)->search(
                {
                    created => { '>=' => $created },
                },
                {   columns => [ qw/ created users_id / ] },
            )->all;
    }

    @{$contribs->{'Token::Language::Translation'}} =
        $c->d->rs('Token::Language::Translation')->search_rs(
            {
                'me.created' => { '>=' => $created },
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
                    created => { '>=' => $created },
                    ghosted => 0,
                },
                {   columns => [ qw/ created users_id /,
                    ($contribtype eq 'Comment')? qw/ context parent_id / : '' ] },
            )->all;
    }

    $c->stash->{date} = $periods->[0]->{end}->strftime('%d %B %Y');
    my @a = $self->unique_contributors
            ($contribs, $periods->[0]->{start}->ymd, $periods->[0]->{end}->ymd);
    my @b;
    push @{$c->stash->{churn_stats}}, {
        title => "Contributors from " . $periods->[0]->{start}->strftime('%d %B %Y')
                . " to " . ( $periods->[0]->{end} - ONE_DAY)->strftime('%d %B %Y'),
        value => scalar @a,
    };
    for my $period (@{$periods}[1..$#$periods]) {
        @b = $self->unique_contributors($contribs, $period->{start}->ymd, $period->{end}->ymd);
        push @{$c->stash->{churn_stats}}, {
            title => "Contributors from " . $period->{start}->strftime('%d %B %Y')
                    . " to " . ($period->{end} - ONE_DAY)->strftime('%d %B %Y'),
            value => scalar @b,
        };
        push @{$c->stash->{churn_stats}}, {
            title => "  ...not seen in next 90 days",
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
        (my $hname = $context) =~ s/::/_/g;
        @a = $self->unique_comment_contributors_by_context
            ($contribs, $periods->[0]->{start}->ymd, $periods->[0]->{end}->ymd, $context);
        push @{$c->stash->{"churn_stats_$hname"}}, {
            title => _context_name->{$context} . " comment contributors from " .
                    $periods->[0]->{start}->strftime('%d %B %Y')
                    . " to " . ($periods->[0]->{end} - ONE_DAY)->strftime('%d %B %Y'),
            value => scalar @a,
        };

        for my $period (@{$periods}[1..$#$periods]) {
            @b = $self->unique_comment_contributors_by_context
                ($contribs, $period->{start}->ymd, $period->{end}->ymd, $context);

            push @{$c->stash->{"churn_stats_$hname"}}, {
                title => _context_name->{$context} . " comment contributors from " .
                        $period->{start}->strftime('%d %B %Y')
                        . " to " . ($period->{end} - ONE_DAY)->strftime('%d %B %Y'),
                value => scalar @b,
            };

            push @{$c->stash->{"churn_stats_$hname"}}, {
                title => "  ...not making this type of comment in next 90 days",
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
        (my $hname = $type) =~ s/::/_/g;
        @a = $self->unique_contributors_by_type
            ($contribs, $periods->[0]->{start}->ymd, $periods->[0]->{end}->ymd, $type);
        push @{$c->stash->{"churn_stats_$hname"}}, {
            title => _contrib_name->{$type} . " contributors from " . $periods->[0]->{start}->strftime('%d %B %Y')
                     . " to " . ($periods->[0]->{end} - ONE_DAY)->strftime('%d %B %Y'),
            value => scalar @a,
        };

        for my $period (@{$periods}[1..$#$periods]) {
            @b = $self->unique_contributors_by_type
                ($contribs, $period->{start}->ymd, $period->{end}->ymd, $type);

            push @{$c->stash->{"churn_stats_$hname"}}, {
                title => _contrib_name->{$type} . " contributors from " . $period->{start}->strftime('%d %B %Y')
                        . " to " . ($period->{end} - ONE_DAY)->strftime('%d %B %Y'),
                value => scalar @b,
            };

            push @{$c->stash->{"churn_stats_$hname"}}, {
                title => "  ...not making this type of contribution in next 90 days",
                value => scalar $self->b_not_in_a(\@a, \@b),
            };
            @a = @b;
        }
    }
}

sub coupons :Chained('base') :Args(0) {
    my ( $self, $c ) = @_;
    $c->add_bc('Assigned Coupons');
    my $dbh = $c->d->rs('User')->schema->storage->dbh;

    $c->stash->{assigned_coupons} = $dbh->selectall_arrayref("
        select to_char(cn.responded, 'MM/DD/YYYY') as responded, uc.coupon as coupon
        from   user_campaign_notice cn, user_coupon uc
        where  cn.users_id = uc.users_id
          and  cn.campaign_source = 'campaign'
          and  cn.campaign_id = 2
          and  uc.users_id is not null
          and  cn.responded is not null
        order  by cn.responded desc
    ") or die $dbh->errstr;
}

# controller should do one thing, this is more than one thing
sub github :Chained('base') {
    my ($self, $c, $since) = @_;
    my $params = $c->req->params;

    $c->add_bc('GitHub');

    $c->stash->{default_start} = DateTime->now->subtract(months => 1)->ymd('-');
    $c->stash->{default_end}   = DateTime->now->ymd('-');
    $c->stash->{tabs}->{$since} = "selected";

    return if 
        $since eq 'custom' &&
        (!$params->{start} || !$params->{end});

    my $start_date;
    my $end_date;

    if ($since eq 'custom') {
        $start_date = DateTime::Format::Flexible->parse_datetime( $params->{start} );
        $end_date   = DateTime::Format::Flexible->parse_datetime( $params->{end} );
    }
    else {
        my %subtract;
        %subtract = (hours  => 24);
        %subtract = (weeks  =>  1) if $since eq 'last_week';
        %subtract = (weeks  =>  2) if $since eq 'week_before';
        %subtract = (weeks  =>  3) if $since eq 'week_before_that';
        %subtract = (months =>  1) if $since eq 'last_month';
        %subtract = (days   => 90) if $since eq 'last_90_days';

        $start_date = DateTime->now->subtract(%subtract);
        $end_date   = DateTime->now;
        $end_date   = DateTime->now->subtract(weeks => 1) if $since eq 'week_before';
        $end_date   = DateTime->now->subtract(weeks => 2) if $since eq 'week_before_that';
    }

    my @stats = DDGC::Stats::GitHub->report(
        db      => $c->ddgc->db, 
        between => [$start_date, $end_date],
    );

    $c->stash->{stats}      = \@stats;
    $c->stash->{start_date} = $start_date->ymd('-') . " " . $start_date->hms(':');
    $c->stash->{end_date}   = $end_date->ymd('-')   . " " . $end_date->hms(':');
}

no Moose;
__PACKAGE__->meta->make_immutable;
