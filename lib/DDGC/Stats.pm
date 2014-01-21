package DDGC::Stats;
# ABSTRACT: 

use Moose;
use DateTime;
use DateTime::Duration;

has ddgc => (
  isa => 'DDGC',
  is => 'ro',
  weak_ref => 1,
  required => 1,
);

sub content_def { my ( $self ) = @_;
  my @github_scopes = $self->ddgc->rs('GitHub::Repo')->search({
    used_in_stats => 1,
  })->all;
  return (
    'Comment' => {
      scope => 'context',
      scopes => { map {
        $_ => 'DDGC::DB::Result::'.$_
      } qw( Thread Idea Token::Language ) },
      relations => {
        created => { users_id => 'user' },
      },
    },
    (map {
      $_ => {
        relations => {
          created => { users_id => 'user' },
        },
      },
    } qw(
      Thread Idea Idea::Vote Token::Language::Translation
      Token::Language::Translation::Vote
    )),
    (map {
      $_ => {
        join => [qw( github_repo )],
        scope => 'github_repo.full_name',
        scopes => {
          map { $_->full_name, $_->full_name } ($self->ddgc->rs('GitHub::Repo')->search({
            used_in_stats => 1,
          })->all)
        },
        relations => {
          created => { users_id => 'user' },
        },
      }
    } qw( GitHub::Issue GitHub::Pull )),
    'GitHub::Commit' => {
      join => [qw( github_repo )],
      scope => 'github_repo.full_name',
      scopes => {
        map { $_->full_name, $_->full_name } ()
      },
      relations => {
        author_date => { github_user_id_author => 'github_user_author' },
      },
    },
  )
}

sub content {
  my ( $self, $types_ref, %args ) = @_;
  my %sets;
  my @types = @{$types_ref};
  my $from = delete $args{from};
  my $to = delete $args{to};
  for (@types) {
    my ( $resultset, $context ) = split('\|',$_);
    my %search;
    $search{context} = 'DDGC::DB::Result::'.$context if $context;
#    $search{created} = {};
    $sets{$resultset} = \%search;
  }
  my @union;
  for my $resultset (keys %sets) {
    my $search = $sets{$resultset};
    my $tableclass = '\''.$resultset.'\' AS tableclass';
    my $resultset_object = $self->ddgc->db->resultset($resultset);
    my $rs = $resultset_object->search_rs($search,{
      group_by => [qw( tableclass context users_id )],
      columns => [qw( users_id ), {
        tableclass => \$tableclass,
      },$resultset_object->result_source->has_column('context')
        ? (qw( context )) : ({ context => \'NULL AS context' }),{
        amount => \'COUNT(users_id) AS amount'
      }],
    });
    $rs->result_class('DDGC::DB::VirtualResult::UserCreatedContext');
    push @union, $rs;
  }
  my $first = shift @union;
  return $first->union([@union])->search({},{
    prefetch => [qw( user )],
    sort_by => [qw( tableclass context ), { -desc => 'amount' }],
  });
}

1;
