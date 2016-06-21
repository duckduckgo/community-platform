#!/usr/bin/env perl

use FindBin;
use lib $FindBin::Dir . "/../../lib";
use Try::Tiny;
use strict;
use DDGC;

my @perl = ['perl_doc', 'perl6doc', 'meta_cpan', 'perl_cheat_sheet', 'perldoc_cheat_sheet'];
my @swift = ['swift_cheat_sheet'];
my @css = ['caniuse', 'color_picker', 'css_cheat_sheet', 'color_codes', 'yui3', 'bootstrap_cheat_sheet', 'sass_cheat_sheet'];
my @python = ['flask_cheat_sheet', 'nltk_cheat_sheet', 'opencv_python_cheat_sheet', 'pandas_cheat_sheet', 'python_cheat_sheet', 'py_pi', 'python'];
my @js = ['angular2_cheat_sheet', 'angularjs_cheat_sheet', 'backbone_js_cheat_sheet', 'cashjs_cheat_sheet', 'coffeescript_cheat_sheet', 'd3js_cheat_sheet', 'es6_cheat_sheet',
          'emberjs_cheat_sheet', 'express_cheat_sheet', 'reactjs_cheat_sheet', 'grunt', 'gulp', 'javascript_cheat_sheet', 'javascript_dom_cheat_sheet', 'js_keycodes_cheat_sheet',
          'jquery', 'jquery_cheat_sheet', 'json_syntax_cheat_sheet', 'mdnjs', 'meteor_cheat_sheet', 'node_js', 'nodejs_cheat_sheet', 'nodejs_tutorials_cheat_sheet', 'npm', 'npm_cheat_sheet'];


my %languages = (
        perl => \@perl,
        swift => \@swift,
        CSS => \@css,
        python => \@python,
        JavaScript => \@js
    );


my $d  = DDGC->new;

my $programming_topic = $d->rs('Topic')->find({ name => 'programming' });

while (my ($key, $val) = each %languages) {
    for my $meta_id ( @{ @{$val}[0] } ) {
        print $meta_id;
        my $ia = $d->rs('InstantAnswer')->search({ meta_id => $meta_id })->one_row;
        my $topic = $d->rs('Topic')->find({ name => $key });

        try {
            $ia->instant_answer_topics->delete;
            $ia->add_to_topics($topic);
            $ia->add_to_topics($programming_topic);
            print "topic ".$key." successfully added to ". $ia->name;
        } catch {
            $d->errorlog("Error updating the database... $@");
        };
    }
}

