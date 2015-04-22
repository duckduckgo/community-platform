package DDGC::Web::Controller::InstantAnswer;
# ABSTRACT: Instant Answer Pages
use Moose;
use namespace::autoclean;
use Try::Tiny;
use Time::Local;
use JSON;

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
         'me.dev_milestone' => { '=' => ['live', 'ready']},
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
        {dev_milestone => 'qa'},
        {dev_milestone => 'ready'}]
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
        my @ias = $rs->search(
            {'me.dev_milestone' => { '!=' => 'live'},
             'me.dev_milestone' => { '!=' => 'deprecated'}});

        my %dev_ias;
        for my $ia (@ias) {
            push @{$dev_ias{$ia->dev_milestone}}, $ia->TO_JSON('pipeline');
        }

        $c->stash->{x} = \%dev_ias;
    } elsif ($view eq 'deprecated') {
        my @fathead = $rs->search(
            {'me.repo' => { '=' => 'fathead'},
             'me.dev_milestone' => { '=' => 'deprecated'}},
            {
                columns => [ qw/ name repo dev_milestone producer designer developer/, {id => 'meta_id'}],
                order_by => [ qw/ name/ ],
                result_class => 'DBIx::Class::ResultClass::HashRefInflator',
            }
        )->all;

        my @goodies = $rs->search(
            {'me.repo' => { '=' => 'goodies'},
             'me.dev_milestone' => { '=' => 'deprecated'}},
            {
                columns => [ qw/ name repo dev_milestone producer designer developer/, {id => 'meta_id'}],
                order_by => [ qw/ name/ ],
                result_class => 'DBIx::Class::ResultClass::HashRefInflator',
            }
        )->all;

        my @longtail = $rs->search(
            {'me.repo' => { '=' => 'longtail'},
             'me.dev_milestone' => { '=' => 'deprecated'}},
            {
                columns => [ qw/ name repo dev_milestone producer designer developer/, {id => 'meta_id'}],
                order_by => [ qw/ name/ ],
                result_class => 'DBIx::Class::ResultClass::HashRefInflator',
            }
        )->all;

        my @spice = $rs->search(
            {'me.repo' => { '=' => 'spice'},
             'me.dev_milestone' => { '=' => 'deprecated'}},
            {
                columns => [ qw/ name repo dev_milestone producer designer developer/, {id => 'meta_id'}],
                order_by => [ qw/ name/ ],
                result_class => 'DBIx::Class::ResultClass::HashRefInflator',
            }
        )->all;

        $c->stash->{x} = {
            fathead => \@fathead,
            goodies => \@goodies,
            longtail => \@longtail,
            spice => \@spice,
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
                            id => $ia->meta_id,
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
        $c->add_bc('Dev Pipeline', $c->chained_uri('InstantAnswer','dev_pipeline', 'deprecated'));
    } else {
        $c->add_bc('Dev Pipeline', $c->chained_uri('InstantAnswer','dev_pipeline', 'dev'));
    }
    $c->add_bc($c->stash->{ia}->name);
}

sub ia_json :Chained('ia_base') :PathPart('json') :Args(0) {
    my ( $self, $c) = @_;

    my $ia = $c->stash->{ia};
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

               if ($dev_milestone ne 'live' && $dev_milestone ne 'deprecated' && !$ia->developer) {
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

    warn Dumper $ia->TO_JSON if debug;
    
    $ia_data{live} = $ia->TO_JSON;
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
    my $is_admin;
    my $saved = 0;
    my $field = $c->req->params->{field};
    my $live_value = $ia->{$field};

    # if the update fails because of invalid values
    # we still return the current value of the specified field
    # so the handlebars can be updated correctly
    my $result = {result => {$field => $live_value, is_admin => $is_admin, saved => $saved}};

    $c->stash->{x} = {
        result => $result,
    };

    $c->stash->{not_last_url} = 1;

    if ($c->user) {
       $permissions = $ia->users->find($c->user->id);
       $is_admin = $c->user->admin;

        if ($permissions || $is_admin) {
            $result->{result}->{is_admin} = $is_admin;
            $c->stash->{x}->{result} = $result;

            my $value = $c->req->params->{value};
            my $autocommit = $c->req->params->{autocommit};
            my $complat_user = $c->d->rs('User')->find({username => $value});
            my $complat_user_admin = $complat_user? $complat_user->admin : '';

            # developers can be any complat user
            if ($field eq "developer") {
                return $c->forward($c->view('JSON')) unless $complat_user || $value eq '';
                my %dev_hash = (
                        name => $value,
                        url => 'https://duck.co/user/'.$value
                );
                $value = to_json \%dev_hash;
            }

            if ($field =~ /designer|producer/){
                return $c->forward($c->view('JSON')) unless $complat_user_admin || $value eq '';
            } elsif ($field eq "meta_id") {
                # meta_id must be unique, lowercase and without spaces
                $value =~ s/\s//g;
                $value = lc $value;
                return $c->forward($c->view('JSON')) if $c->d->rs('InstantAnswer')->find({meta_id => $value});
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
                    $tmp_val= $c->req->params->{value};
                }

                if($field eq 'topic'){
                    $tmp_val = from_json($c->req->params->{value});
                }

                push(@update, {value => $tmp_val // $value, field => $field} );
                save($c, \@update, $ia);
                $saved = 1;
            }

            if ($field eq 'developer') {
                $value = $value? from_json($value) : undef;
            }

            $result = {$field => $value, is_admin => $is_admin, saved => $saved};
        }
    }

    $c->stash->{x}->{result} = $result;

    return $c->forward($c->view('JSON'));
}

sub create_ia :Chained('base') :PathPart('create') :Args() {
    my ( $self, $c ) = @_;

    my $ia = $c->d->rs('InstantAnswer')->find({lc id => $c->req->params->{id}}) || $c->d->rs('InstantAnswer')->find({lc meta_id => $c->req->params->{id}});
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
                lc meta_id => $c->req->params->{id},
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
                
            for my $topic (@{$topic_values[0]}) {
                $saved = add_topic($c, $ia, $topic);
                return unless $saved;
            }
        } else {
            if ($field eq "developer") {
                my %dev_hash = (
                    name => $value,
                    url => 'https://duck.co/user/'.$value
                );
                $value = to_json \%dev_hash;
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
        else {
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
    $value = decode_json($value) if $column_data->{is_json} || $field eq 'topic';
    
    $c->d->rs('InstantAnswer::Updates')->create({
                instant_answer_id => $ia->id,
                field => $field,
                value => encode_json({field => $value}),
                timestamp => time
    });    
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
    update_ia($d, $ia, $update_field, $value);
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

no Moose;
__PACKAGE__->meta->make_immutable;

