package DDGC::Web::Controller::InstantAnswer;
# ABSTRACT: Instant Answer Pages
use Moose;
use namespace::autoclean;
use Try::Tiny;
use Time::Local;
use JSON;
use JSON::MaybeXS ':all';
use Net::GitHub::V3;
use DateTime;
use LWP::UserAgent;
use Digest::SHA;
use Date::Parse;

my $INST = DDGC::Config->new->appdir_path."/root/static/js";

BEGIN {extends 'Catalyst::Controller'; }

sub debug { 0 }
use if debug, 'Data::Dumper';

sub base :Chained('/base') :PathPart('ia') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
}

sub index :Chained('base') :PathPart('') :Args(0) {
    my ( $self, $c ) = @_;

    # Retrieve / stash all IAs for index page here?

    # my @x = $c->d->rs('InstantAnswer')->all();
    # $c->stash->{ialist} = \@x;
    $c->stash->{ia_page} = "IAIndex";

    #if ($field && $value) {
    #   $c->stash->{field} = $field;
    #   $c->stash->{value} = $value;
    #}

    my $rs = $c->d->rs('Topic');

    my @topics = $rs->search(
        {'name' => { '!=' => 'test' }},
        {
            columns => [ qw/ name id /],
            order_by => [ qw/ name /],
            result_class => 'DBIx::Class::ResultClass::HashRefInflator',
        }
    )->all;

    $c->stash->{title} = "Index: Instant Answers";
    $c->stash->{topic_list} = \@topics;
    $c->add_bc('Instant Answers', $c->chained_uri('InstantAnswer','index'));

    $c->stash->{ia_init} = encode_json(
        $c->d->rs('InstantAnswer')->ia_index_hri
    );
}

sub ialist_json :Chained('base') :PathPart('json') :Args() {
    my ( $self, $c ) = @_;

    my $rs = $c->d->rs('InstantAnswer');

    $c->return_if_not_modified( $rs->last_modified );

    my @ial = $rs->search(
        {'topic.name' => [{ '!=' => 'test' }, { '=' => undef}],
         'me.perl_module' => { -not_like => 'DDG::Goodie::IsAwesome::%' },
         'me.dev_milestone' => { '=' => 'live'},
        },
        {
            columns => [ qw/ perl_module name repo src_name dev_milestone description template /, {id => 'meta_id'} ],
            prefetch => { instant_answer_topics => 'topic' },
            result_class => 'DBIx::Class::ResultClass::HashRefInflator',
        }
    )->all;

    $c->stash->{x} = \@ial;
    $c->stash->{not_last_url} = 1;
    $c->forward($c->view('JSON'));
}

sub iarepo :Chained('base') :PathPart('repo') :CaptureArgs(1) {
    my ( $self, $c, $repo ) = @_;

    $c->stash->{ia_repo} = $repo;
}

sub iarepo_json :Chained('iarepo') :PathPart('json') :Args(0) {
    my ( $self, $c ) = @_;

    my $repo = $c->stash->{ia_repo};
    my $iarepo = $c->d->rs('InstantAnswer')->search({
        ( $repo ne 'all' )
            ? ( repo => $repo )
            : (),
        ( $c->req->params->{all_milestones} )
            ? ()
            : ( -or => [{dev_milestone => 'live'},
                        {dev_milestone => 'development'},
                        {dev_milestone => 'testing'},
                        {dev_milestone => 'complete'}]
              ),
    });

    $c->return_if_not_modified( $c->d->rs('InstantAnswer::LastUpdated')->search->last_modified );

    $iarepo = $iarepo->prefetch( { instant_answer_topics => 'topic' });
    my %iah;
    while (my $ia = $iarepo->next) {
        $iah{$ia->meta_id} = $ia->TO_JSON('for_endpt');

        # fathead specific
        # TODO: do we need src_domain ?

        my $src_options = $ia->src_options;
        if ($src_options ) {
            $iah{$ia->meta_id}{src_options} = from_json($src_options);
        }

        $iah{$ia->meta_id}{src_id} = $ia->src_id if $ia->src_id;
    }

    $c->stash->{x} = \%iah;
    $c->stash->{not_last_url} = 1;
    $c->forward($c->view('JSON'));
}

sub queries :Chained('base') :PathPart('queries') :Args(0) {

    # my @x = $c->d->rs('InstantAnswer')->all();

}

sub topics_base :Chained('base') :PathPart('topics') :CaptureArgs(0) {
    my ($self, $c) = @_;

    $c->stash->{ia_page} = "IATopics";
    $c->stash->{title} = "Topics";

    $c->add_bc('Topics', $c->chained_uri('InstantAnswer', 'topics'));
}

sub topics :Chained('topics_base') :PathPart('') :Args(0) {
    my ($self, $c) = @_;
    
    my $user = $c->user;
    unless ($user && $user->admin) {
        $c->response->redirect($c->chained_uri('InstantAnswer','index'));
        return $c->detach;
    }
}

sub topics_json :Chained('topics_base') :PathPart('json') :Args(0) {
    my ($self, $c) = @_;

    my $rs = $c->d->rs('Topic');

    my @ial = $rs->search(
        {'me.name' => [{ '!=' => 'test' }, { '=' => undef}]
        },
        {
            join => {
                instant_answer_topics => 'instant_answer'
            },
            columns => [ 
                qw/ me.name me.id /,
                {
                    'instant_answer_topics.instant_answer_id' => 
                        'instant_answer.meta_id'
                },
                {
                    'instant_answer_topics.instant_answer_name' =>
                    'instant_answer.name'
                }
            ],
            collapse => 1,
            result_class => 'DBIx::Class::ResultClass::HashRefInflator',
        }
    )->all;


    $c->stash->{x} = \@ial;
    $c->stash->{not_last_url} = 1;
    $c->forward($c->view('JSON'));
}

sub dev_pipeline_base :Chained('overview_base') :PathPart('pipeline') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
    
    $c->stash->{ia_page} = "IADevPipeline";
    $c->stash->{title} = "Dev Pipeline";
   
    $c->stash->{logged_in} = $c->user;
    $c->stash->{is_admin} = $c->user? $c->user->admin : 0;

    $c->add_bc('Dev Pipeline', $c->chained_uri('InstantAnswer', 'dev_pipeline'));
}

