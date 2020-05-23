# Output

選擇對應的插件，將數據傳送至目標。

## Plugins list
- Elasticsearch
- google_bigquery

## elasticsearch
```
elasticsearch {
    hosts => "192.168.200.130:9200"
    index => "harbor-host"
}
```

## 參考資料

[Official output plugins](https://www.elastic.co/guide/en/logstash/current/output-plugins.html)

[ELKstack 中文指南 - 輸出插件(Output)：elasticsearch](https://elkguide.elasticsearch.cn/logstash/plugins/output/elasticsearch.html)