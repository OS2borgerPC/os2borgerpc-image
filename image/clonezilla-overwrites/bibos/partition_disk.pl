#!/usr/bin/perl

use strict;
use warnings;

use Data::Dumper;

die "Not a Clonezilla system, aborting"
    unless (-d "/home/partimag" and -f "/live/image/Clonezilla-Live-Version");

my $dev = $ARGV[0];
die "No disk device specified" unless($dev);

die "Not a proper disk device $dev"
    unless(-e $dev and $dev =~ m!^/dev/[hs]d[a-z]$!);

my $swapsize = $ARGV[1];
die "No swap size specified" unless($swapsize);

die "Invalid swap size $swapsize"
    unless($swapsize =~ m!^\d+$!);

$swapsize += 2; # Need two extra megabytes to ensure correct disk alignment.

print STDERR "Preparing to partition disk $dev\n";
print STDERR "\n\nWARNING! This operation will completely destroy any existing data " .
        "on the following disk:\n";
system("/sbin/fdisk -l $dev >&2");
print "\n\nAre you sure you want to continue?\n";

while(1) {
    print STDERR "\nDestroy all data on disk $dev [y/n]> ";
    my $input = <STDIN>;
    chomp($input);
    if($input eq 'y') {
        last;
    } elsif($input eq 'n') {
        exit 1;
    }
}

print STDERR "\nRemoving old partitions on $dev\n";

my $empty_disk = <<EOT;
# partition table of /dev/sda
unit: sectors

/dev/sda1 : start=        0, size=        0, Id= 0
/dev/sda2 : start=        0, size=        0, Id= 0
/dev/sda3 : start=        0, size=        0, Id= 0
/dev/sda4 : start=        0, size=        0, Id= 0
EOT

open(PIPE, "|/sbin/sfdisk -L -q $dev >&2");
print PIPE $empty_disk;
close(PIPE);

print STDERR "Creating root partition and extended partition\n";
system(
    qw(/sbin/parted -s -a optimal --), $dev,
    qw(mkpart primary ext4 1), "-${swapsize}",
    qw(mkpart extended), "-${swapsize}", "-0",
    qw(mkpart logical linux-swap),
    "-" . ($swapsize - 1),
    "-1"
);
print STDERR "Done";
## Find size
#open(PRG, "/sbin/parted -s -a optimal -- $dev unit s print|");
#my ($start, $end);
#while(my $line = <PRG>) {
#    if($line =~ m!(\d+)s\s*(\d+)s\s*(\d+)s\s*extended!) {
#        $start = $1;
#        $end = $2;
#        last;
#    }
#}
#close(PRG);
#die "Could not find dimensions of extended partition"
#    unless($start and $end);
#
#print STDERR "Trying to make swap partition with full size\n";
#open(PRG, join(" ",
#    qw(/sbin/parted -s -a optimal --),
#    $dev,
#    qw(unit s mkpart logical linux-swap),
#    "${start}s", "${end}s", " 2>&1 |"
#));
#my $retry = 0;
#while(my $line = <PRG>) {
#    if($line =~ m!The closest location we can manage is (\d+)s to (\d+)s!) {
#        $start = $1;
#        $end = $2;
#        $retry = 1;
#        last;
#    }
#}
#if($retry) {
#    print STDERR "Creating swap partition with recommended size $start to $end\n";
#    system(
#        qw(/sbin/parted -s -a optimal --), $dev,
#        qw(mkpart logical linux-swap), "${start}s", "${end}s"
#    );
#} else {
#    print STDERR "Success\n"
#}
#
#print STDERR "Partitioning done\n";