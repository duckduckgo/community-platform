package DDGC::Feedback::Config::Partner;
# ABSTRACT:

use strict;
use warnings;

sub feedback_title { "I'd like to learn about partnerships with DuckDuckGo" }

sub feedback {[
  { description => "Please see our <a href='https://duck.co/help/company/partnerships'>partnership</a> and <a href='https://duckduckgo.com/api'>API</a> guidelines before answering the below", type => "info", icon => "newspaper" },
  { name => "partner_url", description => "What is the URL for your product or organization? ", type => "text", icon => "globe" },
  { name => "partner_description", description => "How do you see your organization and DuckDuckGo working together? ", type => "textarea", icon => "dax" },
  { name => 'hearabout', description => "Where did you hear about DuckDuckGo?", type => "text", icon => "dax", optional => 1 },
  { name => 'submit', description => "Send", icon => "mail", cssclass => "fb-step--submit" }
]}

1;
