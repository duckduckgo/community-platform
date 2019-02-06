package DDGC::Feedback::Config::Bug;
# ABSTRACT:

use strict;
use warnings;

sub feedback_title { 'I need to report a bug!' }

sub feedback {[
  { description => "It's a bug on mobile (e.g. phone, tablet, media device)", icon => "phone" },
      bug_mobile(),
  { description => "It's a bug on Desktop (good ole' fashion computers)", icon => "browser" },
      bug_desktop(),
  { description => "It's a security issue", icon => "bug", type => "external", link => "https://hackerone.com/duckduckgo" }
]}

sub bug_mobile {[
  { description => "The bug is in the DuckDuckGo app", icon => "dax" },
      bug_site_area(\&bug_mobile_app),
  { description => "The bug is with DuckDuckGo in a 3rd party app or mobile browser (e.g. Safari, iCab, Dolphin)", icon => "ddg-phone" },
      bug_site_area(\&bug_mobile_thirdparty),
]}

sub bug_mobile_thirdparty {[
  { description => "I have an iOS device", icon => "apple" },
      bug_mobile_thirdparty_ios(),
  { description => "I have an Android device", icon => "android" },
      bug_mobile_thirdparty_android(),
  { description => "I have a Windows mobile device", icon => "windows8" },
      bug_mobile_thirdparty_windows(),
  { description => "I have a different type of mobile device than those listed above", icon => "phone" },
      bug_mobile_thirdparty_other(),
]}

sub bug_mobile_app {[
  { description => "I have an iOS device", icon => "apple" },
      bug_mobile_app_ios(),
  { description => "I have an Android device", icon => "android" },
      bug_mobile_app_android(),
]}

sub bug_desktop {[
  { description => "It’s a problem with the DuckDuckGo site", icon => "dax" },
      bug_site_area(\&bug_desktop_site),
  { description => "It’s a problem with a DuckDuckGo browser addon", icon => "ddg-browser" },
      bug_desktop_addon(),
]}

sub bug_desktop_site {[
  { description => "I have a Windows computer", icon => "windows8" },
      bug_desktop_site_windows(),
  { description => "I have a Mac computer", icon => "finder" },
      bug_desktop_site_mac(),
  { description => "I have a Linux-based computer", icon => "tux" },
      bug_desktop_site_linux(),
  { description => "I have a different type of computer than those listed above", icon => "dax" },
      bug_desktop_site_other(),
]}

sub bug_desktop_addon {[
  { description => "I’m using your Firefox addon", icon => "firefox" },
      bug_desktop_addon_firefox(),
  { description => "I’m using your Chrome addon", icon => "chrome" },
      bug_desktop_addon_chrome(),
  { description => "I’m using your Safari addon", icon => "safari" },
      bug_desktop_addon_safari(),
  { description => "I’m using your Internet explorer addon", icon => "IE" },
      bug_desktop_addon_ie(),
  { description => "I’m using your Opera addon", icon => "opera" },
      bug_desktop_addon_opera(),
]}

sub bug_site_area {
  my ($next) = @_; [
  { description => "It's an issue with Images", icon => "search" },
    $next->(),
  { description => "It's an issue with Videos", icon => "search" },
    $next->(),
  { description => "It's an issue with Places", icon => "search" },
    $next->(),
  { description => "It's an issue with Products", icon => "search" },
    $next->(),
  { description => "It's an issue with Autosuggest", icon => "search" },
    $next->(),
  { description => "It's not related to any of these", icon => "search" },
    $next->(),
]}


#-----------------------------------------------------------------

sub include_bug {
  { name => 'bug', description => "The bug is", placeholder => "Please describe the bug as best you can!", type => "textarea", icon => "bug",},
  { name => 'email', description => "Your email (not required)", placeholder => "We'd like to get back to you, but you can leave this blank.", type => "email", icon => "inbox", optional => 1 },
  { name => 'bug_steps', description => "You can reproduce it by", type => "textarea", optional => 1, placeholder => "Step-by-step instructions please", icon => "coffee" },
  { name => 'bug_other', description => $_[0] || "Other helpful info", type => "textarea", optional => 1, placeholder => 'e.g. only happens when the moon is waxing and you have underwear on your head.', icon => "folder",},
  { name => 'hearabout', description => "Where did you hear about DuckDuckGo?", type => "text", icon => "dax", optional => 1 },
  { name => 'submitreport', description => "Send", type => "submit", icon => "mail", cssclass => "fb-step--submit"},
}

#-----------------------------------------------------------------

sub include_bug_app {
  { name => 'bug_app', description => "The app with the bug is called", type => "text", placeholder => "e.g. Upset Ducks", icon => "windows"},
}

sub bug_mobile_thirdparty_android {[
  { name => 'android_mobile', description => 'My device is a', type => "text", placeholder => "e.g. Samsung Galaxy S3, HTC One", icon => "android" },
  include_bug_app(),
  include_bug(),
]}

sub bug_mobile_thirdparty_ios {[
  { name => 'ios_mobile', description => 'My device is a', type => "text", placeholder => "e.g. Apple iPhone 5, iPad", icon => "apple" },
  include_bug_app(),
  include_bug(),
]}

sub bug_mobile_thirdparty_windows {[
  { name => 'windows_mobile', description => 'My device is a', type => "text", placeholder => "e.g. Nokia Lumia 1020, Microsoft Surface Pro", icon => "windows8" },
  include_bug_app(),
  include_bug(),
]}