sub dev_pipeline :Chained('dev_pipeline_base') :PathPart('') :Args(0) {
    my ( $self, $c ) = @_;
}

sub dev_pipeline_json :Chained('dev_pipeline_base') :PathPart('json') :Args(0) {
    my ( $self, $c ) = @_;

    my $rs = $c->d->rs('InstantAnswer');

    my @ias;
    my $key;
    # Get IAs not yet live
    # and sort them by last activity (newest activity on top - ones with null activity value last)
    # the sorting here is temporary, just for demonstrational purposes
    @ias = $rs->search(
        {
            'dev_milestone' => { '=' => ['planning', 'development', 'testing', 'complete']},
            'approved' => { '=' => 1 }
        },
        {
            order_by => \[ 'me.last_update DESC NULLS LAST'],
        }
    );
    $key = 'dev_milestone';

    my $asana_server = "http://beta.duckduckgo.com/install?asana&ia=everything";

    my $result = asana_req('', $asana_server);
    try{
        $result = $result->decoded_content ? from_json($result->decoded_content) : undef;
    }catch{
        $result = {};
    };

    my %dev_ias;
    my $temp_ia;

    my $resp = beta_req();

    for my $ia (@ias) {
        $temp_ia = $ia->TO_JSON('pipeline');
        
        my $pr = $c->d->rs('InstantAnswer::Issues')->search({is_pr => 1, instant_answer_id => $ia->id}, {result_class => 'DBIx::Class::ResultClass::HashRefInflator'})->first;
        $pr->{tags} = $pr->{tags}? from_json($pr->{tags}) : undef;
        $temp_ia->{pr} = $pr;

        if ($c->user && (!$c->user->admin)) {
            my $can_edit = $ia->users->find($c->user->id)? 1 : undef;
            $temp_ia->{can_edit} = $can_edit;
        }

        if ($result && $result->{$ia->id}) {
            $temp_ia->{asana} = $result->{$ia->id};
        }
        
        if ($ia->last_update && $ia->last_commit && $pr->{issue_id}) {
            my $last_commit = from_json($ia->last_commit);
            if (($pr->{status} eq 'open' ||$pr->{status} eq 'merged') && $resp) {
                my $pr_id = $pr->{issue_id};
                my $repo = $ia->repo;
                my $beta_pr = $resp->{$repo}->{$pr_id};
                $temp_ia->{beta_install} = 0;
                warn $beta_pr->{install_status};
                if ($beta_pr) {
                    $temp_ia->{beta_install} = $beta_pr->{install_status};
                    $temp_ia->{beta_query} = $beta_pr->{meta}? $beta_pr->{meta}->{example_query} : 0;
                }
            }
       }

        push @{$dev_ias{$ia->$key}}, $temp_ia;
    }

    $c->stash->{x} = {
        $key.'s' => \%dev_ias,
        asana => $result
    };

    $c->stash->{not_last_url} = 1;
    $c->forward($c->view('JSON'));
}

sub deprecated_base :Chained('overview_base') :PathPart('deprecated') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
    
    $c->stash->{ia_page} = "IADeprecated";
    $c->stash->{title} = "Deprecated IA Pages";
   
    my $user = $c->user;
    my $is_admin = $c->user? $c->user->admin : 0;
    
    if ((!$user) || (!$is_admin)) {
        $c->response->redirect($c->chained_uri('My','login',{ admin_required => 1 }));
        return $c->detach;
    }

    $c->stash->{logged_in} = $user;
    $c->stash->{is_admin} = $is_admin;

    $c->add_bc('Deprecated', $c->chained_uri('InstantAnswer', 'deprecated'));
}

sub deprecated :Chained('deprecated_base') :PathPart('') :Args(0) {
    my ( $self, $c ) = @_;
}

sub deprecated_json :Chained('deprecated_base') :PathPart('json') :Args(0) {
    my ( $self, $c ) = @_;

    my $rs = $c->d->rs('InstantAnswer');
    my @ias;
    my $key;
    
    if ($c->stash->{is_admin}) {
        @ias = $rs->search({'dev_milestone' => { '=' => ['deprecated', 'ghosted']}});
    } else {
        @ias = $rs->search({'dev_milestone' => { '=' => 'deprecated'}});
    }
    
    $key = 'repo';

    my %dep_ias;
    my %ghosted;
    my $temp_ia;
    for my $ia (@ias) {
        $temp_ia = $ia->TO_JSON('pipeline');
        my $repo = $ia->$key? $ia->$key : 'none';

        if ($ia->dev_milestone eq 'deprecated') {
            push @{$dep_ias{$repo}}, $temp_ia;
        } else {
             push @{$ghosted{$repo}}, $temp_ia;
        }
    }

    my %dev_ias = (
        deprecated => \%dep_ias,
        ghosted => \%ghosted
    );
    
    $c->stash->{x} = \%dev_ias;

    $c->stash->{not_last_url} = 1;
    $c->forward($c->view('JSON'));
}

sub issues_base :Chained('overview_base') :PathPart('issues') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
    
    $c->stash->{ia_page} = "IAIssues";
    $c->stash->{title} = "IA Pages Issues";
   
    $c->add_bc('Issues', $c->chained_uri('InstantAnswer', 'issues'));
}

