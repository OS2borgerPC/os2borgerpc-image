#!/usr/bin/perl

# TODO: find hostname of local server, if present

my $hostname = "web06.magenta-aps.dk";

system(qw(cp -r /live/image/bibos/ssh /home/ssh));
system('chmod 0400 /home/ssh/*');

system(
    qw(sudo sshfs),
    "${hostname}:/archive/hd",
    qw(/home/partimag -F /home/ssh/config),
    qw(-o uid=1 -o gid=1)
) == 0 or die "Could not mount remote file system";
