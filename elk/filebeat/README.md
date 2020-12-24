# <img src="../img/filebeat/img-01.jpg" alt="filebeat-logo" width="5%"></a>  filebeat

Filebeat 是用於轉發和集中化日誌數據的輕量級轉送程序，安裝在服務器當作代理器。其監控特定的日誌檔案或是位置，收集日誌事件和並將其轉發至其它的 *Elasticsearch* 或 *Logstash* 進行索引。

Filebeat 工作方式如下：當啟用時，將啟動一個或多個輸入來查找指定的日誌數據位置。對於每個日誌的定位，都會啟動一個收集器，每個收集器讀取單一日誌以獲取內容，以及發送新日誌數據到 *libbeat*，該應用會整合事件和傳送數據到所配置的 Filebeat。

> 如果輸出 Logstash 或 Elasticsearch 有讀取問題時（大量日誌），Filebeat 會減慢文件的讀取速度。

## 在 Docker 中運行

```bash
$ docker run  -d docker.elastic.co/beats/filebeat:6.2.4
```
