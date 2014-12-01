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

sub index :Chained('base') :PathPart('') :Args() {
    my ( $self, $c, $field, $value ) = @_;
    # Retrieve / stash all IAs for index page here?

    # my @x = $c->d->rs('InstantAnswer')->all();
    # $c->stash->{ialist} = \@x;
    $c->stash->{ia_page} = "IAIndex";

    if ($field && $value) {
        $c->stash->{field} = $field;
        $c->stash->{value} = $value;
    }

    $c->add_bc('Instant Answers', $c->chained_uri('InstantAnswer','index'));

    # @{$c->stash->{ialist}} = $c->d->rs('InstantAnswer')->all();
}

sub ialist_json :Chained('base') :PathPart('json') :Args() {
    my ( $self, $c, $field, $value ) = @_;

    my @x;

    if ($field && $value) {
        @x = $c->d->rs('InstantAnswer')->search({$field => $value});
    } else {
        @x = $c->d->rs('InstantAnswer')->all();
    }

    my @ial;    

    for my $ia (@x) {
        my @topics = map { $_->name } $ia->topics;
        my $attribution = $ia->attribution;

        push (@ial, {
                name => $ia->name,
                id => $ia->id,
                example_query => $ia->example_query,
                repo => $ia->repo,
                src_name => $ia->src_name,
                dev_milestone => $ia->dev_milestone,
                perl_module => $ia->perl_module,
                description => $ia->description,
                topic => \@topics,
                attribution => $attribution ? decode_json($attribution) : undef,
            });
    }

    $c->stash->{x} = \@ial;
    $c->stash->{not_last_url} = 1;
    $c->forward($c->view('JSON'));
}

sub iarepo :Chained('base') :PathPart('repo') :Args(1) {
    my ( $self, $c, $repo ) = @_;


    # $c->stash->{ia_repo} = $repo;

    my @x = $c->d->rs('InstantAnswer')->search({repo => $repo});

    my %iah;

    for (@x) {
        my $topics = $_->topic;

        if ($_->example_query) {
            $iah{$_->id} = {
                    name => $_->name,
                    id => $_->id,
                    example_query => $_->example_query,
                    repo => $_->repo,
                    perl_module => $_->perl_module
            };
        }
    }

    $c->stash->{x} = \%iah;
    $c->stash->{not_last_url} = 1;
    $c->forward($c->view('JSON'));
}

sub queries :Chained('base') :PathPart('queries') :Args(0) {

    # my @x = $c->d->rs('InstantAnswer')->all();

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
    my $edit_class = "hide";
    my $commit_class = "hide";

    if ($c->user) {
        $permissions = $c->stash->{ia}->users->find($c->user->id);
        $is_admin = $c->user->admin;
    }

    if ($permissions || $is_admin) {
        $edit_class = "";

        if ($is_admin) {
            my $edits = get_edits($c->d, $c->stash->{ia}->name);

            if (ref $edits eq 'ARRAY') {
                $commit_class = "";
            }
        }
    }

    $c->stash->{edit_class} = $edit_class;
    $c->stash->{commit_class} = $commit_class;

    $c->add_bc('Instant Answers', $c->chained_uri('InstantAnswer','index'));
    $c->add_bc($c->stash->{ia}->name);
}

