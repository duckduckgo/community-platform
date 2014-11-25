package DDGC::Web::Controller::InstantAnswer;
# ABSTRACT: Instant Answer Pages
use Data::Dumper;
use Moose;
use namespace::autoclean;
use Try::Tiny;
use Time::Local;

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

    use JSON;

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

    use JSON;

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

    use JSON;

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
            $commit_class = "";
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

    use JSON;
 
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
                    tags => decode_json($issue->tags)
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
                other_queries => $c->stash->{ia_other_queries},
                code => $c->stash->{ia_code},
                topic => \@topics,
                attribution => $c->stash->{'ia_attribution'},
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
    my @topics_list =  $c->d->rs('Topic')->all();
    my @topics = map { $_->name} $ia->topics;

    my @name;
    my @desc;
    my @status;
    my @topic;
    my @example_query;
    my @other_queries;
    my @code;
    my %original;

    use JSON;

    %original = (
        name => $ia->name,
        description => $ia->description,
        status => $ia->status,
        topic => encode_json(\@topics),
        example_query => $ia->example_query,
        other_queries => $c->stash->{ia_other_queries},
        code => $c->stash->{ia_code}
    );

    for my $edit (@{ $edits }) {

        for my $time (keys %{$edit}) {

            for my $field (keys %{ $edit->{$time} } ) {
                my %entry = (
                   value => $edit->{$time}->{$field},
                   time => $time,
                );

                if ($field eq 'name') {
                    push(@name, {%entry});
                } elsif ($field eq 'description') {
                    push(@desc, {%entry});
                } elsif ($field eq 'status') {
                    push(@status, {%entry});
                } elsif ($field eq 'topic') {
                    push(@topic, {%entry});
                } elsif ($field eq 'example_query') {
                    push(@example_query, {%entry});
                } elsif ($field eq 'other_queries') {
                    push(@other_queries, {%entry});
                } elsif ($field eq 'code') {
                    push(@code, {%entry});
                }
            }
        }
    }

    $c->stash->{x} = {
        name => \@name,
        description => \@desc,
        status => \@status,
        topic => \@topic,
        example_query => \@example_query,
        other_queries => \@other_queries,
        code => \@code,
        original => \%original
    };

    $c->stash->{not_last_url} = 1;
    $c->forward($c->view('JSON'));
}

sub commit_save :Chained('commit_base') :PathPart('save') :Args(0) {
    my ( $self, $c ) = @_;

    my $is_admin;
    my $result = '';

    use JSON;

    if ($c->user) {
        my $is_admin = $c->user->admin;

        if ($is_admin) {
            my $ia = $c->d->rs('InstantAnswer')->find($c->req->params->{id});
            my @params = decode_json($c->req->params->{values});
            use Data::Dumper;

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
                    if ($field eq 'topic') {
                        my @topics_list =  $c->d->rs('Topic')->all();
                        my @topics = map { $_->name} $ia->topics;
                        my @topic_value = $value;

                        # TODO: update topics for this IA

                    } else {
                        try {
                            $ia->update({$field => $value});
                            $result = '1';
                        } catch {
                            $c->d->errorlog("Error updating the database");
                        };
                    }
                }
            } 
     
            my $edits = get_edits($c->d, $ia->name);

            unless (ref $edits eq 'ARRAY') {
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
    my $result = '';

    if ($c->user) {
       $permissions = $ia->users->find($c->user->id) || $c->user->admin;
    }

    if ($permissions) {
        my $field = $c->req->params->{field};
        my $value = $c->req->params->{value};
        my $edits = add_edit($ia,  $field, $value);

        try {
            $ia->update({updates => $edits});
            $result = {$field => $value};
        }
        catch {
            $c->d->errorlog("Error updating the database");
        };
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
        $current_updates = from_json($current_updates) if $current_updates;
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

    use JSON;

    my $updates = ();
    my $edits = from_json($ia->get_column('updates'));

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

    use JSON;

    my $results = $d->rs('InstantAnswer')->search( {name => $name} );

    my $ia_result = $results->first();
    my $edits = $ia_result->get_column('updates');

    if(!$edits){
        return 0;
    }

    return from_json($edits);
}


no Moose;
__PACKAGE__->meta->make_immutable;