sub issues_json :Chained('issues_base') :PathPart('json') :Args(0) {
    my ( $self, $c ) = @_;        

    my $rs = $c->d->rs('InstantAnswer::Issues');
    my @result = $rs->search({'is_pr' => { '=' => 0}, 'status' => { '=' => 'open'}},{order_by => { -desc => 'date'}})->all;
    my %ial;
    my $ia;
    my $id;
    my $dev_milestone;
    my @tags;
    my %temp_tags;
    my @issues_by_date;

    for my $issue (@result) {
        $id = $issue->instant_answer_id;
        $ia = $c->d->rs('InstantAnswer')->find($id);
        $dev_milestone = $ia->dev_milestone;
        my @issues;
        if ($dev_milestone eq 'live') {
            for my $tag (@{$issue->tags}) {
                if (!$temp_tags{$tag->{name}}) {
                    $temp_tags{$tag->{name}} = {
                            name => $tag->{name},
                            color => $tag->{color}
                        };
                }
            }
            
            my %temp_issue = (
                    issue_id => $issue->issue_id,
                    title => $issue->title,
                    tags => $issue->tags,
                    date => $issue->date,
                    author => $issue->author,
                    ia_id => $id,
                    ia_name => $ia->name,
                    repo => $issue->repo,
                    status => $issue->status
            );

            push @issues_by_date, \%temp_issue;

            if (defined $ial{$id}) {
                my @existing_issues = @{$ial{$id}->{issues}};
                push @existing_issues, \%temp_issue;

                $ial{$id}->{issues} = \@existing_issues;
            } else {
                push @issues, \%temp_issue;

                $ial{$id}  = {
                        name => $ia->name,
                        id => $ia->meta_id,
                        repo => $ia->repo,
                        dev_milestone => $ia->dev_milestone,
                        producer => $ia->producer,
                        designer => $ia->designer,
                        developer => $ia->developer? from_json($ia->developer) : undef,
                        issues => \@issues
                    };
            }
        }
    }

    my @sorted_ial;

    foreach my $ia_id (sort keys %ial) {
        push(@sorted_ial, $ial{$ia_id});
    }

    foreach my $tag_name (sort keys %temp_tags) {
        push(@tags, $temp_tags{$tag_name});
    }

    $c->stash->{x} = {
        ia => \@sorted_ial,
        tags => \@tags,
        by_date => \@issues_by_date
    };

    $c->stash->{not_last_url} = 1;
    $c->forward($c->view('JSON'));
}

sub issues :Chained('issues_base') :PathPart('') :Args(0) {
    my ( $self, $c ) = @_;
}

sub overview_base :Chained('base') :PathPart('dev') :CaptureArgs(0) {
    my ( $self, $c ) = @_;

    $c->stash->{ia_page} = "IAOverview";
    $c->stash->{title} = "IA Pages Overview";
   
    $c->stash->{logged_in} = $c->user;
    $c->stash->{is_admin} = $c->user? $c->user->admin : 0;

    $c->add_bc('IA Pages Home', $c->chained_uri('InstantAnswer','overview'));
}

sub overview_json :Chained('overview_base') :PathPart('json') :Args(0) {
    my ( $self, $c ) = @_;

    my @ias;
    my @live_ias;
    my @dev_ias;
    my $rs = $c->d->rs('InstantAnswer');
    my $dev_count = 0;
    my $live_count = $rs->search({
            dev_milestone => 'live', 
            'topic.name' => [{ '!=' => 'test' }, { '=' => undef}]
        },
        {   prefetch => { instant_answer_topics => 'topic' }
        })->count;

    my $resp = beta_req();
     
    @ias = $rs->search({
         dev_milestone => 'live',
         live_date => { '!=' => undef }, 
         'topic.name' => [{ '!=' => 'test' }, { '=' => undef}]
     },
     {   
         prefetch => { instant_answer_topics => 'topic'},
         rows => 5,
         order_by => {-desc => 'live_date'}
    })->all;
    
    my $temp_ia;
    for my $ia (@ias) {
        $temp_ia = $ia->TO_JSON('pipeline');
        $temp_ia->{most_recent} = 1;
        push @live_ias, $temp_ia;
     }

     my @issues = $c->d->rs('InstantAnswer::Issues')->search({},{order_by => {-desc => 'date'}})->all;

     my @bugs;
     my @high_p;
     my @lhf;

     for my $issue (@issues) {
        my $is_pr = $issue->is_pr;
        my $issue_ia = $c->d->rs('InstantAnswer')->find($issue->instant_answer_id);
        if ($is_pr ne 1) {
            my %temp_issue = (
                title => $issue->title,
                body => $issue->body,
                date => $issue->date,
                issue_id => $issue->issue_id,
                ia_id => $issue->instant_answer_id,
                repo => $issue->repo,
                status => $issue->status? $issue->status : undef,
                author => $issue->author
            );

            my @temp_tags;
            my $is_highp = 0;
            my $is_bug = 0;
            my $is_lhf = 0;

            $temp_issue{ia_name} = $issue_ia->name;

            for my $tag (@{$issue->tags}) {
                my $tag_name = $tag->{name};

                my %temp_tag = (
                    name => $tag_name,
                    color => $tag->{color}
                );

                push @temp_tags, \%temp_tag;

                if ($tag_name eq 'Priority: High') {
                    $is_highp = 1;
                } elsif ($tag_name eq 'Bug') {
                    $is_bug = 1;
                } elsif ($tag_name eq 'Low-Hanging Fruit') {
                    $is_lhf = 1;
                }
            }

            $temp_issue{tags} = \@temp_tags;

            if ($is_highp) {
                push @high_p, \%temp_issue;
            } elsif ($is_bug) {
                push @bugs, \%temp_issue;
            } elsif ($is_lhf) {
                push @lhf, \%temp_issue;
            }
         } else {
            my $pr = $issue;
            if (($pr->status eq 'open' || $pr->status eq 'merged') && $resp && (($issue_ia->dev_milestone ne 'live') && ($issue_ia->dev_milestone ne 'deprecated'))) {
                my $pr_id = $pr->issue_id;
                my $repo = $issue_ia->repo;
                my $beta_pr = $resp->{$repo}->{$pr_id};
                if ($beta_pr) {
                    my $beta_install = $beta_pr->{install_status};
                    if ($beta_install =~ /success/i) {
                        if (scalar @dev_ias < 5) {
                            $temp_ia = $issue_ia->TO_JSON('pipeline');
                            $temp_ia->{most_recent} = 1;
                            $temp_ia->{beta_date} = $beta_pr->{date};
                            push @dev_ias, $temp_ia;
                        }
                        
                        $dev_count++;
                    }
                }

            }
         }
     }


     my %top_issues = (
         bugs => { name => "Bugs", list => \@bugs },
         high_p => { name => "Priority: High", list => \@high_p },
         lhf => { name => "Low-Hanging Fruit", list => \@lhf }
     );

     #Sort IAs in beta by date
     @dev_ias = reverse sort { str2time($a->{beta_date}) <=> str2time($b->{beta_date}) } @dev_ias;

     my %ias = (
         live => { count => $live_count, list => \@live_ias },
         new => { count =>  $dev_count, list => \@dev_ias }
     );

     $c->stash->{x} = {
         ias => \%ias,
         issues => \%top_issues
     };

     $c->stash->{not_last_url} = 1;
     $c->forward($c->view('JSON'));
}

