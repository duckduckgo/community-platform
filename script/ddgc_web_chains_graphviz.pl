#!/usr/bin/env perl

use utf8;

use strict;
use warnings;
use FindBin;
use lib $FindBin::Dir . "/../lib"; 

use DDGC::Web;

my ($c) = grep $_->isa('Catalyst::DispatchType::Chained'), @{DDGC::Web->dispatcher->dispatch_types};

# graphviz nodes, graphviz links
my ( %gn, %gl );

for (values %{$c->_actions}) {
	my $nn = nn($_->reverse);
	my %gnd;
	$gnd{style} = 'filled';
	if (defined $_->attributes->{Args}) {

		my $args = $_->attributes->{Args}->[0];
		my @parts = (defined($args) ? (("*") x $args) : '...');
		my @parents = ();
		my $parent = "DUMMY";
		my $curr = $_;
        while ($curr) {
            if (my $cap = $curr->attributes->{CaptureArgs}) {
                unshift(@parts, (("*") x $cap->[0]));
            }
            if (my $pp = $curr->attributes->{PathPart}) {
                unshift(@parts, $pp->[0])
                    if (defined $pp->[0] && length $pp->[0]);
            }
            $parent = $curr->attributes->{Chained}->[0];
            $curr = $c->_actions->{$parent};
            unshift(@parents, $curr) if $curr;
        }

		$gnd{label} = '/'.join('/',@parts); #.'\n'.$_->{attributes}->{Args}->[0].' Args';
		my $url = 'wiki:Community/Web/Action';
		for (split('___',$nn)) {
			$url .= '/'.ucfirst($_);
		}
		$gnd{URL} = $url;
		$gnd{color} = 'yellow';

	} else {

		$gnd{color} = 'white';
		$gnd{label} = $_->reverse; #.'\n'.$_->{attributes}->{CaptureArgs}->[0].' Captures';
		$gnd{URL} = '';

	}
	$gl{$nn} = nn($c->_actions->{$_->{attributes}->{Chained}->[0]}->reverse) if $_->{attributes}->{Chained}->[0] && $_->{attributes}->{Chained}->[0] ne '/';
	$gn{$nn} = \%gnd;
}

print "{{{
#!graphviz
graph {

  rankdir = \"RL\";
  shape = \"oval\";

";
for (keys %gn) {
	print '  node [';
	for my $k (keys %{$gn{$_}}) {
		print ' '.$k.'="'.$gn{$_}->{$k}.'" ';
	}
	print ']; '.$_.'; '."\n";
}
print "\n";
for (keys %gl) {
	print '  '.$gl{$_}.' -- '.$_.';'."\n";
}
print "
}
}}}
";

sub nn { my $var = shift; $var =~ s/\//___/g; return $var; }
