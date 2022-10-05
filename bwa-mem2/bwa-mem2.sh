#!/bin/sh

#!/bin/bash

. ../download-data.sh

git clone https://github.com/cloudflare/zlib
cd zlib
./configure && make
cd ..


git clone --recursive https://github.com/dslarm/bwa-mem2
cd bwa-mem2
make -C ext/safestringlib directories libsafestring.a
make CFLAGS="-O3 -g"
cd ..


export LD_LIBRARY_PATH=zlib:$LD_LIBRARY_PATH

echo Indexing the data a one time op - if we already have it, this is skipped

test -e $HOME/workload-datasets/bwa/human_g1k_v37.fasta.bwt.2bit.64 || ./bwa-mem2/bwa-mem2 index $HOME/workload-datasets/bwa $HOME/workload-datasets/bwa/human_g1k_v37.fasta


echo Starting the alignment
echo Executing three times - have observed data movement from remote filesystem affects first run

THREADS=32
time ./bwa-mem2/bwa-mem2 mem -t $THREADS $HOME/workload-datasets/bwa/human_g1k_v37.fasta $HOME/workload-datasets/bwa/NIST7035_TAAGGCGA_L001_R1_001.fastq.gz

time ./bwa-mem2/bwa-mem2 mem -t $THREADS $HOME/workload-datasets/bwa/human_g1k_v37.fasta $HOME/workload-datasets/bwa/NIST7035_TAAGGCGA_L001_R1_001.fastq.gz

time ./bwa-mem2/bwa-mem2 mem -t $THREADS $HOME/workload-datasets/bwa/human_g1k_v37.fasta $HOME/workload-datasets/bwa/NIST7035_TAAGGCGA_L001_R1_001.fastq.gz

