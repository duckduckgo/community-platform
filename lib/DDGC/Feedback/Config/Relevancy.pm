package DDGC::Feedback::Config::Relevancy;

use strict;
use warnings;

sub feedback_title { 'I’d like to report bad relevancy.' }

sub feedback {[
  { description => "Please perform the search on DuckDuckGo.com and use the, “Give Feedback” button on the right side of the results page. There, it’s just a single button push to anonymously submit that query for us to improve on.  Have more info to share?  Try the below guide:", type => "info", icon => "newspaper" },
  { description => 'I’d like to elaborate on why the results were bad', icon => "sad-search" },
    relevancy_info(),
]}

sub relevancy_info {[
  { name => "query", description => "This is exactly what I searched for", placeholder => "e.g. Fuzzy Kitten Mittens on Fluffy Cats with Hats", type => "text", icon => "search" },
  { name => "pages", description => "The page(s) I wanted to find were", placeholder => "URLs would be nice here, but you can also be a little more broad in what you were looking for", type => "textarea", icon => "newspaper" },
  { name => "reasons", description => "The reason(s) the results seemed bad are", type => "textarea", placeholder => "e.g. not showing results for the word, 'apple' when I searched for, 'apple orchards'", icon => "sad-search" },
  { name => 'email', description => "Your email (not required)", placeholder => "We'd like to get back to you, but you can leave this blank.", type => "email", icon => "inbox", optional => 1 },  
  { name => 'submit', description => "Report bad relevancy", icon => 'mail', cssclass => "fb-step--submit" }
]}

1;