sub ia_json :Chained('ia_base') :PathPart('json') :Args(0) {
    my ( $self, $c) = @_;

    my $ia = $c->stash->{ia};
    my @topics_list =  $c->d->rs('Topic')->all();
    my @topics = map { $_->name} $ia->topics;
    my @allowed;

    my @issues = $c->d->rs('InstantAnswer::Issues')->find({instant_answer_id => $ia->id});
    my @ia_issues;    
 
    for my $topic (@topics_list) {
        push (@allowed, {
               id => $topic->id,
               name => $topic->name
            });
    }

    for my $issue (@issues) {
        if ($issue) {
            push(@ia_issues, {
                    issue_id => $issue->issue_id,
                    title => $issue->title,
                    body => $issue->body,
                    tags => $issue->tags? decode_json($issue->tags) : undef
                });
        }
    }

    $c->stash->{x} =  {
                id => $ia->id,
                name => $ia->name,
                description => $ia->description,
                tab => $ia->tab,
                status => $ia->status,
                repo => $ia->repo,
                dev_milestone => $ia->dev_milestone,
                perl_module => $ia->perl_module,
                example_query => $ia->example_query,
                other_queries => $ia->other_queries? decode_json($ia->other_queries) : undef,
                code => $ia->code? decode_json($ia->code) : undef,
                topic => \@topics,
                attribution => $ia->attribution? decode_json($ia->attribution) : undef,
                allowed_topics => \@allowed,
                issues => \@ia_issues
    };

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
    my $edits = get_edits($c->d, $ia->name);
    my @topics = map { $_->name} $ia->topics;

    my $name;
    my $desc;
    my $status;
    my $topic;
    my $example_query;
    my $other_queries;
    my $code;
    my %original;
    my $new_edits;
    my $is_admin;

    if ($c->user) {
        $is_admin = $c->user->admin;
    }

    %original = (
        name => $ia->name,
        description => $ia->description,
        status => $ia->status,
        topic => \@topics,
        example_query => $ia->example_query,
        other_queries => $ia->other_queries? decode_json($ia->other_queries) : undef,
        code => $ia->code? decode_json($ia->code) : undef
    );

    if (ref $edits eq 'ARRAY') {
        $new_edits = 1;

        # Loop through staged edits
        for my $edit (@{ $edits }) {
            my $cur_time = time;
            my $diff_time;

            # Loop through time keys, which contain edited 
            # fields and values, and choose last edit, aka the
            # edit in which the timestamp is the closest to the current
            # timestamp
            for my $time (keys %{$edit}) {
                my %hash_edit = %{$edit};
                my $temp_diff_time = $cur_time - $hash_edit{$time};

                if (!$diff_time || $temp_diff_time < $diff_time) {
                    $diff_time = $temp_diff_time;

                    # Loop through fields (structure: field_name => field_value)
                    # and assign the value to the correct array depending on the field name 
                    for my $field (keys %{ $edit->{$time} } ) {
                        if ($field eq 'name') {
                            $name = $edit->{$time}->{$field};
                        } elsif ($field eq 'description') {
                            $desc =  $edit->{$time}->{$field};
                        } elsif ($field eq 'status') {
                            $status = $edit->{$time}->{$field};
                        } elsif ($field eq 'topic') {
                            $topic =$edit->{$time}->{$field}?  decode_json($edit->{$time}->{$field}) : undef;
                        } elsif ($field eq 'example_query') {
                            $example_query = $edit->{$time}->{$field};
                        } elsif ($field eq 'other_queries') {
                            $other_queries = $edit->{$time}->{$field}? decode_json($edit->{$time}->{$field}) : undef;
                        } elsif ($field eq 'code') {
                            $code = $edit->{time}->{$field}? decode_json($edit->{$time}->{$field}) : undef;
                        }
                    }
                }
            }
        }
    }

    if ($new_edits && $is_admin) {
        $c->stash->{x} = {
            name => $name,
            description => $desc,
            status => $status,
            topic => $topic,
            example_query => $example_query,
            other_queries => $other_queries,
            code => $code,
            original => \%original
        };
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
            my @params = $c->req->params->{values}? decode_json($c->req->params->{values}) : undef;

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
                                $result = 1;
                            } catch {
                                $c->d->errorlog("Error updating the database");
                                return $result;
                            };
                        }
                    } else {
                        if ($field eq 'other_queries' || $field eq 'code') {
                            $value = encode_json($value);
                        }

                        try {
                            $ia->update({$field => $value});
                            $result = '1';
                        } catch {
                            $c->d->errorlog("Error updating the database");
                            return $result;
                        };
                    }
                }
            } 
     
            my $edits = get_edits($c->d, $ia->name);

            if (ref $edits eq 'ARRAY') {
                foreach my $edit (@{$edits}) {
                    foreach my $time (keys %{$edit}){
                        remove_edit($ia, $time);
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
            my $edits = add_edit($ia,  $field, $value);

            try {
                $ia->update({updates => $edits});
                $result = {$field => $value, is_admin => $is_admin};
            }
            catch {
                $c->d->errorlog("Error updating the database");
            };
        }
    }

    $c->stash->{x} = {
        result => $result,
    };

    $c->stash->{not_last_url} = 1;
    return $c->forward($c->view('JSON'));
}

# given result set, field, and value. Add a new hash
# to the updates array
# return the updated array to add to the database
sub add_edit {
    my ($ia, $field, $value ) = @_;

    my $orig_data = $ia->get_column($field);
    my $current_updates = $ia->get_column('updates') || ();

    if($value ne $orig_data){
        $current_updates = $current_updates? decode_json($current_updates) : undef;
        my $time = time;
        my %new_update = ( $time => {$field => $value});
        push(@{$current_updates}, \%new_update);
    }

    return $current_updates;
}

# commits a single edit to the database
# removes that entry from the updates column
sub commit_edit {
    my ($ia, $field, $value, $time) = @_;

    $ia->update({$field => $value});

    remove_edit($ia, $time);

}

# given a result set and timestamp, remove the
# entry from the updates column with that timestamp
sub remove_edit {
    my($ia, $time) = @_;   

    my $updates = ();
    my $column_updates = $ia->get_column('updates');
    my $edits = $column_updates? decode_json($ia->get_column('updates')) : undef;

    # look through edits for timestamp
    # push all edits that don't match the timestamp of the
    # one we want to remove (recreate the updates json)
    foreach my $edit ( @{$edits} ){
        foreach my $timestamp (keys %{$edit}){
            if($timestamp ne $time){
                push(@{$updates}, $edit);
            }
        }
    }
    $ia->update({updates => $updates});
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
        $edits = $column_updates? decode_json($column_updates) : undef;
    }catch{
        return;
    };

    return $edits;
}


no Moose;
__PACKAGE__->meta->make_immutable;

