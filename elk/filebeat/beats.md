## What are Beats
Beats 是輕量級（資源高效，無依賴性，小型）和開源蒐集服務 log 的集合，它們充當安裝在基礎架構中不同服務器上的代理，用於收集 logs 或 metrics。
這些可以是日誌文件（Filebeat），網絡數據（Packetbeat），服務器度量標準（Metricbeat）或 Elastic 和[社群](https://www.elastic.co/guide/en/beats/libbeat/master/community-beats.html)正在開發的越來越多的 Beats 可以收集的任何其他類型的數據。
收集完成後，數據直接發送到 Elasticsearch 或 Logstash 以進行額外處理。
Beats 建立在名為 [libbeat](https://github.com/elastic/beats/tree/master/libbeat) 的 Go 框架的頂部 - 這是一個數據轉發的庫，這意味著新的 beats 一直在由社群開發和貢獻。

### Filebeat
Filebeat用於收集和發送日誌文件，也是最常用的 beat。使 Filebeat 如此高效的一個事實是它處理背壓的方式。所以如果 Logstash 忙碌的接收大量的資料，Filebeat 
會減慢它的讀取速度，並在放慢速度結束後加快速度。
Filebeat 可以安裝在幾乎任何操作系統上，包括作為 Docker 容器，並且還提供用於特定平台（如Apache，MySQL，Docker等）的內部模塊。

### Packetbeat
一個網絡數據包分析儀 Packetbeat 是首次推出的 beat。Packetbeat 捕獲服務器之間的網絡流量，因此可用於應用程序和性能監控。
Packetbeat 可以安裝在受監控的服務器上或其專用服務器上。Packetbeat 跟蹤網絡流量，解碼協議並為每個事務記錄數據。
Packetbeat 支持的協議包括：DNS，HTTP，ICMP，Redis，MySQL，MongoDB，Cassandra 等等。

### Heartbeat
Heartbeat 是為了"正常運行時間監控"。實質上，Heartbeat 所做的是探測服務，以檢查它們是否可達。例如，驗證服務正常運行時間是否符合您的 SLA 是很有用的。
您需要做的就是向H eartbeat 提供 URL 列表和正常運行時間指標，以便在索引之前直接發送到 Elasticsearch 或 Logstash 以進行富集。

### Auditbeat
可用於在您的 Linux 服務器上審核用戶和流程活動。與其他傳統系統審計工具（systemd，auditd）類似，Auditbeat 可用於識別安全漏洞，文件更改、配置更改
、惡意行為等。  
### Winlogbeat
Winlogbeat 只會吸引 Windows 系統管理員或工程師，因為它是專門為收集 Windows 事件日誌而設計的節拍。它可以用來分析安全事件，安裝的更新等等。
