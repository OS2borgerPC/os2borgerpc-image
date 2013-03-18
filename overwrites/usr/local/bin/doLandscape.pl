#!/usr/bin/perl

use strict;

my $landscape_cmd = $ARGV[0];

print STDOUT "Vil du tilmelde denne computer til Landscape [y | n] ? ";
my $answ = <STDIN>;
chomp $answ;
if ( $answ =~ /^[yY]$/ ) {
   `xterm -fn 10x20 -e $landscape_cmd`;
}  
