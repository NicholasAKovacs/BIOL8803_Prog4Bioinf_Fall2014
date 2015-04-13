#!/bin/sh

#__________Setting up command line options_________

#Turn off (FALSE) command line options that take no options, they will be turned on (TRUE) if given in the command

e=FALSE;
z=FALSE;
v=FALSE;
i=FALSE;
h=FALSE;

while getopts "a:b:r:o:ezvih" opt;
do
        case $opt in
                a) mate1=$OPTARG;;
                b) mate2=$OPTARG;;
                r) ref=$OPTARG;;
                o) out=$OPTARG;;
                e) e=TRUE;;
                z) z=TRUE;;
                v) v=TRUE;;
                i) i=TRUE;;
                h) h=TRUE;;
	esac
done

#_____________Print usage info_____________

if h=1;
then
        echo 
	"
	Devoloped by Nicholas Kovacs and completed on October 21, 2014, this pipeline aligns genomic reads, a and b, to a reference genome, r, 
	processes the alignment by converting it a bam file, sorting it, and improving the alignment.  It then calls the variants.
	
	Input command line options:
	
	a = input reads file1
	b = input reads file2
	r = reference genome file
	o = output VCF file name
	e = re-lignment, no arugments taken
	z = gunzip output VCF file, no argument taken
	v = print commands, no argument taken
	i = index output BAM file, no argument taken
	h = print usage information, no argument taken
	"
	exit
fi

#____________Variable checks____________

if [ -n $mate1 ];
	echo "Variable 'a' is missing an argument, please input a fasta file"
	exit
fi

if [ -n $mate2 ];
	echo "Variable 'b' is missing and argument, please input a fasta file"
	exit
fi

if [ -n $ref ];
	echo "Variable 'r' is missing an argument, please input a reference file"
	exit
fi

if [ -e $out ];
	echo "Variable 'o' already exists as a file inthe current directory.  Would you like to overwrite the existing file, or exit the program?
	Enter 'Overwrite' if you would like to overwrite
	Enter 'Exit' if you would like to exit"
	read -p "Enter: " input
fi

if $input == 'Exit';
then
	exit
elif ($input != 'Exit' && $input != 'Overwrite');
then
	echo "User input is not valid, program terminated"
	exit
fi

###################################### Program #######################################

#__________Mapping__________

#prepare the reference for mapping
if v=TRUE;
then
	echo "Preparing the reference for mapping"
fi
bwa index $ref

#map read to reference
if v=TRUE;
then
	echo "Mapping read to reference"
fi
bwa mem -R '@RG\tID:identification\tSM:sample\tLB:library\tPL:platform' $ref $mate1 $mate2 > lane.sam
#Input reads must be in FASTQ format
#SM = Name of the sample being processed
#LB = Library
#PL = Platform
#Output is SAM format

#Clean up the output.  May be unsual FLAG info
if v=TRUE;
then
	echo "Cleaning up the output since there may be unusual flag info"
fi
samtools fixmate -O bam lane.sam lane_fixmate.bam

#Sort them from name order to coordinate order
if v=TRUE;
then
	echo "Sorting from name to coordinate number"
fi
samtools sort -O bam -o lane_sorted.bam -T /tmp/lane_temp lane_fixmate.bam


#_______Improvement________

#Create fasta sequence dictionary file for reference
if v=TRUE;
then
	echo "Creating dictionary file for reference"
fi
java -jar ~/bin/picard-tools-1.119/CreateSequenceDictionary.jar R= $ref.fa O= $ref.dict 

#Create fasta index file for reference
if v=TRUE;
then
	echo "Creating index file for reference"
fi
samtools faidx $ref

#Index lane_sorted.bam
if v=TRUE;
then
	echo "Creating index file for reads file"
fi
samtools index lane_sorted.bam

#Reduce the number of miscalls of INDELS
if v=TRUE;
then
	echo "Reducing the number of miscalls of INDELS"
fi
java -Xmx2g -jar ~/bin/GenomeAnalysisTK.jar -T RealignerTargetCreator -R $ref -I lane_sorted.bam -o lane.intervals --known Mills_and_1000G_gold_standard.indels.hg19.sites.vcf
java -jar ~/bin/GenomeAnalysisTK.jar -T IndelRealigner -R $ref -I lane_sorted.bam -targetIntervals lane.intervals -o lane_realigned.bam

#OPTIONAL : Realign INDELS
if e=TRUE;
then
	if v=TRUE;
	then
		echo "USER REQUEST: Realigning INDELS"
	fi
	java -Xmx2g -jar GenomeAnalysisTK.jar -T RealignerTargetCreator -R $ref -I sample.bam -o sample.intervals --known Mills_and_1000G_gold_standard.indels.hg19.sites.vcf
	java -Xmx4g -jar GenomeAnalysisTK.jar -T IndelRealigner -R ref.fa -I sample.bam -targetIntervals sample.intervals --known Mills_and_1000G_gold_standard.indels.hg19.sites.vcf -o sample_realigned.bam
fi

#OPTIONAL : Index the BAM
if i=TRUE;
then
	if v=TRUE:
	then
		echo "Creating index files for reads BAM file"
	fi
	samtools index sample_realigned.bam
fi

#______Variant Calling______

#Convert BAM file into genomic postions.  Mpileup to produce BCF file that contains all of the locations in the genome.  
if v=TRUE;
then
	echo "Converting to genomic positions"
fi
samtools mpileup -go study.bcf -f $ref lane_realigned.bam

#Call genotypes and reduce the list of variant sites by passing this file into bcftools 
if v=TRUE;
then
	echo "Calling genotypes and reducing the list of variant sites"
fi
bcftools call -vmO z -o study.vcf.gz study.bcf

#Prepare the VCF for querying we index it
if v=TRUE;
then
	echo "Preparing the output VCF and creating index files"
fi
tabix -p vcf study.vcf.gz

#To filter the data
if v=TRUE;
then
	echo "Filtering the data and creating output"
fi
bcftools filer -O z -o $out -s LOWQUAL -i '%QUAL>10' study.vcf.gz

if z=TRUE;
then
	gunzip &out
fi

