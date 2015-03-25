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
        {'topic.name' => { '!=' => 'test' },
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
    my @x = $c->d->rs('InstantAnswer')->search({repo => $repo});

    my %iah;

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
                my $edits = get_edits($c->d, $c->stash->{ia}->name);
                $can_commit = 1;

                if (length $edits && ref $edits eq 'HASH') {
                    $commit_class = '';
                }
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
                                remove_edit($ia, $field);
                                $result = 1;
                            } catch {
                                $c->d->errorlog("Error updating the database");
                                return '';
                            };
                        }
                    } else {
                        if ($field eq 'other_queries') {
                            $value = to_json($value);
                        }
                        
                        if ($field eq "developer" && $value ne '') {
                            my %dev_hash = (
                                name => $value,
                                url => 'https://duck.co/user/'.$value
                            );

                            $value = to_json \%dev_hash;
                        }

                        try {
                            commit_edit($ia, $field, $value);
                            $result = '1';
                        } catch {
                            $c->d->errorlog("Error updating the database");
                            return '';
                        };
                    }
                }
            } 

            remove_edits($ia);
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

                    $result = {$field => $value};
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
                                
                                $result = {$field => $value};
                            }
                            catch {
                                $c->d->errorlog("Error updating the database");
                            };
                        }
                    }
                } else {
                    try {
                        $ia->update({$field => $value});
                        $result = {$field => $value};
                    }
                    catch {
                        $c->d->errorlog("Error updating the database");
                    };
                }
            } else {
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

    my $edits = get_edits($d, $ia->name);

    my @name = $edits->{'name'};
    my @desc = $edits->{'description'};
    my @status = $edits->{'status'};
    my @topic = $edits->{'topic'};
    my @example_query = $edits->{'example_query'};
    my @other_queries = $edits->{'other_queries'};
    my @dev_milestone = $edits->{'dev_milestone'};
    my @producer = $edits->{'producer'};
    my @designer = $edits->{'designer'};
    my @developer = $edits->{'developer'};
    my @tab = $edits->{'tab'};
    my @template = $edits->{'template'};
    my @perl_module = $edits->{'perl_module'};
    my @repo = $edits->{'repo'};
    my @answerbar = $edits->{'answerbar'};
    my @src_api_documentation = $edits->{'src_api_documentation'};
    my @src_options = $edits->{'src_options'};
    my @unsafe = $edits->{'unsafe'};
    my @triggers = $edits->{'triggers'};
    my @perl_dependencies = $edits->{'perl_dependencies'};
    my %x;

    if (ref $edits eq 'HASH') {
        my $topic_val = $topic[0][@topic]{'value'};
        my $other_q_val = $other_queries[0][@other_queries]{'value'};
        my $other_q_edited = $other_q_val? 1 : undef;
        my $developer_val = $developer[0][@developer]{'value'};
        my $answerbar_val = $answerbar[0][@answerbar]{'value'};
        my $src_options_val = $src_options[0][@src_options]{'value'};
        my $triggers_val = $triggers[0][@triggers]{'value'};
        my $triggers_edited = $triggers_val? 1 : undef;
        my $perl_dep_val = $perl_dependencies[0][@perl_dependencies]{'value'};
        my $perl_dep_edited = $perl_dep_val? 1 : undef;

        # Other queries, triggers and perl dependencies can be empty,
        # but the handlebars {{#if}} evaluates to false
        # for both null and empty values,
        # so instead of the value, we check the 'edited' key
        # to see if this field was edited
        my %other_q = (
            edited => $other_q_edited,
            value => $other_q_val? from_json($other_q_val) : undef
        );

        my %triggers_hash = (
            edited => $triggers_edited,
            value => $triggers_val? from_json($triggers_val) : undef
        );

        my %perl_dep = (
            edited => $perl_dep_edited,
            value => $perl_dep_val? from_json($perl_dep_val) : undef
        );

        %x = (
            name => $name[0][@name]{'value'},
            description => $desc[0][@desc]{'value'},
            status => $status[0][@status]{'value'},
            topic => $topic_val? from_json($topic_val) : undef,
            example_query => $example_query[0][@example_query]{'value'},
            other_queries => \%other_q,
            dev_milestone => $dev_milestone[0][@dev_milestone]{'value'},
            producer => $producer[0][@producer]{'value'},
            designer => $designer[0][@designer]{'value'},
            developer => $developer_val? from_json($developer_val) : undef,
            tab => $tab[0][@tab]{'value'},
            template => $template[0][@template]{'value'},
            perl_module => $perl_module[0][@perl_module]{'value'},
            repo => $repo[0][@repo]{'value'},
            answerbar => $answerbar_val? from_json($answerbar_val) : undef,
            src_api_documentation => $src_api_documentation[0][@src_api_documentation]{'value'},
            src_options => $src_options_val? from_json($src_options_val) : undef,
            unsafe => $unsafe[0][@unsafe]{'value'},
            triggers => \%triggers_hash,
            perl_dependencies => \%perl_dep
        );
    }

    return \%x;
}

# given result set, field, and value. Add a new hash
# to the updates array
# return the updated array to add to the database
sub add_edit {
    my ($ia, $field, $value ) = @_;

    my $orig_data = $ia->get_column($field) || '';
    my $current_updates = $ia->get_column('updates') || ();

    if($value ne $orig_data){
        $current_updates = $current_updates? from_json($current_updates) : undef;
        my @field_updates = $current_updates->{$field}? $current_updates->{$field} : undef;
        my $time = time;
        my %new_update = ( value => $value,
                           timestamp => $time
                         );
        push(@field_updates, \%new_update);
        $current_updates->{$field} = [@field_updates];
    }

    return $current_updates;
}

# commits a single edit to the database
# removes that entry from the updates column
sub commit_edit {
    my ($ia, $field, $value) = @_;

    $ia->update({$field => $value});

    remove_edit($ia, $field);

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

# given a result set, remove 
# all the entries from the updates column
sub remove_edits {
    my($ia) = @_;
 
    $ia->update({updates => ''});
}

# given the IA name return the data in the updates
# column as an array of hashes
sub get_edits {
    my ($d, $name) = @_; 

    my $results = $d->rs('InstantAnswer')->search( {name => $name} );

    my $ia_result = $results->first();
    my $edits;

    try{
        my $column_updates = $ia_result->get_column('updates');
        $edits = $column_updates? from_json($column_updates) : undef;
    }catch{
        return;
    };

    return $edits;
}


no Moose;
__PACKAGE__->meta->make_immutable;

