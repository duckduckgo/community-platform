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

    # TODO: exclude staff from reports

=cut

has db => (is => 'lazy');

sub _build_db { DDGC->new->db }

sub report {
    my ($class, %args) = @_;
    my $self = $class->new(%args);

    #$self->support;
    $self->translations;
}

sub support {
    my ($self) = @_;

    my $rs = $self->db->resultset('Comment')
        ->search_rs({ 
            'me.ghosted' => 0,
            seen_live    => 1,
            context      => [qw/DDGC::DB::Result::Idea DDGC::DB::Result::Thread/],
        }, { 
            select => [{ count => 'me.id', -as => 'comment_count' }, 'users_id'],
        })
        ->group_by('users_id')
        ->order_by({ -desc => 'comment_count' });

    while (my $comment = $rs->next) {
        next unless $comment->user->public;
        next if     $comment->user->ghosted;
        last unless $comment->get_column('comment_count') >= 50;

        say sprintf "username: %-30s   comments: %-5s   email: %-50s",
            $comment->user->username,
            $comment->get_column('comment_count'),
            $comment->user->email // '';
    }
}

sub translations {
    my ($self) = @_;

    my $rs = $self->db->resultset('Token::Language')
        ->search_rs({}, {
            select   => [ { count => 'me.id', -as => 'translation_count' }, 'translator_users_id' ],
            group_by => 'translator_users_id',
        })
        ->order_by({ -desc => 'translation_count' });

    while (my $token_language = $rs->next) {
        my $user = $token_language->translator_user || next;

        next unless $user->public;
        next if $user->ghosted;
        last unless $token_language->get_column('translation_count') >= 50;

        my $username = $user->username;
        $username   .= "*" if $user->has_flag('translation_manager');

        say sprintf "username: %-30s   live translations: %-5s   email: %-50s",
            $username,
            $token_language->get_column('translation_count'),
            $user->email // '';
    }
}

1;
