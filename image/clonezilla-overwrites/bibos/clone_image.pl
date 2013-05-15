#!/usr/bin/perl

use strict;
use warnings;

my $dev = $ARGV[0];

die "No disk device specified" unless($dev);

die "Not a proper disk device $dev"
    unless(-e $dev and $dev =~ m!^/dev/[hs]d[a-z]$!);
    
my $image = $ARGV[1] || 'bibos';

my $target = $dev . "1";
$target =~ s!^/dev/!!;

system(
    '/usr/sbin/ocs-sr',
    qw(-g auto),        # Restore grub after cloning
    qw(-e1 auto),       # Automatically adjust filesystem geometry for a NTFS
                        # boot partition if exists
    '-e2',              # sfdisk uses CHS of hard drive from EDD
                        # (for non-grub boot loader)
    '-nogui',           # Don't use the gui
    '-batch',           # Run in batch mode (no confirmations?)
    '-r',               # Resize cloned image to fit partition size
    '-j2',              # Clone the hidden data between MBR and 1st partition
    '-k',               # Do NOT create a partition table on the target disk
    qw(-p true),        # Do nothing when done
    qw(restoreparts),   # Restore a partition
    $image,             # Name of image to use
    $target             # Target device
);