sub overview :Chained('overview_base') :PathPart('') :Args(0) {
     my ( $self, $c ) = @_;
}

sub ia_base :Chained('base') :PathPart('view') :CaptureArgs(1) {  # /ia/view/calculator
    my ( $self, $c, $answer_id ) = @_;

    $c->stash->{ia_page} = "IAPage";
    $c->stash->{ia} = $c->d->rs('InstantAnswer')->find({meta_id => $answer_id});
    my $ia = $c->stash->{ia};
    
    unless ($ia) {
        $c->response->redirect($c->chained_uri('InstantAnswer','index',{ instant_answer_not_found => 1 }));
        return $c->detach;
    }
    
    @{$c->stash->{issues}} = $c->d->rs('InstantAnswer::Issues')->search({instant_answer_id => $ia->id}); 

    my $permissions;
    my $is_admin;
    my $can_edit;
    my $can_commit;
    my $commit_class = "hide";
    my $dev_milestone = $ia->dev_milestone;
    $c->stash->{repo} = $ia->repo;

    if ($c->user) {
        $permissions = $ia->users->find($c->user->id);
        $is_admin = $c->user->admin;

        if ($permissions || $is_admin) {
            $can_edit = 1;

            if ($is_admin) {
                my @edits = get_all_edits($c->d, $answer_id);
                $can_commit = 1;
                $commit_class = '' if @edits;

                my @blockgroups = $c->d->rs('InstantAnswer::Blockgroup')->search(
                    {},
                    {
                        columns => [ qw/ blockgroup id / ],
                        order_by => [ qw / blockgroup / ],
                        result_class => 'DBIx::Class::ResultClass::HashRefInflator',
                    }
                )->all;

                $c->stash->{blockgroup_list} = \@blockgroups;
            } else {
                if ($c->user->new_contributor) {
                    $c->stash->{new_contributor} = 1;
                    $c->stash->{id} = $ia->id;
                    user_contributed($c->user);
                }
            }
        }
    }

    $c->stash->{title} = $ia->name;
    $c->stash->{can_edit} = $can_edit;
    $c->stash->{can_commit} = $can_commit;
    $c->stash->{commit_class} = $commit_class;

    my @topics = $c->d->rs('Topic')->search(
        {'name' => { '!=' => 'test' }},
        {
            columns => [ qw/ name id /],
            order_by => [ qw/ name/ ],
            result_class => 'DBIx::Class::ResultClass::HashRefInflator',
        }
    )->all;

    $c->stash->{topic_list} = \@topics;
    $c->stash->{dev_milestone} = $dev_milestone;
    if ($dev_milestone eq 'live') {
        $c->add_bc('Instant Answers', $c->chained_uri('InstantAnswer','index'));
    } elsif ($dev_milestone eq 'deprecated') {
        $c->add_bc('IA Pages Overview', $c->chained_uri('InstantAnswer','overview'));
        $c->add_bc('Deprecated', $c->chained_uri('InstantAnswer','deprecated'));
    } else {
        $c->add_bc('IA Pages Overview', $c->chained_uri('InstantAnswer','overview'));
        $c->add_bc('Dev Pipeline', $c->chained_uri('InstantAnswer','dev_pipeline'));
    }
    $c->add_bc($c->stash->{ia}->name);
}

sub ia_json :Chained('ia_base') :PathPart('json') :Args(0) {
    my ( $self, $c) = @_;

    my $ia = $c->stash->{ia};
    my $edited;
    my @issues = $c->d->rs('InstantAnswer::Issues')->search({instant_answer_id => $ia->id},{order_by => {'-desc' => 'date'}});
    my @ia_issues;
    my %pull_request;
    my @ia_pr;
    my %ia_data;
    my $permissions;
    my $is_admin;
    my $dev_milestone = $ia->dev_milestone; 

    $ia_data{live} = $ia->TO_JSON;

    my $resp = beta_req();
    
    for my $issue (@issues) {
        if ($issue) {
            if ($issue->is_pr) {
               %pull_request = (
                    id => $issue->issue_id,
                    title => $issue->title,
                    body => $issue->body,
                    tags => $issue->tags,
                    author => $issue->author,
                    status => $issue->status? $issue->status : undef,
                    date => $issue->date
               );

               $ia_data{live}->{pr} = \%pull_request;

               if ($resp) {
                   my $pr_id = $pull_request{id};
                   my $repo = $ia->repo;
                   my $beta_pr = $resp->{$repo}->{$pr_id};
                   $ia_data{live}->{beta_install} = 0;

                   if ($beta_pr) {
                       $ia_data{live}->{beta_install} = $beta_pr->{install_status};
                       $ia_data{live}->{beta_query} = $beta_pr->{meta}? $beta_pr->{meta}->{example_query} : 0;
                   }
               }
            } elsif ($issue->status eq 'open') {
                push(@ia_issues, {
                    issue_id => $issue->issue_id,
                    title => $issue->title,
                    body => $issue->body,
                    tags => $issue->tags,
                    author => $issue->author,
                    status => $issue->status? $issue->status : undef,
                    date => $issue->date
                });
            }
        }
    }

    my $other_queries = $ia->other_queries? from_json($ia->other_queries) : undef;

    warn Dumper $ia->TO_JSON if debug;
    
    $ia_data{live}->{issues} = \@ia_issues;
    
    if ($c->user) {
        $permissions = $c->stash->{ia}->users->find($c->user->id);
        $is_admin = $c->user->admin;

        if (($is_admin || $permissions) && ($ia->dev_milestone eq 'live' || $ia->dev_milestone eq 'deprecated')) {
            $edited = current_ia($c->d, $ia);
            $ia_data{edited} = $edited;
            my $is_dev = 0;

            foreach my $dev (@{$ia_data{live}->{developer}}) {
                $dev->{name} =~ s/.*\/([^\/]*)$/$1/;
                if (($dev->{name} eq $c->user->username) && ($dev->{type} eq 'duck.co')) {
                    $is_dev = 1;
                }
            }
            
            if ($is_dev || $is_admin) {
                my $today = DateTime->today();
                my $month_ago = $today->clone->subtract( days => 30 )->date();
                my $traffic_rs = $c->d->rs('InstantAnswer::Traffic')->search(
                    {
                        answer_id => $ia->meta_id, 
                        date => { '<' => $today->date()}, 
                        date => { '>' => $month_ago},
                        pixel_type => [{ '=' => 'iaoi'}]
                    });
                
                my $iaoi = $traffic_rs->get_array_by_pixel();
                $ia_data{live}->{traffic} = $iaoi;
            }
        }
    }

    my $server = "http://beta.duckduckgo.com/install?asana&ia=" . $ia->id;
    my $result = asana_req('', $server);

    try{
        $ia_data{live}->{asana} = $result->decoded_content ? from_json($result->decoded_content) : undef;
        $ia_data{live}->{asana} = $ia_data{live}->{asana}? $ia_data{live}->{asana}->{$ia->id} : undef;
    };

    $c->stash->{x} = \%ia_data;

    $c->stash->{not_last_url} = 1;
    $c->forward($c->view('JSON'));
}

