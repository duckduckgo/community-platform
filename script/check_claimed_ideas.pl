#!/usr/bin/env perl
# check all claimed ideas and make sure they have an IA page.
# if not then make one
use FindBin;
use lib $FindBin::Dir . "/../lib";
use DDGC;
use Time::Local;
my $d = DDGC->new;

BEGIN {
    $ENV{DDGC_IA_AUTOUPDATES} = 1;
}

MAIN: {
    my $claimed_without_page = $d->rs('Idea')
        ->search({
            claimed_by          => {'!=' => undef},
            instant_answer_id   => undef,
        });

    my @time = localtime(time);
    my $date = "$time[4]/$time[3]/".($time[5]+1900);

    while (my $idea = $claimed_without_page->next){

        my $ia = $d->rs('InstantAnswer')
            ->find(
                $idea->id,
                {
                    result_class =>  'DBIx::Class::ResultClass::HashRefInflator'
                },
            );

        my %ia_page = (
            id              => $ia->{id} || $idea->id,
            meta_id         => $ia->{meta_id} || $idea->id,
            dev_milestone   => $ia->{dev_milestone} || 'planning',
            name            => $ia->{name} || $idea->title,
            description     => $ia->{description} ||$idea->content,
            created_date    => $ia->{created_date} || $date,
            forum_link      => $ia->{forum_link} || $idea->id,
        );

        $ia = $d->rs('InstantAnswer')->update_or_create({%ia_page});
        $idea->update({instant_answer_id => $ia_page{id}});
        $idea->user->subscribe_to_instant_answer( $ia->id );

        print "Created IA page: $ia_page{id}\n";
    }
}
