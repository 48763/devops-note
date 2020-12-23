# ELK Stack

ELK 是指 *ElasticSearch* 、 *Logstash* 和 *Kibana* 三個 open-source 的集合套件，這三個軟體可以組成一套日誌（log）分析架構。

- Filebeat：充當日誌傳送代理，安裝在欲發送日誌到 *Logstash* 的用戶端上，利用 *lumberjack networking protocol* 與 *Logstash* 進行溝通。
- Logstash：**收集**和**處理**單一或多個用戶傳送來的日誌，處理完後推送到 *Elasticsearch*。
- Elasticsearch：儲存用戶端的日誌。
- Kibana：可在系統上建立資料索引，並按照資料建立可視化的儀表板。

## 日誌（Log）

日誌（Log）是只系統連線和運作時所產生的記錄，藉由日誌的蒐集和分析，讓 IT 人員能夠監控系統的運作狀態，判斷可能發生的事件，以及分析資料存取行為和使用者的活動。

- 網路是否遭到惡意的嘗試入侵？
- 系統和網路運作是否有異常情況發生？

當有事件發生時，IT 人員只要對蒐集的 Log 進行分析，便可在較短時間內判斷其可能發生的問題。

## 目錄 

- [ELK 安裝](./#getting-started-with-elk)
- [Logstash](./logstash)
- [Elasticsearch](./elasticsearch)
- [Kibana](./kibana)
- [故障排除](./troubleshooting.md)

## ELK 安裝

### Docker 運行

#### 環境需求

安裝 docker：

```bash
$ curl -sSL https://get.docker.com/ | sh
```

安裝 docker-compose：

```bash
$ curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
$ chmod +x /usr/local/bin/docker-compose
```

### 運行 ELK

克隆專案：

```bash
$ git clone https://github.com/deviantony/docker-elk.git
```

使用 docker-compose 運行服務：

```bash
$ cd /docker-elk
$ docker-compose up -d
```

### 檢查服務

預設的運行傳輸埠號：

- 5000：Logstash 的 TCP 輸入埠。
- 9200：Elasticsearch HTTP。
- 9300：Elasticsearch TCP 傳輸埠
- 5601：Kibana 儀表板頁面。

#### Elasticsearch

```bash
$ curl http://localhost:9200
{
  "name" : "YUiaJ73",
  "cluster_name" : "docker-cluster",
  "cluster_uuid" : "8TZBIrUbTL2qEl931RwYBw",
  "version" : {
    "number" : "6.2.3",
    "build_hash" : "c59ff00",
    "build_date" : "2018-03-13T10:06:29.741383Z",
    "build_snapshot" : false,
    "lucene_version" : "7.2.1",
    "minimum_wire_compatibility_version" : "5.6.0",
    "minimum_index_compatibility_version" : "5.0.0"
  },
  "tagline" : "You Know, for Search"
}
```

#### Kibana

使用瀏覽器訪問下列網址：

```
http://localhost:5601
```

#### Logstash

測試檔案 `text.log` 送到傳輸埠 `5000`：

```bash
$ echo "I hate log analysis." > text.log &&  nc localhost 5000 < text.log
```

內容會被傳送到 *elasticsearch* 儲存。

到 *Kibana* 的管理介面，點擊「Management」，並點擊新增 `index`，輸入 `index` 名稱為 `logstash`，最後點選「Discover」即可看到剛傳輸的紀錄。（官方教程：[connect-to-elasticsearch](https://www.elastic.co/guide/en/kibana/current/connect-to-elasticsearch.html)）

!["result"](./img/kibana%20nc%20test.png)
