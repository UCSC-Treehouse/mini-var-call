#!/bin/bash

fasta=$1
bam=$2
outputs=$3

echo Running freebayes on $bam
freeBayesSettings="--dont-left-align-indels --pooled-continuous --pooled-discrete -F 0.03 -C 2"
/app/freebayes/bin/freebayes --targets /app/th_precise_merged.bed $freeBayesSettings -f $fasta $bam >  /tmp/mini.vcf

echo Running snpEff on $bam
snpEffSettings="-nodownload -noNextProt -noMotif -noStats -classic -no PROTEIN_PROTEIN_INTERACTION_LOCUS -no PROTEIN_STRUCTURAL_INTERACTION_LOCUS"
java -Xmx10000m -jar /app/snpEff/snpEff.jar -v $snpEffSettings GRCh38.86 /tmp/mini.vcf >  ${outputs}/mini.ann.vcf

# rm /tmp/mini.vcf
