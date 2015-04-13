#!/usr/bin/perl
use strict;
use warnings;

open KNOWN, $ARGV[0];
open Kg, $ARGV[1];
open INFECT, $ARGV[2];

my @InfectName;
my $first;
while ( my $line = <INFECT> ) {
	$first++ or next;
	push(@InfectName, $line);
}

my %KnownHash;
my %KnownHashCoords;
while ( my $Knownline = <KNOWN> ) {
	my @Knownfields=split("\t", $Knownline);
	$KnownHash{$Knownfields[10]}=$Knownfields[0];
	$KnownHashCoords{$Knownfields[0]}="Start: $Knownfields[3], End: $Knownfields[4]";
}
#%KnownHash key is like NP_057112
#%KnownHash value is uc-something name

my %KgHash;
while ( my $Kgline = <Kg> ) {
	my @Kgfields=split("\t", $Kgline);
	$KgHash{$Kgfields[0]}=$Kgfields[4];
}
#%KgHash key is uc-something
#%Kghash value looks like INFECT

foreach my $Knownkey (keys %KnownHash) {
	foreach my $Kgkey (keys %KgHash) {
		if ($KnownHash{$Knownkey} eq $Kgkey) {
			foreach my $CoordsKey (keys %KnownHashCoords) {
				if ($CoordsKey eq $Kgkey) {
					print "$KgHash{$Kgkey}: $KnownHashCoords{$CoordsKey}\n";
				}
			}
		}
	}
}
