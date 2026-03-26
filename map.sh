#!/bin/bash

NT=10
INDEX=/data/ref/human/ensembl/star/star_index100
FASTA=/data/ref/human/ensembl/star/hg38.fa

bwa mem -R "@RG\tID:$1\tSM:$1"  /data/ref/human/ensembl/star/hg38.fa fastq/$1_R1.fastq fastq/$1_R2.fastq | samtools sort > bam/$1.sorted.bam
samtools index bam/$1.sorted.bam

gatk MarkDuplicates\
	--INPUT	bam/$1.sorted.bam \
	--OUTPUT bam/$1.dedup.sorted.bam \
	--METRICS_FILE bam/$1.dedup.metrics.txt \
	--REFERENCE_SEQUENCE $FASTA \
	--REMOVE_DUPLICATES true

samtools index bam/$1.dedup.sorted.bam

gatk SplitNCigarReads \
	--input bam/$1.dedup.sorted.bam \
	--output bam/$1.split.dedup.sorted.bam \
	--reference $FASTA

rm -rf bam/$1.sorted.bam 
rm -rf bam/$1.dedup.sorted.bam
