# redis

## Sentinel

簡單達成附載均衡，不需要多部主機。

1. 監控 redis master-slave 狀態。
2. 提供 master 故障轉移，slave 自動接管 master，由 sentinel 控制同時會複寫 slave 設定。
3. 操作 redis 並未全部透過 sentinel，只在一開始詢問 sentinel 當前 redis master/slave 為哪台主機。
4. 本身基於 master/slave 所以沒有任何 multi-master/sharding 功能。

## Cluster

成本高，至少三部 master（不包含replica），當垂直擴展無法滿足時需要此操作。

- 叢集使用分片（sharding），需要多台 master。
- 鍵值對（key-value）會因為算法分散在不同節點上，當查詢的 key 不在目標上時，會返回用戶在哪個節點上。
- slave（replica）可以接管 master。
- slave 不接受寫入，也不接受查詢。
- 本身無法搭配**附載均衡器**，原因在於**附載均衡器**無法判斷資料存在哪一部節點。

## 筆記

### Write data

The first reason why Redis Cluster can lose writes is because it uses asynchronous replication. This means that during writes the following happens:
- Your client writes to the master B.
- The master B replies OK to your client.
- The master B propagates the write to its replicas B1, B2 and B3.


### Persistence

Persistence refers to the writing of data to durable storage, such as a solid-state disk (SSD). Redis itself provides a range of persistence options:

- **RDB** (Redis Database): The RDB persistence performs point-in-time snapshots of your dataset at specified intervals.
- **AOF** (Append Only File): The AOF persistence logs every write operation received by the server, that will be played again at server startup, reconstructing the original dataset. Commands are logged using the same format as the Redis protocol itself, in an append-only fashion. Redis is able to rewrite the log in the background when it gets too big.
- **No persistence**: If you wish, you can disable persistence completely, if you want your data to just exist as long as the server is running.
- **RDB + AOF**: It is possible to combine both AOF and RDB in the same instance. Notice that, in this case, when Redis restarts the AOF file will be used to reconstruct the original dataset since it is guaranteed to be the most complete.
