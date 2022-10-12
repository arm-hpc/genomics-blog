#!/bin/bash

. ../download-data.sh

git clone https://github.com/cloudflare/zlib
cd zlib
./configure && make
cd ..


git clone --recursive https://github.com/dslarm/minimap2.git

cd minimap2

arch=`uname -m`

echo $(arch)

if [ $(arch) == aarch64 ]; then MAKE_FLAGS="aarch64=1 arm_neon=1 -f Makefile.simde" ; fi

make CFLAGS="-O3 -g" $MAKE_FLAGS

cd ..


export LD_LIBRARY_PATH=zlib:$LD_LIBRARY_PATH

echo Indexing the data a one time op - if we already have it, this is skipped

test -e $HOME/workload-datasets/bwa/human.mmi || ./minimap2/minimap2 -x sr -d $HOME/workload-datasets/bwa/human.mmi $HOME/workload-datasets/bwa/human_g1k_v37.fasta



echo Starting the alignment
echo Executing three times - have observed data movement from remote filesystem affects first run

THREADS=32
time ./minimap2/minimap2 -t $THREADS -a human.mmi $HOME/workload-datasets/bwa/NIST7035_TAAGGCGA_L001_R1_001.fastq.gz -o out.sam

time ./minimap2/minimap2 -t $THREADS -a human.mmi $HOME/workload-datasets/bwa/NIST7035_TAAGGCGA_L001_R1_001.fastq.gz -o out.sam

time ./minimap2/minimap2 -t $THREADS -a human.mmi $HOME/workload-datasets/bwa/NIST7035_TAAGGCGA_L001_R1_001.fastq.gz -o out.sam


echo Finished
