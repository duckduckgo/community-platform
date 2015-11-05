package DDGC::DB::ResultSet::InstantAnswer;
# ABSTRACT: Resultset class for Instant Answer Pages

use Moose;
extends 'DDGC::DB::Base::ResultSet';
use namespace::autoclean;

sub ia_index_hri {
    my ( $self, $limit, $last ) = @_;
    my $ial = $self->search( {
            'topic.name' => { '!=' => 'test' },
            'me.dev_milestone' => { '=' => 'live'},
        },
        {
            prefetch => { instant_answer_topics => 'topic' },
            columns => [
                qw/ name repo src_name
                    dev_milestone description
                    template id meta_id
                /, ],
            collapse => 1,
        },
    )->hri
     ->order_by( 'me.name' );

    $ial = $ial->rows( $limit ) if $limit;
    $ial = $ial->search( {
       'me.name' => { '>' => $last },
    } ) if $last;

    return $ial->all_ref;
}

sub ia_index_pg_json {
    my ( $self, $limit, $last ) = @_;
    my @bind;

    my $query = <<'QUERY';
        SELECT array_to_json(array_agg(row_to_json(instant_answer_row)))
        FROM (
            SELECT instant_answer.name, instant_answer.repo, instant_answer.src_name,
                   instant_answer.dev_milestone, instant_answer.description,
                   instant_answer.template, instant_answer.id, instant_answer.meta_id,
                (
                    SELECT array_to_json(array_agg(row_to_json(topic_row)))
                    FROM (
                        SELECT instant_answer_topics.instant_answer_id,
                               instant_answer_topics.topics_id,
                               ( SELECT row_to_json(inner_topic_row)
                                   FROM (
                                       SELECT inner_topics.name, inner_topics.id
                                       FROM   topics inner_topics
                                       WHERE  inner_topics.id = instant_answer_topics.topics_id
                                    ) inner_topic_row
                               ) AS topic
                        FROM   instant_answer_topics, topics
                        WHERE  instant_answer_topics.instant_answer_id = instant_answer.id
                          AND  instant_answer_topics.topics_id = topics.id
                    ) topic_row
                ) AS instant_answer_topics
            FROM instant_answer
            ORDER BY instant_answer.name
        ) instant_answer_row
QUERY


    if ( $last ) {
        $query .= "WHERE instant_answer.name > ?\n";
        push @bind, $last;
    }
    if ( $limit ) {
        $query .= "LIMIT ?\n";
        push @bind, $limit;
    }

    my $result = $self->schema->storage->dbh->selectall_arrayref($query, undef, @bind);
    return $result;
}

1;