sub ia  :Chained('ia_base') :PathPart('') :Args(0) {
    my ( $self, $c ) = @_;
}

sub commit_base :Chained('base') :PathPart('commit') :CaptureArgs(1) {
    my ( $self, $c, $answer_id ) = @_;

    $c->stash->{ia} = $c->d->rs('InstantAnswer')->find({meta_id => $answer_id});
    $c->stash->{ia_page} = "IAPageCommit";
}

sub commit :Chained('commit_base') :PathPart('') :Args(0) {
    my ( $self, $c ) = @_;
}

sub commit_json :Chained('commit_base') :PathPart('json') :Args(0) {
    my ( $self, $c ) = @_;

    my $ia = $c->stash->{ia};
    my $edited = current_ia($c->d, $ia);
    my $original;
    my $is_admin;
    
    if ($c->user) {
        $is_admin = $c->user->admin;
    }

    if ( keys $edited && $is_admin) {    
        $original = $ia->TO_JSON;
        $edited->{original} = $original;
        $c->stash->{x} = $edited;
    } else {
        $c->stash->{x} = {redirect => 1};
    }

    $c->stash->{not_last_url} = 1;
    $c->forward($c->view('JSON'));
}

sub commit_save :Chained('commit_base') :PathPart('save') :Args(0) {
    my ( $self, $c ) = @_;

    my $is_admin;
    my $result = '';

    if ($c->user) {
        my $is_admin = $c->user->admin;
        if ($is_admin) {
            # get the IA 
            my $ia = $c->d->rs('InstantAnswer')->find({meta_id => $c->req->params->{id}});
            my $params = from_json($c->req->params->{values});
            $result = save($c, $params, $ia);
        }
    }

    $c->stash->{x} = {
        result => $result,
    };

    $c->stash->{not_last_url} = 1;
    return $c->forward($c->view('JSON'));
}

# Install the data on the beta server
# Data is an hash of arrays
# {goodies: [#pr1, #pr2, #pr3], spice: [#pr1, #pr2] ... and so on
sub send_to_beta :Chained('base') :PathPart('send_to_beta') :Args(0) {
    my ( $self, $c ) = @_;
    
    my $ua = LWP::UserAgent->new;

    my $result = '';
    $c->stash->{x}->{result} = $result;
    return $c->forward($c->view('JSON')) unless ($c->req->params->{data} && $c->user && $c->user->admin);

    my $server = "http://beta.duckduckgo.com/install";
    my $key = $ENV{'BETA_KEY'};
    my $decoded_data = from_json($c->req->params->{data});

    for my $data (@{$decoded_data}) {
        my $req = HTTP::Request->new(GET => $server);
        my $header_data = "sha1=".Digest::SHA::hmac_sha1_hex(to_json($data), $key);
        
        $req->header('content-type' => 'application/json');
        $req->header("x-hub-signature" => $header_data);
        $req->content(to_json($data));

        my $resp = $ua->request($req);
        
        $result = $resp->is_success? 1 : 0;
        $c->stash->{x}->{result} = $result;
    }

    return $c->forward($c->view('JSON'));
}

sub asana :Chained('base') :PathPart('asana') :Args(0) {
    my ($self, $c) = @_;

    my @ia = $c->d->rs('InstantAnswer')->search(
        {meta_id => $c->req->params->{id}},
        {
            prefetch => qw/issues/,
            result_class => 'DBIx::Class::ResultClass::HashRefInflator',
        }
    );
    my $ia = $ia[0];

    my $pr;
    foreach my $issue (@{$ia->{issues}}){
        if($issue->{is_pr}){
            $pr = $issue;
        }
    }

    $c->stash->{x}->{result} = '';
    return $c->forward($c->view('JSON')) unless ($ia && $c->user && $c->user->admin);

    my %data = (
          repo      => $ia->{repo},
          user      => $c->user->username,
          producer  => $ia->{producer},
          action    => 'duckco',
          number    => $pr->{issue_id},
          id        => $c->req->params->{id},
          title     => $pr->{title},
    );

    my $server = "http://beta.duckduckgo.com/install?asana";

    my $result = asana_req(\%data, $server);
    try{
        $result = $result->decoded_content;
    }
    catch{
        $result = {};
    };

    $c->stash->{x}->{result} = $result->decoded_content;
    return $c->forward($c->view('JSON'));
}

sub asana_req {
    my ($data, $server) = @_;

    if(!$data){
        $data = { stuff => "nothing"};
    }

    my $ua = LWP::UserAgent->new;
    my $json_data = $data? to_json($data) : '';

    my $key = $ENV{'BETA_KEY'};
    my $req = HTTP::Request->new(GET => $server);
    my $header_data = "sha1=".Digest::SHA::hmac_sha1_hex($json_data, $key);

    $req->header('content-type' => 'application/json');
    $req->header("x-hub-signature" => $header_data);
    $req->content($json_data);

    my $result;
    try{
        $result = $ua->request($req);
    };

    return $result;
}

