package DDGC::Web::Controller::Admin::Help;
# ABSTRACT: Help administration web controller class

use Moose;
BEGIN { extends 'Catalyst::Controller'; }

use namespace::autoclean;

sub base :Chained('/admin/base') :PathPart('help') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
    $c->add_bc('Help editor', $c->chained_uri('Admin::Help','index'));

    $c->stash->{help_language} = $c->d->rs('Language')->search({ locale => 'en_US' })->first;
    die 'english not found?!?!?' unless $c->stash->{help_language};
    $c->stash->{help_language_id} = $c->stash->{help_language}->id;
}

sub index :Chained('base') :PathPart('') :Args(0) {
    my ( $self, $c ) = @_;
    $c->bc_index;

    if ($c->req->param('save_help')) {
        my %data;
        for (keys %{$c->req->params}) {
            if ($_ =~ m/^help_(\d+)_(.+)$/) {
                my $id = $1;
                my $key = $2;
                $data{$id} = {} unless defined $data{$id};
                $data{$id}->{$key} = $c->req->param($_);
            }
        }
        for my $id (keys %data) {
            my %values = %{$data{$id}};
            my %help_values;
            my %help_content_values;
            for (keys %values) {
                if ($_ =~ m/^content_(.*)$/) {
                    $help_content_values{$1} = $values{$_};
                } else {
                    $help_values{$_} = $values{$_};
                }
            }
            my $help;
            if ($id > 0) {
                $help = $c->d->rs('Help')->find($id);
                die "help id ".$_." not found" unless $help;
                for (keys %help_values) {
                    $help->$_($help_values{$_});
                }
                $help->update;
            } else {
                $help = $c->d->rs('Help')->create(\%help_values);
            }
            $c->stash->{changed_help_id} = $help->id;
            my $help_content = $help->search_related('help_contents',{
                language_id => $c->stash->{help_language_id},
            })->first;
            if ($help_content) {
                for (keys %help_content_values) {
                    $help_content->$_($help_content_values{$_});
                }
                $help_content->update;
            } else {
                $help_content_values{language_id} = $c->stash->{help_language_id};
                $help_content = $help->create_related(
                    'help_contents',
                    \%help_content_values
                );
            }
        }
    }

    $c->stash->{category_options} = [map {
        { value => $_->id, text => $_->key }
    } $c->d->rs('Help::Category')->search({},{
        order_by => { -asc => 'me.key' },
    })->all];

    $c->stash->{helps} = $c->d->rs('Help')->search({},{
        order_by => [ { -asc => 'help_category.sort' }, { -asc => 'me.sort' } ],
        prefetch => [ 'help_contents', { help_category => [ 'help_category_contents','helps' ] } ],
    });

}

sub categories :Chained('base') :Args(0) {
    my ( $self, $c ) = @_;
    $c->add_bc('Categories editor');

    if ($c->req->param('save_category')) {
        my %data;
        for (keys %{$c->req->params}) {
            if ($_ =~ m/^category_(\d+)_(.+)$/) {
                my $id = $1;
                my $key = $2;
                $data{$id} = {} unless defined $data{$id};
                $data{$id}->{$key} = $c->req->param($_);
            }
        }
        for my $id (keys %data) {
            my %values = %{$data{$id}};
            my %category_values;
            my %category_content_values;
            for (keys %values) {
                if ($_ =~ m/^content_(.*)$/) {
                    $category_content_values{$1} = $values{$_};
                } else {
                    $category_values{$_} = $values{$_};
                }
            }
            my $category;
            if ($id > 0) {
                $category = $c->d->rs('Help::Category')->find($id);
                die "help category id ".$_." not found" unless $category;
                for (keys %category_values) {
                    $category->$_($category_values{$_});
                }
                $category->update;
            } else {
                $category = $c->d->rs('Help::Category')->create(\%category_values);
            }
            $c->stash->{changed_category_id} = $category->id;
            my $help_category_content = $category->search_related('help_category_contents',{
                language_id => $c->stash->{help_language_id},
            })->first;
            if ($help_category_content) {
                for (keys %category_content_values) {
                    $help_category_content->$_($category_content_values{$_});
                }
                $help_category_content->update;
            } else {
                $category_content_values{language_id} = $c->stash->{help_language_id};
                $help_category_content = $category->create_related(
                    'help_category_contents',
                    \%category_content_values
                );
            }
        }
    }

    $c->stash->{categories} = $c->d->rs('Help::Category')->search({},{
        order_by => { -asc => 'me.sort' },
    });

}

no Moose;
__PACKAGE__->meta->make_immutable;
