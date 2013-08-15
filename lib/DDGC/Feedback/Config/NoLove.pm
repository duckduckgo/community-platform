package DDGC::Feedback::Config::NoLove;

use strict;
use warnings;

sub feedback_title { "I want to tell you about something I don't love" }

sub feedback {[
  { description => "We're always looking for ways to improve and we really appreciate you reaching out with your suggestions. Please let us know how we can do better by dropping us a short description in the box below:", type => "info", icon => "newspaper" },
  { name => "no_love", description => "I don't love", placeholder => "We _can_ handle the truth!", type => "textarea", icon => "trash" },
  { name => 'email', description => "Your email (not required)", placeholder => "We'd like to get back to you, but you can leave this blank.", type => "email", icon => "inbox", optional => 1, },  
  { name => 'submit', description => "Send Feedback", icon => "mail", cssclass => "fb-step--submit" }
]}

1;
