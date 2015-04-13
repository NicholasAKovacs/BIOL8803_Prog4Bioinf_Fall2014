#!/usr/bin/perl -w
use strict;

#Open file, which is the first argument
open FILE, $ARGV[0];

#Set up the variables
my @col0=();
my @col1=();
my @col2=();
my %count0;
my %count1;
my %count2;

#Divide the lines into the columns and add that column input to an array
while ( my $line = <FILE>) {
	chomp($line);
	my @fields=split / /, $line;
	push(@col0, $fields[0]);
	push(@col1, $fields[1]);
	push(@col2, $fields[2]);
}

#Count each unique word of the arrays
foreach my $entry0 (@col0) {
	$count0{$entry0}++;
}

foreach my $entry1 (@col1) {
        $count1{$entry1}++;
}

foreach my $entry2 (@col2) {
        $count2{$entry2}++;
}

#Output: "word --> count"
print "\nColumn 1:\n";
foreach my $key (keys %count0) {
	print "$key --> $count0{$key}\n";
}

print "\nColumn 2:\n";
foreach my $key (keys %count1) {
        print "$key --> $count1{$key}\n";
}

print "\nColumn 3:\n";
foreach my $key (keys %count2) {
        print "$key --> $count2{$key}\n";
}

