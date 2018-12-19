#!/usr/bin/perl

use strict;
use warnings;

my @devices = glob('/dev/[h,s]d[a-z] /dev/nvme[0-9]n[0-9]');

if(@devices < 1) {
    exit 1;
} elsif(@devices == 1) {
    print $devices[0], "\n";
} else {
    my %disks;
    # Gather disk sizes
    open(PRG, "/sbin/fdisk -l |");
    while(my $line = <PRG>) {
        chomp($line);
        if($line =~ s!Disk (/dev/[^:]+):\s*([^,]+,\s*)(\d+)(.*)!!) {
            $disks{$1} = {
                size => $3,
                desc => "$2$3$4"
            };
        }
    }
    my @sorted_devs = sort {
        $disks{$b}->{size} <=> $disks{$a}->{size}
    } @devices;
    my $choice = '';
    while(!$choice) {
        my $count = 1;
        print STDERR "\nChoose harddisk to use for installation:\n";
        for my $key (@sorted_devs) {
            print STDERR "[", $count++, "]: $key, ", $disks{$key}->{desc}, "\n";
        }
        print STDERR "[q]: abort\n";
        print STDERR "\nSelect disk> ";
        my $input = <STDIN>;
        chomp($input);
        if($input =~ m!^\d+$! and $sorted_devs[$input - 1]) {
            print $sorted_devs[$input - 1], "\n";
            exit;
        } elsif($input eq 'q') {
            exit 1;
        }
    }
    
}
