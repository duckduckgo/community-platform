package DDGC::Feedback::Config::Suggest;

use strict;
use warnings;

sub feedback_title { "I have a suggestion to share." }

sub feedback {[
  { description => "DuckDuckGo discussions come in 2 forms: <b>Instant Answer Ideas</b> and <b>General Ramblings</b>. Please let us know what you'd like to talk about!", type => 'info' },
  { description => "It's a suggestion for an instant answer", icon => "sun" },
    suggest_instant(),
  { description => "It's a general suggestion (or click here if you are unsure)" },
    suggest_idea(),
]}

sub suggest_instant {[
  {
    description => "Please view the current instant answers at our goodies page on https://duckduckgo.com/goodies",
    icon => "dax", type => "external",
    link => "https://duckduckgo.com/goodies",
  },
  {
    description => "Check if someone already has suggested your idea at our instant answer suggestion page.",
    icon => "windows", type => "link",
    link => ['Ideas','index'],
  },
  {
    description => "I can't find it, I want to share my instant answer idea",
    icon => "folder", type => "link",
    link => ['Ideas','newidea'],
  },
  "" # workaround for non submittable ending points like this here.
]}

sub suggest_idea {[
  {
    description => "Please view, if there is not already a help article on our help at https://dukgo.com/help about your idea",
    icon => "dax", type => "link",
    link => ['Help','index'],
  },
  {
    description => "Check our forum at https://dukgo.com/forum, if someone is currently discussing your idea",
    icon => "windows", type => "link",
    link => ['Forum','index'],
  },
  {
    description => "I can't find it, I want to share my suggestion",
    icon => "folder", type => "link",
    link => ['Forum::My','newthread'],
  },
  "" # workaround for non submittable ending points like this here.
]}

1;
