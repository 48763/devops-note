# Search crash

We considered several possible scenarios that could lead to this issue:

- Were there shard relocation events happening around the same time? (The answer was *no*.)
- Could fielddata be what was taking up too much memory? (The answer was *no*.)
- Did the ingestion rate go up significantly? (The answer was also *no*.)
- Could this have to do with data skew — specifically, data skew from having too many actively indexing shards on a given data node? We tested this hypothesis by increasing the # of shards per index so shards are more likely to be evenly distributed. (The answer was still *no*.)

At this point, we suspected, correctly, the node failures are likely due to *resource intensive search queries running on the cluster*, causing nodes to run out of memory. However, two key questions remained:

1. How could we identify the offending queries?
2. How could we prevent these troublesome queries from bringing down the cluster?

## 文章

> https://plaid.com/blog/how-we-stopped-memory-intensive-queries-from-crashing-elasticsearch/
