# Design ELK cluster resource

## Storage size

Per nodes of cluster must be divided into hot, warm, and cold. 

Elastic recommends using the following logic: 

- hot: 1:30
- warm: 1:100
- cold: 1:500

> Disk space per gigabyte of memory.

### evaluation

- The amount of raw data per day;
- Period of data storage in days;
- Data Transformation Factor (json factor + indexing factor + compression factor);
- Number of shard replication;
- The amount of memory data nodes;
- The ratio of memory to data (1:30, 1: 100, etc.).

> Recommendations:
> - Deposit 15% to have a reserve on disk space;
> - Pledge 5% for additional needs;
> - Lay down 1 equivalent of a data node to ensure fast migration.

### Formulas

- Total Data (GB) = Raw data per day * Number of storage days * Factor for increasing data * (Number of replicas – 1)
- Shared data storage (GB) = Total amount of data (GB) * (1 + 0.15 stock + 0.05 additional needs)

## JVM heap

- The recommended heap size for typical ingestion scenarios should be no less than 4GB and no more than 8GB.
- As a general guideline for most installations, don’t exceed 50-75% of physical memory.

## Node 

Strategies:

- disk resources and memory are of paramount importance
- second case, memory, processor power and network.

### Formulas

- Total number of nodes = OKVR (General data storage (GB) / Volume of memory per node / ratio of memory to data + 1 equivalent of data node)

## Compression algorithm

- LZ4: 10-15%
- deflate: 20-30%

## Number of shards

- The number of index patterns you will create;
- The number of core shards and replicas;
- After how many days index rotation will be performed, if at all;
- The number of days to store the indices;
- The amount of memory for each node.

> Recommendations:
> - Do not exceed 20 shards per 1 GB JVM Heap on each node;
> - Do not exceed 40 GB of shard disk space.

### Formulas

- Number of shard = Number of index patterns * Number of core shards * (Number of replicated shards + 1) * Number of days of storage
- Number of Data Nodes = OKVR (Number of shards / (20 * Memory for each node))

## Bandwidth size

- Peak searches per second;
- Average allowable response time in milliseconds;
- The number of cores and threads per processor core on data nodes.

### Formulas

- Peak value of threads = OK (peak number of search queries per second * average amount of time to respond to a search query in milliseconds / 1000 milliseconds)
- Volume thread pool = OKRUP ((number of physical cores per node * number of threads per core * 3/2) +1)
- Number of data nodes = OK (Peak thread value / Thread pool volume)

