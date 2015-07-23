package DDGC::Stats::Comleader;
# ABSTRACT: Calculate stats of github users to find potential comleaders
use Moo;
use 5.16.0;

use DDP;
use Number::Format qw/round/;
use DDGC::Stats::GitHub::Utils qw/duration_to_minutes human_duration/;
use DateTime;
use List::AllUtils qw/any/;

use DDGC;

=head1 SYNOPSIS

    my %report = DDGC::Stats::Comleader->report();

=cut

has db => (is => 'lazy');

sub _build_db { DDGC->new->db }

sub report {
    my ($class, %args) = @_;
    my $self = $class->new(%args);

    my $report = $self->support();

    return $report;
}

sub support {
    my ($self) = @_;

    # TODO: exclude staff
    my $rs = $self->db->resultset('Comment')
        ->search_rs(
            { 
                'me.ghosted' => 0,
                seen_live    => 1,
                context      => [qw/DDGC::DB::Result::Idea DDGC::DB::Result::Thread/],
            },
            { 
                select   => [ { count => 'me.id', -as => 'number_of_comments' }, 'users_id' ],
                group_by => 'users_id',
            },
        )
#       ->prefetch('user')
#       ->columns([qw/users_id/])
#       ->group_by('users_id')
        ->order_by({ -desc => 'number_of_comments' });

    while (my $comment = $rs->next) {
        next if !$comment->user->public;
        next if $comment->user->ghosted;
        say sprintf "username: %-50s   comments: %-5s   email: %-50s",
            $comment->user->username,
            $comment->get_column('number_of_comments'),
            $comment->user->email // '';
    }

}


# query flags column for translation_manager

# 50 live translations
#sub translations {
#    my ($self) = @_;
#
#    # live translations live in token_language
#    # publicy viewable users (ignore hidden users -- see public flag)
#    # not staff
#    # ghosted 0
#}


1;
