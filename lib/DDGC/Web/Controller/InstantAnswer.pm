package DDGC::Web::Controller::InstantAnswer;
# ABSTRACT: Instant Answer Pages

use Data::Dumper;
use Moose;
use namespace::autoclean;
use Try::Tiny;
use Time::Local;
use JSON;

my $INST = DDGC::Config->new->appdir_path."/root/static/js";

BEGIN {extends 'Catalyst::Controller'; }

sub debug { 1 }

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
        {-or => [
            'topic.name' => { '!=' => 'test' },
            'topic' => { '=' => ''},
        ],
         -or => [
            'me.dev_milestone' => { '=' => 'live'},
            'me.dev_milestone' => { '=' => 'ready'},
         ],
        },
        {
            columns => [ qw/ name id repo src_name dev_milestone description template / ],
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
        dev_milestone => 'live',
    });

    my %iah;

IA:
    for my $ia (@x) {
        my @topics = map { $_->name} $ia->topics;

        $iah{$ia->id} = {
                name => $ia->name,
                id => $ia->id,
                attribution => $ia->attribution? from_json($ia->attribution) : undef,
                example_query => $ia->example_query,
                repo => $ia->repo,
                perl_module => $ia->perl_module,
                tab => $ia->tab,
                description => $ia->description,
                status => $ia->status,
                topic => \@topics
        };

        # fathead specific
        # TODO: do we need src_domain ?

        my $src_options = $ia->src_options;
        if ($src_options ) {
            $iah{$ia->id}{src_options} = from_json($src_options);
        }

        $iah{$ia->id}{src_id} = $ia->src_id if $ia->src_id;
    }

    $c->stash->{x} = \%iah;
    $c->stash->{not_last_url} = 1;
    $c->forward($c->view('JSON'));
}

sub queries :Chained('base') :PathPart('queries') :Args(0) {

    # my @x = $c->d->rs('InstantAnswer')->all();

}

sub dev_pipeline_redirect :Chained('base') :PathPart('pipeline') :Args(0) {
    my ( $self, $c, $view ) = @_;

    $c->res->redirect($c->chained_uri('InstantAnswer', 'dev_pipeline', 'dev'));
}

sub dev_pipeline_base :Chained('base') :PathPart('pipeline') :CaptureArgs(1) {
    my ( $self, $c, $view ) = @_;
    
    $c->stash->{view} = $view;
    $c->stash->{ia_page} = "IADevPipeline";
    $c->stash->{title} = "Dev Pipeline";
   
    if ($view eq 'dev') {
        $c->stash->{logged_in} = $c->user;
        $c->stash->{is_admin} = $c->user? $c->user->admin : 0;
    }
    
    $c->add_bc('Instant Answers', $c->chained_uri('InstantAnswer','index'));
    $c->add_bc('Dev Pipeline', $c->chained_uri('InstantAnswer', 'dev_pipeline', $view));
}

sub dev_pipeline :Chained('dev_pipeline_base') :PathPart('') :Args(0) {
    my ( $self, $c ) = @_;
    
}

