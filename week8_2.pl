#!/usr/bin/perl -w
use strict;

#Open file, which is the first argument
open FILE, $ARGV[0];

#Set up the global variables
my @Name;
my @Class;
my @Family;
my %countName;
my %countClass;
my %countFamily;

#Divide the lines into the columns and add that column input to an array
my $skipline1;
while ( my $line = <FILE>) {
	$skipline1++ or next;
	chomp($line);
	my @fields=split /\t/, $line;
	push(@Name, $fields[10]);
	push(@Class, $fields[11]);
	push(@Family, $fields[12]);
}

#Count each unique word of the arrays
foreach my $entry0 (@Name) {
	$countName{$entry0}++;
}

foreach my $entry1 (@Class) {
        $countClass{$entry1}++;
}

foreach my $entry2 (@Family) {
        $countFamily{$entry2}++;
}

#Output: "word --> count"
print "\nrepName:\n";
foreach my $key (keys %countName) {
	print "$key --> $countName{$key}\n";
}

print "\nrepClass:\n";
foreach my $key (keys %countClass) {
        print "$key --> $countClass{$key}\n";
}

print "\nrepFamily:\n";
foreach my $key (keys %countFamily) {
        print "$key --> $countFamily{$key}\n";
}

