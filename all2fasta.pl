#!/usr/bin/perl -w
use strict;
use warnings;

# File is read as first argument
open FILE, $ARGV[0];

#_________________Global variables are created__________________

my $EMBL=0;
my $FASTQ=0;
my $GB=0;
my $MEGA=0;
my $PIR=0;
# This variable is used to discriminate file type by the first line
my $HeaderLineCount=0;
# This variable is used to determine if file is protein seq
my $protein;
# This variable is used to determine if file is nucleotide seq
my $nucleotide;
# This variable will be used to store the lines containing the genomic/proteiomic seq
my @SeqLine;

#_________________Program_______________________________________

# Read file line by line
while (my $line = <FILE>) {
	# EMBL file detection this contains nucleotide seq
	if ($HeaderLineCount==0 and $line =~ m/(^ID[\s]{3})/m) {
		$EMBL++;
		$nucleotide++;
	}
	# Lines with sequence are added to array @SeqLine if EMBL file is inputted
        if ($EMBL!=0 and $line =~ m/^[\s]{5}/m) {
                push(@SeqLine,$line);
		print $line;
        }
        # FASTQ file detection this contains nucleotide seq
	if ($HeaderLineCount==0 and $line =~ m/^@/m) {
                $FASTQ++;
		$nucleotide++;
        }
	# Lines with sequence are added to array @SeqLine if FastQ file is inputted
        if ($FASTQ!=0 and $line =~ m/^[GCTA]/m) {
                push(@SeqLine,$line);
		print $line;
        }
        # GenBank file detection this contains protein seq
        if ($HeaderLineCount==0 and $line =~ m/^LOCUS/m) {
                $GB++;
		$protein++;
        }
        # Lines with sequence are added to array @SeqLine if GenBank file is inputted
        if ($GB!=0 and $line =~ m/^([\s]{6,8}[0-9]{1,3}[\s]{1}[acdefghiklmnpqrstvwy\s]+)/m) {
                push(@SeqLine,$line);
		print $line;
        }
        # MEGA file detection this contains nucelotide seq
        if ($HeaderLineCount==0 and $line =~ m/^#mega/m) {
                $MEGA++;
		$nucleotide++;
        }
        # Lines with sequence are added to array @SeqLine if MEGA file is inputted
        if ($MEGA!=0 and  $line =~ m/^(#[A-Z0-9\s]{21})/m) {
                push(@SeqLine,$line);
		print $line;
        }
        # PIR file detection this contains protein seq
        if ($HeaderLineCount==0 and $line =~ m/^>[A-Z0-9]+;/m) {
                $PIR++;
		$protein++;
        }
        # Lines with sequence are added to array @SeqLine if PIR file is inputted
        if ($PIR!=0 and  $line =~ m/^[ACDEFGHIKLMNPQRSTVWY]+[\*]*[\n]$/m) {
                push(@SeqLine,$line);
		print $line;
        }
	# First line processsing, and therefore file detection, will be complete
        $HeaderLineCount++;
}

#______________________Output Code_____________________________

# Output file is created and named after input file with .fna if genomic or .faa if proteomic. Header is ">" followed by input file name.  Contents of file should be just the seq, but I am having a hard time figuring out why $1 is not working...
if ($nucleotide) {
	open(my $FILE, '>', "$ARGV[0].fna");
	print $FILE ">$ARGV[0]";
	foreach (@SeqLine) {
		if (m/[GCTAgcta]/g) {
			open(my $ADD2FILE, '>>', "$ARGV[0].fna");
			print $ADD2FILE "$1";
		}
	}
} elsif ($protein) {
        open(my $FILE, '>', "$ARGV[0].faa");
        print $FILE ">$ARGV[0]";
	foreach (@SeqLine) {
		if (m/[ACDEFGHIKLMNPQRSTVWYacdefghiklmnpqrstvwy]/g) {
			open(my $ADD2FILE, '>>', "$ARGV[0].faa");
			print $ADD2FILE "$1";
		}
	}

} else {
	print "File is not of EMBL, FASTQ, GenBank, MEGA, or PIR format or is not foramtted correctly";
}