sub dev_pipeline_json :Chained('dev_pipeline_base') :PathPart('json') :Args(0) {
    my ( $self, $c ) = @_;

    my $view = $c->stash->{view};
    my $rs = $c->d->rs('InstantAnswer');

    if ($view eq 'dev') {
        my @planning = $rs->search(
            {'me.dev_milestone' => { '=' => 'planning'}},
            {
                columns => [ qw/ name id dev_milestone producer designer developer/ ],
                order_by => [ qw/ name/ ],
                result_class => 'DBIx::Class::ResultClass::HashRefInflator',
            }
        )->all;

        my @in_development = $rs->search(
            {'me.dev_milestone' => { '=' => 'in_development'}},
            {
                columns => [ qw/ name id dev_milestone producer designer developer/ ],
                order_by => [ qw/ name/ ],
                result_class => 'DBIx::Class::ResultClass::HashRefInflator',
            }
        )->all;

        my @qa = $rs->search(
            {'me.dev_milestone' => { '=' => 'qa'}},
            {
                columns => [ qw/ name id dev_milestone producer designer developer/ ],
                order_by => [ qw/ name/ ],
                result_class => 'DBIx::Class::ResultClass::HashRefInflator',
            }
        )->all;

        my @ready = $rs->search(
            {'me.dev_milestone' => { '=' => 'ready'}},
            {
                columns => [ qw/ name id dev_milestone producer designer developer/ ],
                order_by => [ qw/ name/ ],
                result_class => 'DBIx::Class::ResultClass::HashRefInflator',
            }
        )->all;

        $c->stash->{x} = {
            planning => \@planning,
            in_development => \@in_development,
            qa => \@qa,
            ready => \@ready,
        };
    } elsif ($view eq 'live') {
        $rs = $c->d->rs('InstantAnswer::Issues');

        my @result = $rs->search({'is_pr' => 0})->all;

        my %ial;
        my $ia;
        my $id;
        my $dev_milestone;
        my @tags;
        my %temp_tags;

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

                if (defined $ial{$id}) {
                    my @existing_issues = @{$ial{$id}->{issues}};
                    push(@existing_issues, {
                            issue_id => $issue->issue_id,
                            title => $issue->title,
                            tags => $issue->tags
                        });

                    $ial{$id}->{issues} = \@existing_issues;
                } else {
                    push(@issues, {
                            issue_id => $issue->issue_id,
                            title => $issue->title,
                            tags => $issue->tags
                        });

                    $ial{$id}  = {
                            name => $ia->name,
                            id => $ia->id,
                            repo => $ia->repo,
                            dev_milestone => $ia->dev_milestone,
                            producer => $ia->producer,
                            designer => $ia->designer,
                            developer => $ia->developer,
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
            tags => \@tags
        };
    }

    $c->stash->{not_last_url} = 1;
    $c->forward($c->view('JSON'));
}

sub ia_base :Chained('base') :PathPart('view') :CaptureArgs(1) {  # /ia/view/calculator
    my ( $self, $c, $answer_id ) = @_;

    $c->stash->{ia_page} = "IAPage";
    $c->stash->{ia} = $c->d->rs('InstantAnswer')->find($answer_id);
    @{$c->stash->{issues}} = $c->d->rs('InstantAnswer::Issues')->search({instant_answer_id => $answer_id});    

    unless ($c->stash->{ia}) {
        $c->response->redirect($c->chained_uri('InstantAnswer','index',{ instant_answer_not_found => 1 }));
        return $c->detach;
    }

    my $permissions;
    my $is_admin;
    my $can_edit;
    my $can_commit;
    my $commit_class = "hide";
    my $ia = $c->stash->{ia};
    my $dev_milestone = $ia->dev_milestone;

    if ($c->user) {
        $permissions = $c->stash->{ia}->users->find($c->user->id);
        $is_admin = $c->user->admin;

        if ($permissions || $is_admin) {
            $can_edit = 1;

            if ($is_admin) {
                my @edits = get_all_edits($c->d, $c->stash->{ia}->id);
                $can_commit = 1;
                $commit_class = '' if @edits;
            }
        }
    }

    $c->stash->{title} = $c->stash->{ia}->name;
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
    } else {
        $c->add_bc('Dev Pipeline', $c->chained_uri('InstantAnswer','dev_pipeline', 'dev'));
    }
    $c->add_bc($c->stash->{ia}->name);
}