sub beta_req {
    my ($self) = @_;

    my $ua = LWP::UserAgent->new;
    my $server = "http://beta.duckduckgo.com/installed.json";
    my $req = HTTP::Request->new(GET => $server);

    my $resp;
    try {
        $resp = $ua->request($req);
        $resp = $resp->decoded_content? from_json($resp->decoded_content) : undef;
    };

    return $resp;
}

# Save values for multiple IAs at once (just one field for each IA).
# This is used only in the dev pipeline and for now it's only available to admins
sub save_multiple :Chained('base') :PathPart('save_multiple') :Args(0) {
    my ( $self, $c ) = @_;

    my %result;
    $c->stash->{x}->{result} = '';
    return $c->forward($c->view('JSON')) unless ($c->req->params->{ias} && $c->user && $c->user->admin);
    my $ias = from_json($c->req->params->{ias});
    my $field = $c->req->params->{field};
    my $value = $c->req->params->{value};

    if ($field eq 'producer'){
        my $complat_user = $c->d->rs('User')->find({username => $value});
        my $complat_user_admin = $complat_user? $complat_user->admin : '';
        return $c->forward($c->view('JSON')) unless $complat_user_admin || $value eq '';
    }

    for my $id (@{$ias}) {
        my $ia = $c->d->rs('InstantAnswer')->find({meta_id => $id});

        return $c->forward($c->view('JSON')) unless $ia;

        my $edits = add_edit($c, $ia, $field, $value);
        my @update;
        
        push(@update, {value => $value, field => $field});
        save($c, \@update, $ia);
        save_milestone_date($ia, $value);

        $result{$id} = 1;
    }

    $c->stash->{x}->{result} = \%result;
    $c->forward($c->view('JSON'));
}

