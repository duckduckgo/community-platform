package DDGC::Feedback::Config::Love;
# ABSTRACT:

use strict;
use warnings;

sub feedback_title { 'I want to tell you about something I love!' }

sub feedback {[
  { description => "Everyone seems to find something they particularly love about DuckDuckGo. Whether it's <a href='https://duckduckgo.com/privacy'>privacy</a>, <a href='https://duckduckgo.com/goodies'>Instant Answers</a>, <a href='https://duckduckgo.com/bang.html'>!bangs</a>, or a variety of other features --- we always love to hear what makes you smile. Please, use the box below to elaborate:", type => "info", icon => "newspaper" },
  { name => "love", description => "I love", type => "textarea", placeholder => "It would be pretty self-serving to give you a suggestion here, don't you think?", icon => "heart" },
  { name => 'email', description => "Your email (not required)", placeholder => "Leave blank to love us anonymously, from afar.  Creepy.", type => "email", icon => "inbox", optional => 1 },  
  { name => 'hearabout', description => "Where did you hear about DuckDuckGo?", type => "text", icon => "dax", optional => 1 },
  { name => 'submit', description => "Send", icon => "mail", cssclass => "fb-step--submit" }
]}

1;
