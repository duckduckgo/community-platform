package DDGC::GitHub::Plugin;
# ABSTRACT: Manage instant-answer plugin pull requests

use Moose;

sub attributes {[
    branch => 'Which git branch do you want to merge from? (master, unless you created your own)' => {
        type => 'select',
        validators => ['select'],
        export => 'select',
    },
    function => 'What does your Instant Answer do?' => { type => 'textarea' },
    problem_solved => 'What problem does your Instant Answer solve (Why is it better than organic links)?' => { type => 'textarea' },
    source => 'What is the data source for your Instant Answer? (Provide a link if possible)' => {},
    why_source => 'Why did you choose this data source?' => { type => 'textarea' },
    better_source => 'Are there any other alternative (better) data sources?' => { type => 'textarea' },
    example_queries => 'What are some example queries that trigger this Instant Answer?' => {},
    communities => 'Which communities will this Instant Answer be especially useful for? (gamers, book lovers, etc)' => {},
     # TODO: Make an idea search/picker popup thing for this
    idea => 'Is this Instant Answer connected to a <a href="/ideas">suggestion</a>?' => {},
    overlap => 'Which existing Instant Answers will this one supercede/overlap with (if any)?' => { type => 'textarea' },
    issues => 'Are you having any problems? Do you need help with anything?' => { type => 'textarea' },
     # TODO: Make a screenshot field type which actually uses the database properly.
    screenshot => 'Care to provide a screenshot showing off your awesome plugin?' => { type => 'url' },
]}

with 'DDGC::Role::Table';

1;
