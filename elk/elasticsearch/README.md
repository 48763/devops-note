# <img src="../img/elasticsearch/img-01.jpg" alt="elasticsearch-logo" width="10%"></a>  elasticsearch


1. 由 Java 構建，被歸類為 [NoSQL](https://www.ithome.com.tw/news/92507) 數據庫（非結構化的方式存儲數據）。
2. 一個分散式、具 *RESTful* 分隔的搜索和數據分析引擎。

### 文檔
對像被序列化成 JSON 並存儲到 Elasticsearch 中，指定唯一 ID。
```json
{
    "email":      "john@smith.com",
    "first_name": "John",
    "last_name":  "Smith",
    "info": {
        "bio":         "Eco-warrior and defender of the weak",
        "age":         25,
        "interests": [ "dolphins", "whales" ]
    },
    "join_date": "2014/05/01"
}
```

### 索引
存儲數據的動作為索引（indexing），文檔屬於一種類型（type），而這些類型存在於索引(index)中。
```
Relational DB -> Databases -> Tables -> Rows -> Columns
Elasticsearch -> Indices(名詞)   -> Types  -> Documents -> Fields
```

### 搜索
```
GET filebeat*/_search
```
> kibana 搜尋部分詳述

### 聚合（aggregations）
允許在數據上生成複雜的可視圖表。它很像 SQL 的 GROUP BY 。

### 查看配置

```
curl "localhost:9200/_nodes/settings?pretty=true"
```


### 套件安裝

```
./bin/elasticsearch-plugin install -b https://github.com/vvanholl/elasticsearch-prometheus-exporter/releases/download/7.7.0.0/prometheus-exporter-7.7.0.0.zip
```

### 參考資料
[Elasticsearch 權威指南](https://es.xiaoleilu.com)、
[Elasticsearch official](https://www.elastic.co/guide/en/elasticsearch/reference/current/getting-started.html)