sub bug_mobile_thirdparty_other {[
  { name => 'other_mobile', description => 'My device is a', type => "text", placeholder => "e.g. Blackberry Z10, Kivo tablet", icon => "phone" },
  include_bug_app(),
  include_bug(),
]}

sub bug_mobile_app_android {[
  { name => 'android_mobile', description => 'My device is a', type => "text", placeholder => "e.g. Samsung Galaxy S3, HTC One", icon => "android" },
  include_bug(),
]}

sub bug_mobile_app_ios {[
  { name => 'ios_mobile', description => 'My device is a', type => "text", placeholder => "e.g. Apple iPhone 5, iPad", icon => "apple" },
  include_bug(),
]}

sub bug_mobile_app_windows {[
  { name => 'windows_mobile', description => 'My device is a', type => "text", placeholder => "e.g. Nokia Lumia 1020, Microsoft Surface Pro", icon => "windows8" },
  include_bug(),
]}

sub bug_mobile_app_other {[
  { name => 'other_mobile', description => 'My device is a', type => "text", placeholder => "e.g. Blackberry Z10, Kivo tablet", icon => "phone" },
  include_bug(),
]}

sub bug_security {[
  { description => "We appreciate you helping to make DuckDuckGo a safer place. Please tell us about the issue below:", type => "info", icon => "newspaper" },
  { name => 'bug', description => "The security issue is", placeholder => "Please describe the issue in as much detail as possible.", type => "textarea", icon => "bug",},
  { name => 'email', description => "Your email (not required)", placeholder => "We'd like to get back to you, but you can leave this blank.", type => "email", icon => "inbox", optional => 1 },
  { name => 'hearabout', description => "Where did you hear about DuckDuckGo?", type => "text", icon => "dax", optional => 1 },
  { name => 'submitreport', description => "Send", type => "submit", icon => "mail", cssclass => "fb-step--submit"},
]}

#-----------------------------------------------------------------

sub include_os {
  my ( $name, $placeholder, %args ) = @_;
  { name => $name.'_os', description => 'My operating system is', type => "text", placeholder => $placeholder, %args },
}

sub include_os_windows { include_os( name => "windows", placeholder => "e.g. Windows XP, Windows 8", icon => "windows8" ) }
sub include_os_mac { include_os( name => "mac", placeholder => "e.g. Mac OSX 10.7.5", icon => "finder" ) }
sub include_os_linux { include_os( name => "linux", placeholder => "e.g. Ubuntu 13.0.4, Linux Mint", icon => "tux" ) }
sub include_os_other { include_os( name => "other", placeholder => "e.g. EROS, LEGO Mindstorms brickOS", icon => "windows" ) }

sub include_browser {
  my ( $name, $placeholder, %args ) = @_;
  { name => $name.'_browser', description => 'The browser I use is', type => "text", placeholder => $placeholder, %args },
}

sub include_browser_windows { include_browser( name => "windows", placeholder => "e.g. Internet Explorer 8, Firefox 23, Chrome 28", icon => "IE" ) }
sub include_browser_mac { include_browser( name => "mac", placeholder => "e.g. Safari 6.0.5, Firefox, Chrome", icon => "safari" ) }
sub include_browser_linux { include_browser( name => "linux", placeholder => "e.g. Firefox 23, Epiphany 3.8.2", icon => "firefox" ) }
sub include_browser_other { include_browser( name => "other", placeholder => "e.g. Nintendo DS Browser", icon => "browser" ) }

sub include_bug_desktop {
  include_bug("Other helpful info (e.g. Do you use any custom DuckDuckGo settings? Do you have any other addons installed to your browser? Did you disable JavaScript?)");
}

sub bug_desktop_site_windows {[
  include_os_windows(),
  include_browser_windows(),
  include_bug_desktop(),
]}

sub bug_desktop_site_mac {[
  include_os_mac(),
  include_browser_mac(),
  include_bug_desktop(),
]}

sub bug_desktop_site_linux {[
  include_os_linux(),
  include_browser_linux(),
  include_bug_desktop(),
]}

sub bug_desktop_site_other {[
  include_os_other(),
  include_browser_other(),
  include_bug_desktop(),
]}

sub include_addon_os {
  include_os( addon => "e.g. Windows 8, MacOSX 10.7.5", icon => "browser" )
}

sub include_addon_version {
  my ( $name, $placeholder, %args ) = @_;
  { name => $name.'_version', description => "My browser version is", type => "text", placeholder => $placeholder, optional => 1, %args }
}

sub bug_desktop_addon_firefox {[
  include_addon_os(),
  include_addon_version( name => "firefox", placeholder => "e.g. 21, 22, 23", icon => "firefox" ),
  include_bug_desktop(),
]}

sub bug_desktop_addon_chrome {[
  include_addon_os(),
  include_addon_version( name => "chrome", placeholder => "e.g. 28.0.1500.95", icon => "chrome" ),
  include_bug_desktop(),
]}

sub bug_desktop_addon_safari {[
  include_addon_os(),
  include_addon_version( name => "safari", placeholder => "e.g. 6.0.5", icon => "safari" ),
  include_bug_desktop(),
]}

sub bug_desktop_addon_ie {[
  include_addon_os(),
  include_addon_version( name => "firefox", placeholder => "e.g. 7, 8, 9", icon => "IE" ),
  include_bug_desktop(),
]}

sub bug_desktop_addon_opera {[ 
  include_addon_os(),
  include_addon_version( name => "opera", placeholder => "e.g. 12, 15, Next", icon => "opera" ),
  include_bug_desktop(),  
]}

#-----------------------------------------------------------------

1;
