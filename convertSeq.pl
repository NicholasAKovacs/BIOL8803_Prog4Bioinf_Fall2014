#!/usr/bin/perl -w
use strict;
use warnings;
use Bio::SeqIO;

my $usage = "x2y.pl infinite infileformat outfile outfileformat\n";
my $infile = shift or die $usage;
my $infileformat = shift or die $usage;
my $outfile = shift or die $usage;
my $outfileformat = shift or die $usage;

my $seq_in = Bio::SeqIO->new(
	-file => "<$infile",
	-format => $infileformat
	);
my $seq_out = Bio::SeqIO->new(
	-file => ">$outfile",
	-format => $outfileformat,
	);

while (my $inseq = $seq_in->next_seq) {
	$seq_out->write_seq($inseq);
}
