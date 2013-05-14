#!/usr/bin/perl

use strict;
use warnings;

my $size;

open(FH, "/proc/meminfo");
while(my $line = <FH>) {
    if($line =~ m!MemTotal:\s*(\d+) kB!) {
        $size = int($1 / 1024);
        $size += 1 if($1 % 1024);
        last;
    }
}
close(FH);

if($size) {
    $size *= 2 if($size < 900);
    print $size, "\n";
} else {
    exit 1;
}