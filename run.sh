#!/bin/bash

default_bed_file=/app/Treehouse_variants_to_call.2021-01-13_11.29.27.bed

fasta=$1
bam=$2
outputs=$3
bed_file=${4:-$default_bed_file}

set 
for file in "$@"
do
    if [ ! -e "$file" ]
    then echo "$file is missing" >&2; exit 1
    fi
done

echo Running freebayes on $bam
freeBayesSettings="--dont-left-align-indels --pooled-continuous --pooled-discrete -F 0.03 -C 2"
/app/freebayes/bin/freebayes --targets ${bed_file} $freeBayesSettings -f $fasta $bam >  /tmp/mini.vcf

echo Running snpEff on $bam
snpEffSettings="-nodownload -noNextProt -noMotif -noStats -classic -no PROTEIN_PROTEIN_INTERACTION_LOCUS -no PROTEIN_STRUCTURAL_INTERACTION_LOCUS"
java -Xmx10000m -jar /app/snpEff/snpEff.jar -v $snpEffSettings GRCh38.86 /tmp/mini.vcf >  ${outputs}/mini.ann.vcf

# echo Summarizing vcf
# python3 /app/summarize.py ${outputs}/mini.ann.vcf > ${outputs}/mini.ann.tsv
