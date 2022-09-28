#!/bin/sh

# fetch data

mkdir -p $HOME/workload-datasets/bwa
if [ ! -e $HOME/workload-datasets/bwa/human_g1k_v37.fasta ]; then
    aws s3 cp --no-sign-request s3://1000genomes/technical/reference/human_g1k_v37.fasta.gz $HOME/workload-datasets/bwa/ 
    gunzip $HOME/workload-datasets/bwa/human_g1k_v37.fasta.gz
fi
if [ ! -e $HOME/workload-datasets/bwa/NIST7035_TAAGGCGA_L001_R1_001.fastq.gz ]; then
    aws s3 cp --no-sign-request s3://giab/data/NA12878/Garvan_NA12878_HG001_HiSeq_Exome/NIST7035_TAAGGCGA_L001_R1_001.fastq.gz $HOME/workload-datasets/bwa/
fi
