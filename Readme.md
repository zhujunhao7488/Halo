# Halo: A Hybrid PMem-DRAM Persistent Hash Index with Fast Recovery

**Halo** is a hybrid PMem-DRAM persistent hash index with fast recovery featuring a specifically designed volatile index and log-structured persistent storage layout.
In order to suppress write amplification caused by memory allocators and to facilitate recovery, we propose **Halloc**, a highly-efficient memory manager for Halo. In addition, we pro- pose mechanisms such as batched writes, prefetching for hybrid reads, and reactive snapshot to further optimize performance.

## Paper
This is the code according to our paper **Halo: A Hybrid PMem-DRAM Persistent Hash Index with Fast Recovery**.

## Dependencies
### For building
#### Required
* `make`
* `libpmem` 



## How to build
* Call `make` to generate all binaries.

<!-- ## For generating the YCSB workload
```console
cd YCSB

``` -->

## How to run
See `autorun.sh`
