package DDGC::Feedback::Config::Relevancy;
# ABSTRACT:

use strict;
use warnings;

sub feedback_title { 'I’d like to report bad relevancy.' }

sub feedback {[
  { description => 'I’d like to report bad relevancy for an Instant Answer', icon => "sad-search" },
    instant_info(),
  { description => 'I’d like to report bad relevancy for regular links (not Instant Answers)', icon => "sad-search" },
    relevancy_info(),
]}

sub relevancy_info {[
  { name => "query", description => "This is exactly what I searched for", placeholder => "e.g. Fuzzy Kitten Mittens on Fluffy Cats with Hats", type => "text", icon => "search" },
  { name => "pages", description => "The page(s) I wanted to find were", placeholder => "URLs would be nice here, but you can also be a little more broad in what you were looking for", type => "textarea", icon => "newspaper" },
  { name => "reasons", description => "The reason(s) the results seemed bad are", type => "textarea", placeholder => "e.g. not showing results for the word, 'apple' when I searched for, 'apple orchards'", icon => "sad-search" },
  { name => 'email', description => "Your email (not required)", placeholder => "We'd like to get back to you, but you can leave this blank.", type => "email", icon => "inbox", optional => 1 },  
  { name => 'hearabout', description => "Where did you hear about DuckDuckGo?", type => "text", icon => "dax", optional => 1 },
  { name => 'submit', description => "Send", icon => 'mail', cssclass => "fb-step--submit" }
]}

sub instant_info {[
  { name => "query", description => "This is exactly what I searched for", placeholder => "e.g. Fuzzy Kitten Mittens on Fluffy Cats with Hats", type => "text", icon => "search" },
  { name => "pages", description => "The Instant Answer(s) were bad because", placeholder => "Please tell us which Instant Answers should have shown. If an Instant Answer is showing and shouldn't be--please indicate that as well", type => "textarea", icon => "newspaper" },
  { name => 'email', description => "Your email (not required)", placeholder => "We'd like to get back to you, but you can leave this blank.", type => "email", icon => "inbox", optional => 1 },  
  { name => 'hearabout', description => "Where did you hear about DuckDuckGo?", type => "text", icon => "dax", optional => 1 },
  { name => 'submit', description => "Send", icon => 'mail', cssclass => "fb-step--submit" }
]}

1;
