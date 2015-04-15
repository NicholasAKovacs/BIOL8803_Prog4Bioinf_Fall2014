#!/usr/bin/perl
use strict;
use warnings;

# Filenames will be taken as commandline arguments in the order -> knownGene.txt, kgXref.txt, InfectiousDisease-GeneSets.txt
# InfectiousDisease-GeneSets.txt contains names of genes involved in infectious diseases
# Outputs the genetic coordinates of the infections genes

open KNOWN, $ARGV[0];
open Kg, $ARGV[1];
open INFECT, $ARGV[2];

# Make an array of all the names from InfectiousDisease-GeneSets.txt
my @InfectName;
my $first;
while ( my $line = <INFECT> ) {
	$first++ or next;
	push(@InfectName, $line);
}

# Declare 2 hashes for KnownGene.txt
my %KnownHash;
my %KnownHashCoords;

# Fill the KnownHash with the alternate gene name (InfectiousDiseases has one name, KnownGene uses a different name)
# Fill KnownHashCoords with the start and end coordnates
while ( my $Knownline = <KNOWN> ) {
	my @Knownfields=split("\t", $Knownline);
	$KnownHash{$Knownfields[10]}=$Knownfields[0];
	$KnownHashCoords{$Knownfields[0]}="Start: $Knownfields[3], End: $Knownfields[4]";
}
#%KnownHash key is like NP_057112
#%KnownHash value is uc-something name

# Declare and fill a hash with the gene name conversions that are needed to go from the gene name in InfectiosDisease to KnownGene
my %KgHash;
while ( my $Kgline = <Kg> ) {
	my @Kgfields=split("\t", $Kgline);
	$KgHash{$Kgfields[0]}=$Kgfields[4];
}
#%KgHash key is uc-something
#%Kghash value looks like INFECT

# I know this nested loop is bad practice, but it works

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
