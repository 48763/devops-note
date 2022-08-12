# 筆記

## 名詞

| Variable | Description | Calculation | Unit |
| - | - | - | - |
| EPS | Events per second | Estimate | Events |
| AES | Average event size | Estimate | Bytes |
| DUPD | Disk used per day | AESxEPSx60x60x24/1073741824 | GB |
| miSPD | Min Shards per day | DUPD/50 | Shards |
| HD | Hot days	| Estimate | Days |
| WD | Warm days | Estimate | Days |
| xHD | Expected data on hot days (for indexing, searching, forge merging) | DUPD*HD/1024 | TB |
| xWD | Expected data on warm days (read only indices for searching and creating replicas) | DUPD*WD | TB |
| miHD | Minimum disk size for hot days | xHD*1.4 | TB |
| miWD | Minimum disk size for warm days | xWD*1.4 | TB |

## 案例

- She wants to index three tables: users, orders and products
- There are 12,123 user records, which are growing by 500 a month
- There are 8,040 order records, which are growing by 1,100 a month
- There are 101,500 product records, which are growing by 2% month over month
- According to the application logs, users are averaging 10K searches per day, with a peak of 20 rps

```
GET /_cat/indices
green  open   users         1   1         5000         0      28m  14m
green  open   orders        1   1         5000         0      24m  12m
green  open   products      3   2         5000         0      540m 60m
```

Based on this, she determines:

- The users index occupies 14MB / 5000 docs = 2.8KB per document.
- The orders index occupies 12MB / 5000 docs = 2.4KB per document.
- The products index occupies 60MB / 5000 docs = 12KB per document.

```
shards = p * (1 + r)
```

```
1x(1+1) shards/index * 1 index/day * 30 days = 60 shards
```
> indexing 10% 

## 文章

- [Heap size settingsedit](https://www.elastic.co/guide/en/elasticsearch/reference/current/important-settings.html#heap-size-settings)
- [GC logging settingsedit](https://www.elastic.co/guide/en/elasticsearch/reference/current/important-settings.html#gc-logging)