sub ia_json :Chained('ia_base') :PathPart('json') :Args(0) {
    my ( $self, $c) = @_;

    my $ia = $c->stash->{ia};
    my @topics = map { $_->name} $ia->topics;
    my $edited;
    my @issues = $c->d->rs('InstantAnswer::Issues')->search({instant_answer_id => $ia->id});
    my @ia_issues;
    my %pull_request;
    my @ia_pr;
    my %ia_data;
    my $permissions;
    my $is_admin;
    my $dev_milestone = $ia->dev_milestone; 

    for my $issue (@issues) {
        if ($issue) {
            if ($issue->is_pr) {
               %pull_request = (
                    id => $issue->issue_id,
                    title => $issue->title,
                    body => $issue->body,
                    tags => $issue->tags,
                    author => $issue->author
               );

               if ($dev_milestone ne 'live' && !$ia->developer) {
                  my %dev_hash = (
                      name => $pull_request{author},
                      url => 'https://github.com/'.$pull_request{author}
                  );

                  my $value = to_json \%dev_hash;

                  try {
                      $ia->update({developer => $value});
                  }
                  catch {
                      $c->d->errorlog("Error updating the database");
                  };
               }
            } else {
                push(@ia_issues, {
                    issue_id => $issue->issue_id,
                    title => $issue->title,
                    body => $issue->body,
                    tags => $issue->tags
                });
            }
        }
    }

    my $other_queries = $ia->other_queries? from_json($ia->other_queries) : undef;
warn Dumper $ia->tab;
warn Dumper $ia->TO_JSON;
    $ia_data{live} =  {
                id => $ia->id,
                name => $ia->name,
                description => $ia->description,
                tab => $ia->tab,
                status => $ia->status,
                repo => $ia->repo,
                dev_milestone => $dev_milestone,
                perl_module => $ia->perl_module,
                example_query => $ia->example_query,
                other_queries => $other_queries,
                code => $ia->code? from_json($ia->code) : undef,
                topic => \@topics,
                attribution => $ia->attribution? from_json($ia->attribution) : undef,
                issues => \@ia_issues,
                pr => \%pull_request,
                template => $ia->template,
                unsafe => $ia->unsafe,
                src_api_documentation => $ia->src_api_documentation,
                api_status_page => $ia->api_status_page,
                producer => $ia->producer,
                designer => $ia->designer,
                developer => $ia->developer? from_json($ia->developer) : undef,
                perl_dependencies => $ia->perl_dependencies? from_json($ia->perl_dependencies) : undef,
                triggers => $ia->triggers? from_json($ia->triggers) : undef,
                code_review => $ia->code_review,
                design_review => $ia->design_review,
                test_machine => $ia->test_machine,
                browsers_ie => $ia->browsers_ie,
                browsers_chrome => $ia->browsers_chrome,
                browsers_firefox => $ia->browsers_firefox,
                browsers_opera => $ia->browsers_opera,
                browsers_safari => $ia->browsers_safari,
                mobile_android => $ia->mobile_android,
                mobile_ios => $ia->mobile_ios,
                tested_relevancy => $ia->tested_relevancy,
                tested_staging => $ia->tested_staging,
                is_live => $ia->is_live,
                src_options => $ia->src_options? from_json($ia->src_options) : undef,
                answerbar => $ia->answerbar? from_json($ia->answerbar) : undef
    };

    if ($c->user) {
        $permissions = $c->stash->{ia}->users->find($c->user->id);
        $is_admin = $c->user->admin;

        if (($is_admin || $permissions) && ($ia->dev_milestone eq 'live')) {
            $edited = current_ia($c->d, $ia);
            $ia_data{edited} = {
                    name => $edited->{name},
                    description => $edited->{description},
                    status => $edited->{status},
                    example_query => $edited->{example_query},
                    other_queries => $edited->{other_queries}->{value},
                    topic => $edited->{topic},
                    dev_milestone => $edited->{dev_milestone},
                    tab => $edited->{tab},
                    producer => $edited->{producer},
                    designer => $edited->{designer},
                    developer => $edited->{developer},
                    perl_module => $edited->{perl_module},
                    template => $edited->{template},
                    repo => $edited->{repo},
                    answerbar => $edited->{answerbar},
                    src_api_documentation => $edited->{src_api_documentation},
                    api_status_page => $edited->{api_status_page},
                    src_options => $edited->{src_options},
                    unsafe => $edited->{unsafe},
                    triggers => $edited->{triggers}->{value},
                    perl_dependencies => $edited->{perl_dependencies}->{value}
            };
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

    $c->stash->{ia} = $c->d->rs('InstantAnswer')->find($answer_id);
    $c->stash->{ia_page} = "IAPageCommit";
}

sub commit :Chained('commit_base') :PathPart('') :Args(0) {
    my ( $self, $c ) = @_;
}

sub commit_json :Chained('commit_base') :PathPart('json') :Args(0) {
    my ( $self, $c ) = @_;

    my $ia = $c->stash->{ia};
    my @topics = map { $_->name} $ia->topics;
    my $edited = current_ia($c->d, $ia);
    my %original;
    my $is_admin;

    if ($c->user) {
        $is_admin = $c->user->admin;
    }

    if ($edited && $is_admin) {    
        my %original = (
            name => $ia->name,
            description => $ia->description,
            status => $ia->status,
            topic => \@topics,
            example_query => $ia->example_query,
            other_queries => $ia->other_queries? from_json($ia->other_queries) : undef,
            dev_milestone => $ia->dev_milestone,
            perl_module => $ia->perl_module,
            producer => $ia->producer,
            designer => $ia->designer,
            developer => $ia->developer? from_json($ia->developer) : undef,
            template => $ia->template,
            tab => $ia->tab,
            repo => $ia->repo,
            answerbar => $ia->answerbar,
            src_options => $ia->src_options,
            src_api_documentation => $ia->src_api_documentation,
            api_status_page => $ia->api_status_page,
            unsafe => $ia->unsafe,
            triggers => $ia->triggers? from_json($ia->triggers) : undef,
            perl_dependencies => $ia->perl_dependencies? from_json($ia->perl_dependencies) : undef
        );

        $edited->{original} = \%original;

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
            my $ia = $c->d->rs('InstantAnswer')->find($c->req->params->{id});
            my @params = from_json($c->req->params->{values});

            for my $param (@params) {
                for my $hash_param (@{$param}) {
                    my %hash = %{$hash_param};
                    my $field;
                    my $value;
                    for my $key (keys %hash) {
                        if ($key eq 'field') {
                            $field = $hash{$key};
                        } else {
                            $value = $hash{$key};
                        }
                    }
                    if ($field eq "topic") {
                        my @topic_values = $value;
                        $ia->instant_answer_topics->delete;

                        for my $topic (@{$topic_values[0]}) {
                            my $topic_id = $c->d->rs('Topic')->find({name => $topic});

                            try {
                                $ia->add_to_topics($topic_id);
                                remove_edits($c->d, $ia, $field);
                                $result = 1;
                            } catch {
                                $c->d->errorlog("Error updating the database");
                                return '';
                            };
                        }
                    } else {
                        if ($field eq "developer" && $value ne '') {
                            my %dev_hash = (
                                name => $value,
                                url => 'https://duck.co/user/'.$value
                            );

                            $value = to_json \%dev_hash;
                        }

                        try {
                            commit_edit($c->d, $ia, $field, $value);
                            $result = '1';
                        } catch {
                            $c->d->errorlog("Error updating the database");
                            return '';
                        };
                    }
                }
            } 
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

    my $ia = $c->d->rs('InstantAnswer')->find($c->req->params->{id});
    my $permissions;
    my $is_admin;
    my $result = '';

    if ($c->user) {
       $permissions = $ia->users->find($c->user->id);
       $is_admin = $c->user->admin;

        if ($permissions || $is_admin) {
            my $field = $c->req->params->{field};
            my $value = $c->req->params->{value};
            my $autocommit = $c->req->params->{autocommit};
            if ($autocommit) {
            my $saved;
            my @topics = map { $_->name} $ia->topics;
                
            if ($field eq "topic") {
                    my @topic_values = $value? from_json($value) : undef;
                    $ia->instant_answer_topics->delete;

                    for my $topic (@{$topic_values[0]}) {
                        my $topic_id = $c->d->rs('Topic')->find({name => $topic});

                        try {
                            $ia->add_to_topics($topic_id);
                        } catch {
                            $c->d->errorlog("Error updating the database");
                            return '';
                        };
                    }

                    $saved = 1;
                    @topics = map { $_->name} $ia->topics;
                } elsif ($field eq "producer" || $field eq "designer" || $field eq "developer") {
                    my $complat_user = $c->d->rs('User')->find({username => $value});

                    if ($complat_user || $value eq '') {
                        my $complat_user_admin = $complat_user? $complat_user->admin : '';

                        if ((($field eq "producer" || $field eq "designer") && ($complat_user_admin || $value eq ''))
                            || $field eq "developer") {
                            if ($field eq "developer" && $value ne '') {
                                my %dev_hash = (
                                    name => $value,
                                    url => 'https://duck.co/user/'.$value
                                );

                                $value = to_json \%dev_hash;
                            }

                            print $value;

                            try {
                                $ia->update({$field => $value});
                                
                                if ($field eq 'developer') {
                                    $value = $value? from_json($value) : undef;
                                }

                                $saved = 1;
                            }
                            catch {
                                $c->d->errorlog("Error updating the database");
                            };
                        }
                    }
                } else {
                    try {
                        $ia->update({$field => $value});
                        $saved = 1;
                    }
                    catch {
                        $c->d->errorlog("Error updating the database");
                    };
                }

                if ($field ne 'topic') {
                    $result = {
                        $field => $ia->$field,
                        saved => $saved
                    };
                } else {
                    $result = {
                        $field => to_json(\@topics),
                        saved => $saved
                    };
                }
            } else {

                warn "adding edit";
                add_edit($c, $ia, $field, $value);
                warn "edit was added";
                $result = {$field => $value, is_admin => $is_admin};

                my $can_add = 0;
                if ($field eq "producer" || $field eq "designer" || $field eq "developer") {
                    my $complat_user = $c->d->rs('User')->find({username => $value});

                    if ($complat_user || $value eq '') {
                        my $complat_user_admin = $complat_user? $complat_user->admin : '';

                        if ((($field eq "producer" || $field eq "designer") && ($complat_user_admin || $value eq ''))
                            || ($field eq "developer")) {
                            $can_add = 1;
                            if ($field eq "developer" && $value ne '') {
                                my %dev_hash = (
                                    name => $value,
                                    url => 'https://duck.co/user/'.$value
                                );

                                $value = to_json \%dev_hash;
                            }
                        }
                    }
                } else {
                    $can_add = 1;
                }
                
                if ($can_add) {   
                    my $edits = add_edit($ia,  $field, $value);
                
                    try {
                        $ia->update({updates => $edits});
                                
                        if ($field eq 'developer') {
                            $value = $value? from_json($value) : undef;
                        }
                                
                        $result = {$field => $value, is_admin => $is_admin};
                    }
                    catch {
                        $c->d->errorlog("Error updating the database");
                    };
                }
            }
        }
    }

    $c->stash->{x} = {
        result => $result,
    };

    $c->stash->{not_last_url} = 1;
    return $c->forward($c->view('JSON'));
}

sub create_ia :Chained('base') :PathPart('create') :Args() {
    my ( $self, $c ) = @_;

    my $ia = $c->d->rs('InstantAnswer')->find({lc id => $c->req->params->{id}});
    my $is_admin;
    my $result = '';

    if ($c->user && (!$ia)) {
       $is_admin = $c->user->admin;

        if ($is_admin) {
            my $dev_milestone = $c->req->params->{dev_milestone};
            my $status = $dev_milestone;
            
            if ($dev_milestone eq 'in_development') {
                $status =~ s/_/ /g;
            }

            my $new_ia = $c->d->rs('InstantAnswer')->create({
                lc id => $c->req->params->{id},
                name => $c->req->params->{name},
                status => $status,
                dev_milestone => $dev_milestone,
                description => $c->req->params->{description},
            });

            $result = 1;
        }
    }

    $c->stash->{x} = {
        result => $result,
    };

    $c->stash->{not_last_url} = 1;
    return $c->forward($c->view('JSON'));
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

        warn Dumper $value;

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
        else {
            $combined_edits{$edit->field} = $value->{field};
        }
    }

    warn Dumper \%combined_edits;

    return \%combined_edits;
}

# given result set, field, and value. Add a new hash
# to the updates array
# return the updated array to add to the database
sub add_edit {
    my ($c, $ia, $field, $value) = @_;

    #   warn "ia: $ia->id field: $field value: $value";
    $value = decode_json($value) if $field =~ /topic|other_queries/;
try{
        $c->d->rs('InstantAnswer::Updates')->create({
                instant_answer_id => $ia->id,
                field => $field,
                value => encode_json({field => $value}),
                timestamp => time
        });    
}catch {}
}

# commits a single edit to the database
# removes that entry from the updates column
sub commit_edit {
    my ($d, $ia, $field, $value) = @_;


    warn "committing edits";
    # update the IA data in instant answer table
    update_ia($d, $ia, $field, $value);

    warn "removing edits";
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
    my ($d,$ia, $field, $value) = @_;
    warn "updating IA: $ia with field: $field and value $value";
    $ia->update({$field => $value});
}

# given a result set and a field name, remove all the
# entries for that field from the updates column
sub remove_edits {
    my($d, $ia, $field) = @_;   
    # delete all entries from updates with field
    my $edits = $d->rs('InstantAnswer::Updates')->search({ instant_answer_id => $ia->id, field => $field });
    warn "Found $edits->count";
    $edits->delete();

}

# get a single edit with oldest timestamp (next edit to check)
sub get_edit {
    my ($d, $id) = @_;
    warn "Getting single edit for: $id" if debug;
    my @edit = $d->rs('InstantAnswer::Updates')->search({
        instant_answer_id => $id
    },
    {
        order_by => {-desc => 'timestamp'},
        rows => 1
    });

    warn $edit[0]->timestamp if debug;

    return $edit[0];
}

# remove all the entries from the updates column
sub remove_all_updates {
    my($ia) = @_;
    my $columns = get_all_updates($ia);
    $columns->delete;
}

# given the IA name return a result set of all edits
sub get_all_edits {
    my ($d, $id) = @_;
    warn "Getting edits for $id" if debug;
    my @edits = $d->rs('InstantAnswer::Updates')->search( {instant_answer_id => $id} );
    warn "Returning ", scalar @edits if debug;
    return @edits;
}

no Moose;
__PACKAGE__->meta->make_immutable;

