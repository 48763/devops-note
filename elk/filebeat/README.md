## filebeat
![](https://i.imgur.com/QZB0q6I.png)

安裝要發送日誌到 *Logstash* 的用戶端， *Filebeat* 為日誌傳送代理，利用 `lumberjack networking protocol` 與 *Logstash* 進行溝通。

[lumberjack networking protocol](https://github.com/elastic/logstash-forwarder/blob/master/PROTOCOL.md)
### 什麼是 beat
Beats 是輕量級（資源高效，無依賴性，小型）和開源蒐集服務 log 的集合，它們充當安裝在基礎架構中不同服務器上的代理，用於收集 logs 或 metrics。

### filebeat
Filebeat 是屬於 Beats 系列的*日誌托運商*：一組輕量級托運人，用於將不同種類的數據傳輸到 ELK 進行分析。每個 beat 專門用於傳送不同類型的信息，如：Winlogbeat 提供 Windows 事件日誌，Metricbeat 提供主機指標等等。顧名思義，Filebeat會發送日誌文件。

> 如果輸出 Logstash 或 Elasticsearch 有讀取問題時（大量日誌），Filebeat 會減慢文件的讀取速度。

### Install Filebeat on Dockek
```bash
$ sudo docker pull docker.elastic.co/beats/filebeat:6.2.4
```