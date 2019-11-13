#!/usr/bin/perl

use strict;
use warnings;

use Socket;
use IO::Select;

open(CMD, "/sbin/ifconfig|") or die "Could not run ifconfig";
my $dev = "";
my @bc_addresses;
while(my $line = <CMD>) {
    if($line =~  m!^(eth\d+)!) {
	$dev = $1;
    } elsif($line =~ m!^\S+!) {
	$dev = '';
    } elsif($line =~ m!Bcast:(\S+)!) {
	push(@bc_addresses, $1);
    }
}

for my $addr (@bc_addresses) {
    socket(my $socket, AF_INET, SOCK_DGRAM, getprotobyname('udp'));
    setsockopt($socket, SOL_SOCKET, SO_BROADCAST, 1);

    my $destpaddr = sockaddr_in(42420, inet_aton($addr));

    send($socket, 'Hello', 0, $destpaddr);

    my $wait = IO::Select->new($socket);

    if (my ($found) = $wait->can_read(5)) {
	my $srcpaddr = recv($socket, my $data, 100, 0);
	if($data =~ m!OS2borgerPC-server:(\S+)!) {
	    print "$1\n";
	    last;
	}
    }

    close $socket;
}

