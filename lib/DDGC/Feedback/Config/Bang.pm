package DDGC::Feedback::Config::Bang;

use strict;
use warnings;

sub feedback_title { 'I’d like to submit a new !bang or report a broken !bang.' }

sub feedback {[
  { description => 'To submit new <a href="https://duckduckgo.com/bang.html">!bangs</a>, use this page: <a href="https://duckduckgo.com/newbang">https://duckduckgo.com/newbang</a>.', type => "info", icon => "newspaper" },
  { description => 'Let us know about a broken !bang', icon => "bang" },
    broken_bang(),
]}

sub broken_bang {[
  { name => "bang", description => "The !bang that doesn’t work is", type => "text", placeholder => "e.g. !wikipedia, !so, !ebay", icon => "bang" },
  { name => "issue", description => "The issue is that", type => "textarea", placeholder => "e.g. the site returns an error, the site no longer exists", icon => "bug" },
  { name => 'email', description => "Your email (not required)", placeholder => "We'd like to get back to you, but you can leave this blank.", type => "email", icon => "inbox", optional => 1},
  { name => 'submit', description => "Send", cssclass => "fb-step--submit", icon => "mail" }
]}

1;
