package DDGC::Web::Controller::InstantAnswer;
# ABSTRACT: Instant Answer Pages
use Moose;
use namespace::autoclean;
use Try::Tiny;
use Time::Local;
use JSON;
use Net::GitHub::V3;

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

    # @{$c->stash->{ialist}} = $c->d->rs('InstantAnswer')->all();
}

sub ialist_json :Chained('base') :PathPart('json') :Args() {
    my ( $self, $c ) = @_;

    my $rs = $c->d->rs('InstantAnswer');

    my @ial = $rs->search(
        {'topic.name' => [{ '!=' => 'test' }, { '=' => undef}],
         'me.dev_milestone' => { '=' => 'live'},
        },
        {
            columns => [ qw/ name repo src_name dev_milestone description template /, {id => 'meta_id'} ],
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
    my @x = $c->d->rs('InstantAnswer')->search({
        repo => $repo,
        -or => [{dev_milestone => 'live'},
        {dev_milestone => 'development'},
        {dev_milestone => 'testing'},
        {dev_milestone => 'complete'}]
    });

    my %iah;
    for my $ia (@x) {
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
    @ias = $rs->search({'dev_milestone' => { '=' => ['planning', 'development', 'testing', 'complete']}});
    $key = 'dev_milestone';

    my %dev_ias;
    my $temp_ia;
    for my $ia (@ias) {
        $temp_ia = $ia->TO_JSON('pipeline');
        
        if ($c->user && (!$c->user->admin)) {
            my $can_edit = $ia->users->find($c->user->id)? 1 : undef;
            $temp_ia->{"can_edit"} = $can_edit;
        }
        
        push @{$dev_ias{$ia->$key}}, $temp_ia;
    }

    $c->stash->{x} = {
        $key.'s' => \%dev_ias
    };

    $c->stash->{not_last_url} = 1;
    $c->forward($c->view('JSON'));
}

sub deprecated_base :Chained('overview_base') :PathPart('deprecated') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
    
    $c->stash->{ia_page} = "IADeprecated";
    $c->stash->{title} = "Deprecated IA Pages";
   
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
    @ias = $rs->search({'dev_milestone' => { '=' => 'deprecated'}});
    $key = 'repo';

    my %dev_ias;
    my $temp_ia;
    for my $ia (@ias) {
        $temp_ia = $ia->TO_JSON('pipeline');
        push @{$dev_ias{$ia->$key}}, $temp_ia;
    }

    $c->stash->{x} = {
        $key.'s' => \%dev_ias
    };

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
    my @result = $rs->search({'is_pr' => 0},{order_by => { -desc => 'date'}})->all;
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
                    repo => $issue->repo
            );

            push @issues_by_date, \%temp_issue;

            if (defined $ial{$id}) {
                my @existing_issues = @{$ial{$id}->{issues}};
                push @existing_issues, \%temp_issue;

                $ial{$id}->{issues} = \@existing_issues;
            } else {
                push @issues, \%temp_issue;;

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
    
    $c->add_bc('IA Pages Home', $c->chained_uri('InstantAnswer','overview'));
}

sub overview_json :Chained('overview_base') :PathPart('json') :Args(0) {
     my ( $self, $c ) = @_;

     my @ias;
     my @live_ias;
     my @dev_ias;
     my $rs = $c->d->rs('InstantAnswer');
     my $dev_count = $rs->search({'dev_milestone' => { '=' => ['planning', 'development', 'testing', 'complete']}})->count;
     my $live_count = $rs->search({
             dev_milestone => 'live', 
             'topic.name' => [{ '!=' => 'test' }, { '=' => undef}]
         },
         {   prefetch => { instant_answer_topics => 'topic' }
         })->count;

     if ($c->user) {
        @ias = $rs->search({dev_milestone => {'!=' => 'deprecated'}},{order_by => 'name'})->all;
        
        my $temp_ia;
        for my $ia (@ias) {
            $temp_ia = $ia->TO_JSON('pipeline');
            $temp_ia->{producer} = $temp_ia->{producer} || '';
            $temp_ia->{designer} = $temp_ia->{designer} || '';
            $temp_ia->{developer} = $temp_ia->{developer} || '';

            my $username = $c->user->username;
            my $is_mine = ($c->user->admin && ($temp_ia->{producer} eq $username || $temp_ia->{designer} eq $username))? 1 : 0;

            if (!$is_mine && ref($temp_ia->{developer}) eq 'ARRAY') {
                for my $dev (@{$temp_ia->{developer}}) {
                    if (ref($dev) eq 'HASH' && $dev->{name} eq $username) {
                        $is_mine = 1;
                    }
                }
            }

            if ($is_mine) {
                $temp_ia->{edits} = scalar get_all_edits($c->d, $temp_ia->{id});
                $temp_ia->{issues} = $c->d->rs('InstantAnswer::Issues')->search({is_pr => 0, instant_answer_id => $temp_ia->{id}})->count eq '0'? 0 : 1;

                if ($temp_ia->{dev_milestone} eq 'live') {
                    push @live_ias, $temp_ia;
                } else {
                    push @dev_ias, $temp_ia;
                }
            }
        }
     } 
     
     if (!$c->user || !@live_ias) {
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
     }

     if (!$c->user || !@dev_ias) {
        @ias = $rs->search({
                dev_milestone => { '=' => ['planning', 'development', 'testing', 'complete']},
                created_date => { '!=' => undef }
            },{
                rows => 5,  
                order_by => {-desc => 'created_date'}
            })->all;

        my $temp_ia;
        for my $ia (@ias) {
            $temp_ia = $ia->TO_JSON('pipeline');
            $temp_ia->{most_recent} = 1;
            push @dev_ias, $temp_ia;
        }
     }

     my @issues = $c->d->rs('InstantAnswer::Issues')->search({'is_pr' => 0},{order_by => {-desc => 'date'}})->all;

     my @bugs;
     my @high_p;
     my @lhf;

     for my $issue (@issues) {
        my %temp_issue = (
            title => $issue->title,
            body => $issue->body,
            date => $issue->date,
            issue_id => $issue->issue_id,
            ia_id => $issue->instant_answer_id,
            repo => $issue->repo,
            author => $issue->author
        );

        my @temp_tags;
        my $is_highp = 0;
        my $is_bug = 0;
        my $is_lhf = 0;

        my $issue_ia = $c->d->rs('InstantAnswer')->find($issue->instant_answer_id);

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
     }


     my %top_issues = (
         bugs => { name => "Bugs", list => \@bugs },
         high_p => { name => "Priority: High", list => \@high_p },
         lhf => { name => "Low-Hanging Fruit", list => \@lhf }
     );

     my %ias = (
         live => { count => $live_count, list => \@live_ias },
         new => { count => $dev_count, list => \@dev_ias }
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

    if ($c->user) {
        $permissions = $ia->users->find($c->user->id);
        $is_admin = $c->user->admin;

        if ($permissions || $is_admin) {
            $can_edit = 1;

            if ($is_admin) {
                my @edits = get_all_edits($c->d, $answer_id);
                $can_commit = 1;
                $commit_class = '' if @edits;
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
    
    for my $issue (@issues) {
        if ($issue) {
            if ($issue->is_pr) {
               %pull_request = (
                    id => $issue->issue_id,
                    title => $issue->title,
                    body => $issue->body,
                    tags => $issue->tags,
                    author => $issue->author,
                    date => $issue->date
               );

               $ia_data{live}->{pr} = \%pull_request;
                } else {
                push(@ia_issues, {
                    issue_id => $issue->issue_id,
                    title => $issue->title,
                    body => $issue->body,
                    tags => $issue->tags,
                    author => $issue->author,
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
        }
    }

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

    # if the update fails because of invalid values
    # we still return some info
    # so the handlebars can be updated accordingly
    my $result = {
        is_admin => $is_admin, 
        saved => $saved
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

            if ($field =~ /designer|producer/){
                return $c->forward($c->view('JSON')) unless $complat_user_admin || $value eq '';
            } elsif ($field eq "id") {
                $field = "meta_id";
                $value = format_id($value);
                return $c->forward($c->view('JSON')) if ($c->d->rs('InstantAnswer')->find({meta_id => $value}) || $value eq '');
            } elsif ($field eq "src_id") {
                return $c->forward($c->view('JSON')) if $c->d->rs('InstantAnswer')->find({src_id => $value});
            }

            my $edits = add_edit($c, $ia,  $field, $value);

            if($autocommit){
                my $params = $c->req->params;
                my $tmp_val;
                my @update;

                # do stuff here to format developer for saving
                if($field eq 'developer'){
                    $tmp_val= $value;
                }

                if($field eq 'topic'){
                    $tmp_val = from_json($c->req->params->{value});
                }

                push(@update, {value => $tmp_val // $value, field => $field} );
                save($c, \@update, $ia);
                $saved = 1;
                
                save_milestone_date($ia, $c->req->params->{value});
            }

            if ($field eq "meta_id") {
                $field = "id";
            }

            $result = {$field => $value, is_admin => $is_admin, saved => $saved};
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

sub create_ia :Chained('base') :PathPart('create') :Args() {
    my ( $self, $c ) = @_;

    my $ia = $c->d->rs('InstantAnswer')->find({id => lc($c->req->params->{id})}) || $c->d->rs('InstantAnswer')->find({meta_id => lc($c->req->params->{id})});
    my $is_admin;
    my $result = '';
    my $id = '';

    if ($c->user && (!$ia)) {
       $is_admin = $c->user->admin;

        if ($is_admin) {
            my $dev_milestone = $c->req->params->{dev_milestone};
            my $status = $dev_milestone;

            $id = format_id($c->req->params->{id});
           
            if (length $id) { 
                my $new_ia = $c->d->rs('InstantAnswer')->create({
                    id => $id,
                    meta_id => $id,
                    name => $c->req->params->{name},
                    status => $status,
                    dev_milestone => $dev_milestone,
                    description => $c->req->params->{description},
                });

                save_milestone_date($new_ia, 'created');

                $result = 1;
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
    # update the IA data in instant answer table
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

# update the instant answer table
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

