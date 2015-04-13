#!/usr/bin/perl
use strict;

#Set up variables
my $num=1;
my @array;
my $sum;

#If the number is even, add to back of array, add to front of array if even
while ($num != 0) {
	print "Please input a number: \n";
	$num = <STDIN>;
        if ($num>0) {
                push (@array, $num);
        } elsif ($num<0) {
                unshift (@array, $num);
        }
}
print "You entered zero, program terminated\n";

#Print the array on one line
chomp @array;
print join('.',@array), "\n";

#Print the sum
foreach my $n (@array) {
	$sum = $sum + $n;
}
print("The sum is : ", $sum, "\n");
