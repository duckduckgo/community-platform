package DDGC::GitHub::Plugin;
use Moose;

sub attributes {[
    function => 'What does your instant answer do?' => { type => 'textarea' },
    problem_solved => 'What problem does your instant answer solve (Why is it better than organic links)?' => { type => 'textarea' },
    source => 'What is the data source for your instant answer? (Provide a link if possible)' => {},
    why_source => 'Why did you choose this data source?' => { type => 'textarea' },
    better_source => 'Are there any other alternative (better) data sources?' => { type => 'textarea' },
    example_queries => 'What are some example queries that trigger this instant answer?' => {},
    communities => 'Which communities will this instant answer be especially useful for? (gamers, book lovers, etc)' => {},
     # TODO: Make an idea search/picker popup thing for this
    idea => 'Is this instant answer connected to a <a href="/ideas">suggestion</a>?' => {},
    overlap => 'Which existing instant answers will this one supercede/overlap with (if any)?' => { type => 'textarea' },
    issues => 'Are you having any problems? Do you need help with anything?' => { type => 'textarea' },
     # TODO: Make a screenshot field type which actually uses the database properly.
    screenshot => 'Care to provide a screenshot showing off your awesome plugin?' => { type => 'url' },
]}

with 'DDGC::Role::Table';

1;
