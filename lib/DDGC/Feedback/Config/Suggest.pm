package DDGC::Feedback::Config::Suggest;
# ABSTRACT:

use strict;
use warnings;

sub feedback_title { "I have something to share." }

sub feedback {[
  { description => "DuckDuckGo discussions come in 2 forms: <b>Instant Answer Ideas</b> and <b>General Ramblings</b>. Please let us know what you'd like to talk about!", type => 'info', icon => "dax" },
  { description => "It's a suggestion for an instant answer", icon => "sun" },
    suggest_instant(),
  { description => "It's a general topic (or click here if you are unsure)", icon => "convo" },
    suggest_idea(),
]}

sub suggest_instant {[
  {
    description => "Please view the current instant answers at our goodies page on: https://duckduckgo.com/goodies",
    icon => "search", type => "external",
    link => "https://duckduckgo.com/goodies",
  },
  {
    description => "Check if someone already has suggested your idea at our instant answer suggestion page.",
    icon => "sun", type => "link",
    link => ['Ideas','index'],
  },
  {
    description => "I can't find it, I want to share my instant answer idea",
    icon => "chat", type => "link",
    link => ['Ideas','newidea'],
  },
  "" # workaround for non submittable ending points like this here.
]}

sub suggest_idea {[
  {
    description => "View our Help Docs to see if it's already covered at: https://dukgo.com/help",
    icon => "search", type => "link",
    link => ['Help','index','en_US'],
  },
  {
    description => "Check our forum to see if someone is currently discussing your idea: https://dukgo.com/forum",
    icon => "convo", type => "link",
    link => ['Forum','index'],
  },
  {
    description => "I can't find it, I want to share my topic",
    icon => "chat", type => "link",
    link => ['Forum::My','newthread'],
  },
  "" # workaround for non submittable ending points like this here.
]}

1;
