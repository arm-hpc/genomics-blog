#!/bin/sh

#!/bin/bash

. ../download-data.sh

git clone https://github.com/cloudflare/zlib
cd zlib
./configure && make
cd ..

git clone https://github.com/jemalloc/jemalloc
cd jemalloc
./autogen.sh && ./configure && make
cd ..

git clone https://github.com/lh3/bwa
cd bwa
make CFLAGS="-O3 -g"
cd ..


export LD_LIBRARY_PATH=zlib:$LD_LIBRARY_PATH
export LD_PRELOAD=jemalloc/lib/libjemalloc.so

echo Indexing the data a one time op - if we already have it, this is skipped

test -e $HOME/workload-datasets/bwa/human_g1k_v37.fasta.sa || ./bwa/bwa index $HOME/workload-datasets/bwa $HOME/workload-datasets/bwa/human_g1k_v37.fasta


echo Starting the alignment
echo Executing three times - have observed data movement from remote filesystem affects first run

THREADS=32
time ./bwa/bwa mem -t $THREADS $HOME/workload-datasets/bwa/human_g1k_v37.fasta $HOME/workload-datasets/bwa/NIST7035_TAAGGCGA_L001_R1_001.fastq.gz -o /dev/null

time ./bwa/bwa mem -t $THREADS $HOME/workload-datasets/bwa/human_g1k_v37.fasta $HOME/workload-datasets/bwa/NIST7035_TAAGGCGA_L001_R1_001.fastq.gz -o /dev/null

time ./bwa/bwa mem -t $THREADS $HOME/workload-datasets/bwa/human_g1k_v37.fasta $HOME/workload-datasets/bwa/NIST7035_TAAGGCGA_L001_R1_001.fastq.gz -o /dev/null

echo Finished
