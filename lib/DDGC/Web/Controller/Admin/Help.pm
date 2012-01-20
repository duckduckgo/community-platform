package DDGC::Web::Controller::Admin::Help;
use Moose;
use namespace::autoclean;

use DDGC::Config;

BEGIN {extends 'Catalyst::Controller'; }

sub base :Chained('/admin/base') :PathPart('help') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
}

sub index :Chained('base') :PathPart('') :Args(0) {
    my ( $self, $c ) = @_;
	$c->stash->{help} = [$c->d->rs('DB::Help')->search({})->all];
        my @keys = qw/ key name description /;
        for my $l (@{$c->stash->{help}}) {
                my $p = 'help_'.$l->id.'_';
                if ($c->req->params->{$p.'delete'}) {
                        $l->delete;
                } elsif ($c->req->params->{save_help}) {
                        for (@keys) {
                                $l->$_($c->req->params->{$p.$_}) if $c->req->params->{$p.$_};
                        }
                        $l->update;
                }
        }
        my %new;
        if ($c->req->params->{save_help}) {
                for (@keys) {
                        $new{$_} = $c->req->params->{'help_0_'.$_} if $c->req->params->{'help_0_'.$_};
                }
                push @{$c->stash->{help}}, $c->model('Help')->create(\%new) if (%new);
        }

}

__PACKAGE__->meta->make_immutable;

1;
