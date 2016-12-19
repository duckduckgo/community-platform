package DDGC::Feedback::Config::Suggest;
# ABSTRACT:

use strict;
use warnings;

use DDGC::Config;

=for comment

sub feedback_title { "I have something to share." }

sub feedback {[
  { 
	description => "DuckDuckGo discussions come in two forms: <b>Instant Answer Ideas</b> and <b>General Ramblings</b>. Please let us know what you'd like to talk about!", 
	type => 'info', 
	icon => "dax" 
  },
  { 
	description => "It's a general topic (or click here if you are unsure)", 
	icon => "convo",
	type => "link",
	link => ['Forum::My','newthread','1'],
  },
    # suggest_idea(),
  {
	description => "It's an idea for an Instant Answer (not a general suggestion!)",
	icon => "sun",
	type => "link",
	link => ['Ideas','newidea'],
  },
    # suggest_instant(),
  {
	description => "A new Internal forum post",
	icon => "convo",
	type => "link",
	link => ['Forum::My','newthread','4'],
	user_filter => DDGC::Config::forums->{'4'}->{'user_filter'},
  },
  {
	description => "A new Community Leaders forum post",
	icon => "convo",
	type => "link",
	link => ['Forum::My','newthread','2'],
	user_filter => DDGC::Config::forums->{'2'}->{'user_filter'},
  },
  "" # workaround for non submittable ending points like this here.
  # cutting this flow short to get a user to the 'new post' page sooner
]}

sub suggest_instant {[
  {
    description => "Please view the current Instant Answers at our goodies page on: https://duckduckgo.com/goodies",
    icon => "search", type => "external",
    link => "https://duckduckgo.com/goodies",
  },
  {
    description => "Check if someone already has suggested your idea at our Instant Answer ideas page.",
    icon => "sun", type => "link",
    link => ['Ideas','index'],
  },
  {
    description => "I can't find it, I want to share my Instant Answer idea",
    icon => "chat", type => "link",
    link => ['Ideas','newidea'],
  },
  "" # workaround for non submittable ending points like this here.
]}

sub suggest_idea {[
  {
    description => "View our Help Docs to see if it's already covered at: https://duck.co/help",
    icon => "search", type => "link",
    link => ['Help','index','en_US'],
  },
  {
    description => "Check our forum to see if someone is currently discussing your idea: https://duck.co/forum",
    icon => "convo", type => "link",
    link => ['Forum','index'],
  },
  {
    description => "I can't find it, I want to share my topic",
    icon => "chat", type => "link",
    link => ['Forum::My','newthread','1'],
  },
  "" # workaround for non submittable ending points like this here.
]}
=cut

1;