sub save_edit :Chained('base') :PathPart('save') :Args(0) {
    my ( $self, $c ) = @_;
    my $ia = $c->d->rs('InstantAnswer')->find({meta_id => $c->req->params->{id}});
    
    unless ($ia) {
        return '';
    }
    
    my $ia_data = $ia->TO_JSON;
    my $permissions;
    my $is_admin = 0;
    my $saved = 0;
    my $field = $c->req->params->{field};
    my $msg = "";

    # if the update fails because of invalid values
    # we still return some info
    # so the handlebars can be updated accordingly
    my $result = {
        is_admin => $is_admin, 
        saved => $saved,
        msg => $msg
    };

    $c->stash->{x} = {
        result => $result
    };

    $c->stash->{not_last_url} = 1;

    if ($c->user) {
       $permissions = $ia->users->find($c->user->id);
       $is_admin = $c->user->admin;

        if ($permissions || $is_admin) {
            $result->{is_admin} = $is_admin;
            $c->stash->{x}->{result} = $result;

            my $value = $c->req->params->{value};
            my $autocommit = $c->req->params->{autocommit};
            my $complat_user = $c->d->rs('User')->find({username => $value});
            my $complat_user_admin = $complat_user? $complat_user->admin : '';
            
            # developers can be any complat user
            if ($field eq "developer") {
                my @devs = $value? from_json($value) : undef;
                my @result_devs;

                if (@devs) {
                    for my $dev (@{$devs[0]}) {
                        my $temp_username = $dev->{username};
                        my $temp_type = $dev->{type};
                        my $temp_fullname = $dev->{name} || $temp_username;
                        my $temp_url;

                        if ($temp_type eq 'duck.co') {
                            $complat_user = $c->d->rs('User')->find({username => $temp_username});
                            return $c->forward($c->view('JSON')) unless $complat_user;

                            $temp_url = 'https://duck.co/user/'.$temp_username;
                        } elsif ($temp_type eq 'github') {
                            return $c->forward($c->view('JSON')) unless check_github($temp_username);

                            $temp_url = 'https://github.com/'.$temp_username;
                        } elsif ($temp_type eq 'ddg') {
                            #IA was developed internally - set default values
                            $temp_fullname = "DuckDuckGo";
                            $temp_url = "http://www.duckduckhack.com";
                        } else {
                            # Type is 'legacy', so the username contains the url to 
                            # a personal website or twitter account etc,
                            # meaning we can't check for validity, so we save it as it is
                            $temp_url = $temp_username;
                        }

                        my %temp_dev = (
                            name => $temp_fullname,
                            type => $temp_type,
                            url => $temp_url
                        );

                        push @result_devs, \%temp_dev;
                    }

                    $value = to_json \@result_devs;

                    print $value;
                }
            }

            my $new_meta_id;

            if ($field =~ /designer|producer/){
                return $c->forward($c->view('JSON')) unless $complat_user_admin || $value eq '';
            } elsif ($field eq "id") {
                $field = "meta_id";
                $value = format_id($value);
                
                if (!$value) {
                    $msg = "ID can't be empty";
                    $c->stash->{x}->{result}->{msg} = $msg;
                    return $c->forward($c->view('JSON'));
                } elsif ($c->d->rs('InstantAnswer')->find({meta_id => $value}) || $value eq '') {
                    $msg = "ID already in use";
                    $c->stash->{x}->{result}->{msg} = $msg;
                    return $c->forward($c->view('JSON'));
                }
            } elsif ($field eq "dev_milestone" && $value eq "ghosted") {
                # by changing the meta_id we allow the former one to be used again for
                # other IA Pages
                $new_meta_id = $ia->meta_id . "_ghosted_" . $c->d->uuid->create_str;
                my $meta_id_edit = add_edit($c, $ia, "meta_id", $new_meta_id);
            } elsif ($field eq "src_id") {
                if ($c->d->rs('InstantAnswer')->find({src_id => $value})) {
                    $msg = "ID already in use";
                    $c->stash->{x}->{result}->{msg} = $msg;
                    return $c->forward($c->view('JSON'));
                }
            } elsif (($field eq "blockgroup") && ($value eq "")) {
                $value = undef;
            }

            my $edits = add_edit($c, $ia,  $field, $value);
            my $staged = defined $edits? 1 : 0;

            if($autocommit){
                my $params = $c->req->params;
                my $tmp_val;
                my @update;

                # do stuff here to format developer for saving
                if($field eq 'developer'){
                    $tmp_val= $value;
                }

                if ($field eq 'topic'){
                    $tmp_val = from_json($c->req->params->{value});
                }

                push(@update, {value => $tmp_val // $value, field => $field} );
                
                if ($field eq "dev_milestone" && $value eq "ghosted" && $new_meta_id) {
                    push(@update, {value => $new_meta_id, field => "meta_id"} );
                    # we send only the meta_id field and value in the response to the front-end
                    # so the page will be reloaded using the new meta_id
                    $field = "id";
                    $value = $new_meta_id;
                }
                
                save($c, \@update, $ia);
                $saved = 1;
                
                save_milestone_date($ia, $c->req->params->{value});
            }

            if ($field eq "meta_id") {
                $field = "id";
            }

            $result = {$field => $value, is_admin => $is_admin, saved => $saved, staged => $staged};
        }
    }

    $c->stash->{x}->{result} = $result;

    return $c->forward($c->view('JSON'));
}

sub usercheck :Chained('base') :PathPart('usercheck') :Args() {
    my ( $self, $c ) = @_;

    my $username = $c->req->params->{username};
    my $type = $c->req->params->{type};
    my $result = 0;

    if ($type eq 'github') {
        if (check_github($username)) {
            $result = 1;
        }
    } else {
        my $user = $c->d->rs('User')->find({username => $username});
        if ($user) {
            $result = 1;
        }
    }

    $c->stash->{x}->{result} = $result;
    return $c->forward($c->view('JSON'));
}

sub new_ia :Chained('base') :PathPart('new_ia') :Args() {
    my ( $self, $c ) = @_;

    $c->stash->{ia_page} = "IAPageNew";
    $c->stash->{result} = 1;
    $c->stash->{title} = "Create New Instant Answer";
}

sub create_ia :Chained('base') :PathPart('create') :Args() {
    my ( $self, $c ) = @_;

    my $is_admin;
    my $result = '';
    my $data = $c->req->params->{data}? from_json($c->req->params->{data}) : "";
    use Data::Dumper;
    print Dumper $c->req->params;
    my $meta_id = format_id($data->{id});
    warn $meta_id;
    my $ia = $c->d->rs('InstantAnswer')->find({id => $meta_id}) || $c->d->rs('InstantAnswer')->find({meta_id => $meta_id});

    if ($c->user && (!$ia)) {
        $is_admin = $c->user->admin;
        my $dev_milestone = $data->{dev_milestone}? $data->{dev_milestone} : "planning";
        my $name = $data->{name};
        my $repo = $data->{repo}? lc $data->{repo} : undef;
        my $other_queries = $data->{other_queries}? from_json($data->{other_queries}) : [];

        # Capitalize each word in the name string
        $name =~ s/([\w']+)/\u\L$1/g;
        
        if (length $meta_id) { 
            my $new_ia = $c->d->rs('InstantAnswer')->create({
                id => $meta_id,
                meta_id => $meta_id,
                name => $name,
                dev_milestone => $dev_milestone,
                description => $data->{description},
                repo => $repo,
                src_url => $data->{src_url},
                example_query => $data->{example_query},
                other_queries => $data->{other_queries}
            });

            save_milestone_date($new_ia, 'created');

            if (!$is_admin) {
                $new_ia->add_to_users($c->user);
            }

            $result = 1;
        }
    }

    $c->stash->{x} = {
        result => $result,
        id => $meta_id
    };

    $c->stash->{not_last_url} = 1;
    return $c->forward($c->view('JSON'));
}

sub create_ia_from_pr :Chained('base') :PathPart('create_from_pr') :Args() {
    my ( $self, $c ) = @_;
    my $url = $c->req->params->{pr};
    my ($id, $result) = '';
    my $user = $c->user;

    if ($user) {
        if(my ($repo, $pr_number) = $url =~ /https?:\/\/github.com\/duckduckgo\/zeroclickinfo-(.+)\/pull\/(.+)$/){
            # get data form this pr
            my $token = $ENV{DDGC_GITHUB_TOKEN} || $ENV{DDG_GITHUB_BASIC_OAUTH_TOKEN};
            my $gh = Net::GitHub->new(access_token => $token);
            $gh->set_default_user_repo('duckduckgo', "zeroclickinfo-$repo");

            my @files = $gh->pull_request->files($pr_number);
            my $pr_data = $gh->pull_request->pull($pr_number);

                # spice
            if($repo =~ /spice/i){
                foreach my $file (@files){
                    ($id) = $file->{patch} =~ /id:\s?(?:'|")(.+)(?:'|")/;
                    last if $id;
                }
            }
            elsif( $repo =~ /goodie/i ){
                # check for cheat sheets
                my $is_cheatsheet;
                my $cheat_sheet_json;

                foreach my $file (@files){
                    ($is_cheatsheet) = $file->{filename} =~ /cheat_sheets\/json/;
                    $cheat_sheet_json = $file->{patch};
                    last if $is_cheatsheet;
                }

                # cheat sheets
                if($is_cheatsheet){
                    ($id) = $cheat_sheet_json =~ /(?:'|")id(?:'|"):\s?(?:'|")(.+)(?:'|"),/;
                }else{
                    # find from perl module
                    foreach my $file (@files){
                        my $tmp_repo = $repo;
                        $tmp_repo =~ s/s$//;
                        ($id) = $file->{filename} =~ /lib\/DDG\/$tmp_repo\/(.+)\.pm/i;
                        last if $id;
                    }
                }

            }

            if($id){
                my $ia = $c->d->rs('InstantAnswer')->find({id => $id}) || $c->d->rs('InstantAnswer')->find({meta_id => $id});

                if (!$ia) {
                    $result = 1;

                    my $new_ia = $c->d->rs('InstantAnswer')->update_or_create({
                        id => $id,
                        meta_id => $id,
                        name => $id,
                        repo => $repo,
                        dev_milestone => 'planning'
                    });

                    $c->d->rs('InstantAnswer::Issues')->update_or_create({
                        instant_answer_id => $id,
                        repo => $repo,
                        issue_id => $pr_number,
                        is_pr => 1,
                        tags => {},
                    });

                    # update first comment with link to IA page
                    my $has_link = $pr_data->{body} =~ /https?:\/\/duck.co\/ia\/view\/.+$/;

                    if(!$has_link){
                        $gh->pull_request->update_pull($pr_number, {
                                body => "$pr_data->{body}\n---\nhttps://duck.co/ia/view/$id"
                                });
                    }

                    if (!$user->admin) {
                        $new_ia->add_to_users($user);
                    }
                }
            }
        }
    }
    
    $c->stash->{x} = {
        result => $result,
        id => $id
    };

    $c->stash->{not_last_url} = 1;
    return $c->forward($c->view('JSON'));
}

sub format_id {
    my( $id ) = @_;

    # id must be lowercase and without weird chars
    $id = lc $id;
    $id =~ s/[^a-z0-9]+/_/g;
    $id =~ s/^[^a-zA-Z]+//;
    $id =~ s/_$//;

    # make the id string empty if it only contains non-alphabetic chars
    $id =~ s/^[^a-zA-Z]+$//;

    return $id;
}

sub save {
    my($c, $params, $ia) = @_;
    my %result;
    my $saved;

    for my $param (@$params) {
            my $field = $param->{field};
            my $value = $param->{value};

        if ($field eq "topic") {
            my @topic_values = $value;
            $ia->instant_answer_topics->delete;
           
            if (scalar @{$topic_values[0]} gt 0) {
                for my $topic (@{$topic_values[0]}) {
                    $saved = add_topic($c, $ia, $topic);
                    return unless $saved;
                }
            } else {
                remove_edits($c->d, $ia, 'topic');
                $saved = 1;
            }
        } else {          
            if ($field eq 'id') {
               $field = 'meta_id';
            }
            
            commit_edit($c->d, $ia, $field, $value);
            $saved = '1';
        }
    }

    %result = (
        saved => $saved,
        id => $ia->meta_id
    );

    return \%result; 
}

# Return a hash with the latest edits for the given IA
sub current_ia {
    my ($d, $ia) = @_;

    my %combined_edits;
  
    # get all edits
    my @edits = get_all_edits($d, $ia->id);
    return {} unless @edits;

    # combine all edits into a single hash
    foreach my $edit (@edits){
        my $value = $edit->value;
        $value = from_json($value);

        # if field is an aray then push new
        # values to it
        if($value->{field} eq 'ARRAY'){
            if(exists $combined_edits{$edit->field}){
                my @merged_arr = (@{$combined_edits{$edit->field}}, @{$value->{field}});
                $combined_edits{$edit->field} = @merged_arr;
            }
            else {
                $combined_edits{$edit->field} = $value->{field};
            }
        }
        elsif ($edit->field eq 'meta_id') {
            $combined_edits{id} = $value->{field};
        } else {
            $combined_edits{$edit->field} = $value->{field};
        }
    }
    return \%combined_edits;
}

# given result set, field, and value. Add a new hash
# to the updates array
# return the updated array to add to the database
sub add_edit {
    my ($c, $ia, $field, $value) = @_;
    warn Dumper("Field: $field, value $value") if debug;
    my $column_data = $ia->column_info($field);
    $value = from_json($value) if $column_data->{is_json} || $field eq 'topic';
    
    $c->d->rs('InstantAnswer::Updates')->create({
                instant_answer_id => $ia->id,
                field => $field,
                value => to_json({field => $value}),
                timestamp => time
    });    
}

sub user_contributed {
    my ($user) = @_;

    $user->update({'new_contributor' => 0});
}

sub check_github {
    my ($username) = @_;

    my $result = 0;
    my $token = $ENV{DDGC_GITHUB_TOKEN} || $ENV{DDG_GITHUB_BASIC_OAUTH_TOKEN};
    my $gh = Net::GitHub->new(access_token => $token);

    try {
        my $user_info = $gh->user->show($username);

        if ($user_info) {
            return 1;
        } else {
            return 0;
        }
    } catch {
        return 0;
    };
}

sub add_topic {
    my ($c, $ia, $topic) = @_;
    my $topic_id = $c->d->rs('Topic')->find({name => $topic});
    try {
        $ia->add_to_topics($topic_id);
        remove_edits($c->d, $ia, 'topic');
    } catch {
        $c->d->errorlog("Error updating the database ... $@");
        return 0;
    };
    return 1;
}

# commits a single edit to the database
# removes that entry from the updates column
sub commit_edit {
    my ($d, $ia, $field, $value) = @_;
    # update the IA data in Instant Answer table
    my $update_field = $field eq 'id'? 'meta_id' : $field;
    update_ia($ia, $update_field, $value);
    # remove the edit from the updates table
    remove_edits($d, $ia, $field);
}

# given a result set and a field name, remove all the
# entries for that field from the updates column
sub remove_edit {
    my($ia, $field) = @_;   

    my $updates = ();
    my $column_updates = $ia->get_column('updates');
    my $edits = $column_updates? from_json($column_updates) : undef;
    $edits->{$field} = undef;
                      
    $ia->update({updates => $edits});
}

# update the Instant Answer table
sub update_ia {
    my ($ia, $field, $value) = @_;
    $ia->update({$field => $value});
}

# given a result set and a field name, remove all the
# entries for that field from the updates column
sub remove_edits {
    my($d, $ia, $field) = @_;   
    # delete all entries from updates with field
    my $edits = $d->rs('InstantAnswer::Updates')->search({ instant_answer_id => $ia->id, field => $field });
    $edits->delete();
}

# given the IA name return a result set of all edits
sub get_all_edits {
    my ($d, $id) = @_;
    warn "Getting edits for $id" if debug;
    my @edits = $d->rs('InstantAnswer::Updates')->search( {instant_answer_id => $id} );
    warn "Returning ", scalar @edits if debug;
    return @edits;
}

sub save_milestone_date {
    my ($ia, $milestone) = @_;
    my %milestones = (
        'development' => 'dev_date',
        'live' => 'live_date',
        'created' => 'created_date'
    );

    my $field = $milestones{$milestone};
    return unless $field;
    
    my @time = localtime(time);
    my $date = "$time[4]/$time[3]/".($time[5]+1900);
    update_ia($ia, $field, $date);

    update_ia($ia, 'test_machine', undef) if ($milestone eq 'live');
}

no Moose;
__PACKAGE__->meta->make_immutable;

