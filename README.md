# genomics-blog

The scripts in this repository reproduce the benchmarks in the "Using
Arm servers to reduce the time and cost of Genomics" blog: https://community.arm.com/arm-community-blogs/b/high-performance-computing-blog/posts/aws-graviton3-reduces-time-and-cost-for-genomics


Before running, the data should be downloaded:

```
./download-data.sh
```

In each of _bwa_, _bwa-mem2_, _minimap2_ subdirectories a shell script will build and execute the application.



