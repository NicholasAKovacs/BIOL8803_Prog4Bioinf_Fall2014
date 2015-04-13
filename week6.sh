#!/bin/sh

#could not get this getops stuff to work, everything else does
#while getopts "nmv" opt; do
#	case $opt in
#		n) $var1;;
#		m) $var2;;
#	esac
#done
for var in $(seq 10)  #var1 or n would go here insead of 10
do
        if [ -e 'seq'$var.fasta ]
        then
                rm 'seq'$var.fasta
                touch 'seq'$var.fasta
                for newvar in $(seq 8) #var2 or m would go here instead of 8
                do
                        echo '>seq'$var'_'$newvar >> 'seq'$var.fasta
                        cat /dev/urandom | tr -dc 'ACGT' | fold -w 50 | head >> 'seq'$var.fasta
                done
        else
                touch 'seq'$var.fasta
                for newvar in $(seq 8) #var2 or m would go here instead of 8
                do
                        echo '>seq'$var'_'$newvar >> 'seq'$var.fasta
                        cat /dev/urandom | tr -dc 'ACGT' | fold -w 50 | head >> 'seq'$var.fasta
                done
        fi

done
