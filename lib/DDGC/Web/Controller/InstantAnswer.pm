package DDGC::Web::Controller::InstantAnswer;
# ABSTRACT: Instant Answer Pages
use Data::Dumper;
use Moose;
use namespace::autoclean;
use Try::Tiny;
use DDGC::Util::File qw( ia_page_version );

my $INST = DDGC::Config->new->appdir_path."/root/static/js";

my $ia_version = ia_page_version();

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
    $c->stash->{ia_version} = $ia_version;

    # @{$c->stash->{ialist}} = $c->d->rs('InstantAnswer')->all();
}

sub ialist_json :Chained('base') :PathPart('json') :Args(0) {
    my ( $self, $c ) = @_;

    # $c->stash->{x} = {
    #     ia_list => "this will be the list of all IAs"
    # };

    my @x = $c->d->rs('InstantAnswer')->all();
    my @ial;

    use JSON;

    for (@x) {
        my $topics = $_->topic;
        push (@ial, {
                name => $_->name,
                id => $_->id,
                example_query => $_->example_query,
                repo => $_->repo,
                src_name => $_->src_name,
                dev_milestone => $_->dev_milestone,
                perl_module => $_->perl_module,
                description => $_->description,
                topic => decode_json($topics)
            });
    }

    $c->stash->{x} = \@ial;
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
    $c->forward($c->view('JSON'));
}

sub queries :Chained('base') :PathPart('queries') :Args(0) {

    # my @x = $c->d->rs('InstantAnswer')->all();

}

sub ia_base :Chained('base') :PathPart('view') :CaptureArgs(1) {  # /ia/view/calculator
    my ( $self, $c, $answer_id ) = @_;

    $c->stash->{ia_page} = "IAPage";
    $c->stash->{ia_version} = $ia_version;
    $c->stash->{ia} = $c->d->rs('InstantAnswer')->find($answer_id);
    @{$c->stash->{issues}} = $c->d->rs('InstantAnswer::Issues')->search({instant_answer_id => $answer_id});

    use JSON;
    my $topics = $c->stash->{ia}->topic;
    $c->stash->{ia_topics} = decode_json($topics);

    my $code = $c->stash->{ia}->code;
    $c->stash->{ia_code} = decode_json($code);

    my $other_queries = $c->stash->{ia}->other_queries;
    if ($other_queries) {
        $c->stash->{ia_other_queries} = decode_json($other_queries);
    }

    my $ia_attribution = $c->stash->{ia}->attribution;
    if($ia_attribution){
        $c->stash->{ia_attribution} = decode_json($ia_attribution);
    }

    unless ($c->stash->{ia}) {
        $c->response->redirect($c->chained_uri('InstantAnswer','index',{ instant_answer_not_found => 1 }));
        return $c->detach;
    }

    use DDP;
    $c->stash->{ia_version} = $ia_version;
    $c->stash->{ia_pretty} = p $c->stash->{ia};

    my $permissions;
    my $class = "ia-readonly";

    try {
        $permissions = $c->stash->{ia}->users->find($c->user->id);
    }
    catch {
        $c->d->errorlog("Error: user is not logged in");
    };

    if ($permissions) {
        $class = "ia-edit"
    }

    $c->stash->{class} = $class;
}

sub ia_json :Chained('ia_base') :PathPart('json') :Args(0) {
    my ( $self, $c) = @_;

    my $ia = $c->stash->{ia};

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
                topic => $c->stash->{ia_topics},
                attribution => $c->stash->{'ia_attribution'}
    };

    # not ready yet
    # my @issues = @{$c->stash->{issues}};
    # $c->stash->{x}->{issues} = \@issues if (@issues);

    $c->forward($c->view('JSON'));
}

sub ia  :Chained('ia_base') :PathPart('') :Args(0) {
    my ( $self, $c ) = @_;
}

sub save_edit :Chained('base') :PathPart('save') :Args(0) {
    my ( $self, $c ) = @_;

    my $ia = $c->d->rs('InstantAnswer')->find($c->req->params->{id});
    my $permissions;
    my $result = '';

    try {
       $permissions = $ia->users->find($c->user->id);
    }
    catch {
        $c->d->errorlog("Error: user is not logged in");
    };


    if ($permissions) {
        try {
            $ia->update({
                        description => $c->req->params->{description},
                        name => $c->req->params->{name},
                        status => $c->req->params->{status},
                        topic => $c->req->params->{topic},
                        example_query => $c->req->params->{example},
                        other_queries => $c->req->params->{other_examples},
                        code => $c->req->params->{code} 
                     });
            $result = 1;
        }
        catch {
            $c->d->errorlog("Error updating the database");
        };
    }
    
    $c->stash->{x} = {
        result => $result,
    };
    
    return $c->forward($c->view('JSON'));
}

no Moose;
__PACKAGE__->meta->make_immutable;

