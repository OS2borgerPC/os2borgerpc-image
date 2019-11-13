#!/usr/bin/perl

# TODO: find hostname of local server, if present

my $hostname = "os2borgerpc-admin.magenta-aps.dk";

my $local_hostname = `sudo /live/image/os2borgerpc/find_os2borgerpc_server.pl`;
if($local_hostname and $local_hostname =~ m!(\d+\.\d+\.\d+\.\d+)!) {
    print STDERR "Using local server on $1\n";
    $hostname = $1;
}

system(qw(cp -r /live/image/os2borgerpc/ssh /home/ssh));
system('chmod 0400 /home/ssh/*');

system(
    qw(sudo sshfs),
    "${hostname}:/archive/hd",
    qw(/home/partimag -F /home/ssh/config),
    qw(-o uid=1000 -o gid=1000 -o allow_other)
) == 0 or die "Could not mount remote file system";
