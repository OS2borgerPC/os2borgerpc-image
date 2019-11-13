#!/usr/bin/perl

use Data::Dumper;

my %specials;

my $arch = system("grep flags /proc/cpuinfo | grep ' lm ' > /dev/null") == 0 ?
    "64bit" :
    "32bit";

my %prioritized = (
    local_current => 200,
    local_latest => 150,
    current => 100,
    latest => 50,
);

my @list = map {$_} keys %prioritized;
my %arch_prioritized = map {
    ("${_}_${arch}" => $prioritized{$_})
} keys %prioritized;

# If a folder is named bibos_default it should always have the highest priority
$arch_prioritized{bibos_default} = 1000;

my @folders;

for my $fn (glob('/home/partimag/*')) {
    my $name = $fn;
    $name =~ s!^/home/partimag/!!;
    # Resolve any symlinks
    if(-l $fn) {
        $fn = `readlink -f "$fn"`;
        $fn =~ s!\s+$!!s;
    }
    next unless(-d $fn);
    $fn =~ s!^/home/partimag/!!;
    $arch_prioritized{$name}++;
    push(@folders, {
        name => $name,
        value => $fn,
        description => $name eq $fn ? $name : "$name ($fn)"
    });
}

# If there's only one candidate, there's only one choice
if(@folders == 1) {
    print $folders[0]->{value}, "\n";
    exit;
}

# Sort by priority followed by name
@folders = sort {
    my $cmp = $arch_prioritized{$b->{name}} <=> $arch_prioritized{$a->{name}};
    return $cmp == 0 ? $b->{name} cmp $b->{name}: $cmp;
} @folders;

my $choice = -1;
eval {
    local $SIG{ALRM} = sub { die "TIMEOUT!" };
    while($choice < 0) {
        my $default = $folders[0]->{name};
        print STDERR "\n\n" .
            "Select which image to use. If no selection is made within\n" .
            "30 seconds, the image $default will be used\n\n";
        my $nr = 1;
        for my $f (@folders) {
            print STDERR "[", $nr++, "] ", $f->{description}, "\n";
        }
        print STDERR "\nSelect image or type 'q' to abort> ";
        alarm(30);
        my $input = <STDIN>;
        alarm(0);
        chomp($input);
        last if($input eq 'q');
        $choice = $input - 1 if($input =~ m!^\d+$! and $folders[$input - 1]);
    }
};
if($@ and $@ =~ m/TIMEOUT!/) {
    $choice = 0;
}

if($choice == -1) {
    print STDERR "No image chosen, aborting\n";
    exit 1;
}

print STDERR "\n";
print $folders[$choice]->{value}, "\n";
