package DDGC::Feedback::Config::Relevancy;

use strict;
use warnings;

sub feedback_title { 'I’d like to report bad relevancy.' }

sub feedback {[
  { description => "Please perform the search on DuckDuckGo.com and use the, “Give Feedback” button on the right side of the results page. There, it’s just a single button push to anonymously submit that query for us to improve on. If you’d like to elaborate on why the results were bad, please use this guide:", type => "info" },
  { name => "query", description => "This is exactly what I searched for", type => "text" },
  { name => "pages", description => "The page(s) I wanted to find were", type => "textarea" },
  { name => "reasons", description => "The reason(s) the results seemed bad are", type => "textarea", placeholder => "e.g. not showing results for the word, 'apple' when I searched for, 'apple orchards'" },
  { name => 'email', description => "Your email (not required)", type => "email", },  
  "Report bad relevancy",
]}

1;