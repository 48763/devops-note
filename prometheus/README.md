# Prometheus

Prometheus 是一個開源系統監控和警示的工具包。

Prometheus 在 2016 加入 Cloud Native Computing Foundation，成為其第二個託管的專案。

## 架構

![](../img/prometheus/prometheus-01.png)

Prometheus 服務器，可以從 *Pushgateway* 和目標的 *exporter* 拉取（pull）測量指標；而對於目標本身，可以透過 *exporter* 將指標暴露給外部服務器，或是將指標推送（push）到 *Pushgateway*，使其收集，並讓服務器拉取。

服務器會將收集的測量指標與時間序列，會透過 WAL 的儲存方式，先保存在記憶體當中，而不會立即寫入到資料庫。預寫日誌以每段 128MB 儲存在 `wal` 目錄下。預寫的檔案會在兩個小時一次，壓縮寫至到資料庫（TSDB）內。

在輸出監控的指標數據時，可以透過 Prometheus 原生介面呈現，或者是用 *Grafana*
，將監控的測量數據製作監控頁面，以方便觀測目標主機的狀態。

## 目錄索引

- [詞彙解釋](./glossary.md)
- [Prometheus Server](./server)
- [Alertmanager](./alertmanager)
- [Exporters](https://github.com/48763/prom-client-ex)