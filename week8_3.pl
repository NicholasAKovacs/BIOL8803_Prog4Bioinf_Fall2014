#!/usr/bin/perl -w
use strict;
use warnings;
use Statistics::Basic qw(:all nofill);

#Open file, which is the first argument
open FILE, $ARGV[0];

#Set up the variables
my @genoStart;
my @genoEnd;
my @GeneLength;
my $LineCount;
my $PosCount;
my $NegCount;
my $GeneAverage;

#Count the number of lines. Divide the lines into columns.  Parse the relevant columns into appropriate arrays.
my $first;
while ( my $line = <FILE>) {
        $first++ or next;
	$LineCount++;
        my @fields=split("\t", $line);
	if ($fields[9] eq "+") {
		$PosCount++;
	} else {
		$NegCount++;
	}
        push(@genoStart, $fields[6]);
	push(@genoEnd, $fields[7]);
	push(@GeneLength, $fields[7]-$fields[6]);
}

#Sum the lengths of all the genes
my $GeneSum = 0;
foreach (@GeneLength) {
	$GeneSum += $_;
}

#Find the average gene length
$GeneAverage = ($GeneSum/$LineCount);

#Find the minimum and maximum length of the genes
my ($min, $max);
for (@GeneLength) {
	$min = $_ if !$min || $_ < $min;
	$max = $_ if !$max || $_ > $max;
}

#Find the standard deviation
my $stddev = stddev(@GeneLength);

print "Number of entries in $ARGV[0]: $LineCount\n";
print "The total length of genes: $GeneSum bp\n";
print "Number of entries on positive strand: $PosCount\n";
print "Number of entries on negative strand: $NegCount\n";
print "The longest gene: $max bp\n";
print "The shortest gene: $min bp\n";
print "The average gene length: $GeneAverage bp\n";
print "The standard deviation of all genes: $stddev\n";
