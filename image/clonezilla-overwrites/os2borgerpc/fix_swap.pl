#!/usr/bin/perl

use strict;
use warnings;

my $dev = $ARGV[0];

die "No device specified" unless($dev and $dev =~ m!^/dev/.+!);

my $hddev = $dev . "1";
my $swapdev = $dev . "5";

my $uuid = "";
open(PRG, "sudo mkswap $swapdev 2>&1 |") or die "Couldn't run mkswap";
while(my $line = <PRG>) {
    if($line =~ m!UUID=(\S+)!) {
        $uuid = $1;
    }
}
close(PRG);

die "Couldn't read uuid from mkswap" unless($uuid);

print STDERR "Changing swap UUID to $uuid\n";

system(qw(sudo mkdir /tmp/hd-mnt));
system(qw(sudo mount), $hddev, qw(/tmp/hd-mnt));

my $content = "";

open(FH, "/tmp/hd-mnt/etc/fstab") or die "Couldn't open fstab";
while(my $line = <FH>) {
    $line =~ s/^UUID=(\S+)(\s+none\s+swap.*)/UUID=${uuid}$2/;
    $content .= $line;
}
close(FH);

open(FH, ">/tmp/hd-mnt/etc/fstab") or die "Couldn't open fstab for writing";
print FH $content;
close(FH);

system(qw(sudo umount /tmp/hd-mnt));
system(qw(sudo rmdir /tmp/hd-mnt));
