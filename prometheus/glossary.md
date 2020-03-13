#### Alert
Alert 是 Prometheus 的報警規則，由 Prometheus 主動發送到 Alertmanager

#### Alertmanager
Alertmanager 接收來自 Prometheus 的警報，將它們聚合成組，刪除重複告警，屏蔽標記為靜音（ silence ）的告警，然後發送通知到電子郵件，Pagerduty，Slack等。

#### Bridge
Bridge 是一個從客戶端庫中提取樣本並將其展示給非 Prometheus 監控系統的組件。例如，Python，Go和Java客戶端可以將度量標準導出到 Graphite。

#### Client library
Client library （客戶端）庫是某種語言的庫（例如Go，Java，Python，Ruby），可以很容易地直接使用代碼，編寫自定義收集器來從其他系統獲取metrics ，並將metrics 暴露給Prometheus 。

#### Collector
collector 是 exporter 的一部分，代表一組 metrics 。如果它是直接檢測的一部分，則可能是單個 metrics ，如果是從另一個系統提取 metrics ，則可能是多個 metrics 。

#### Direct instrumentation
Direct instrumentation 是作為程序源代碼的一部分內聯添加的。

#### Endpoint
Endpoint （終端），可以被收集時序數據的來源，通常對應於一個單獨的進程。

#### Exporter
Exporter 是一個二進製文件，通常通過將非 Prometheus 格式的 metrics 轉換為 Prometheus 支持的格式來暴露給 Prometheus metrics 。

#### Instance
Instance （實例）是唯一標識作業中的目標的標籤。

#### Job
Job （作業）是具有相同目的的一組目標（例如，監視一組為了可伸縮性或可靠性而復制的類似進程）被稱為作業。

#### Notification
Notification （通知）代表一組警報，由 Alertmanager 發送給電子郵件 ， Pagerduty ， Slack等。

#### Promdash
Promdash 是 Prometheus 的本地儀表板生成器。它已被棄用，取而代之的是功能更強大的 Grafana 。

#### PromQL
PromQL 是 Prometheus 的查詢語言。它允許多種操作，包括聚合，切片和切割，預測和連接。

#### Pushgateway
Pushgateway 持續不斷的從批處理作業中推出的 metrics 拉取數據。 Prometheus 可以直接從 Pushgateway 獲取數據，使得在 Prometheus 終止之後仍然可以繼續收集這些作業的 metrics 。

#### Remote Read
Remote Read （遠程讀取）是 Prometheus 的一個特性，允許 Prometheus 從其他系統（如長期存儲）作為查詢的一部分讀取時間序列。

#### Remote Read Endpoint
Remote Read Endpoint （遠程讀取節點）是 Prometheus 進行遠程讀取時所讀取的對象。

#### Remote Write
Remote Write （遠程寫入）是 Prometheus 的一個特性，可以將收集的監控樣本隨時發送到其他系統，如長期存儲。

#### Remote Write Adapter
Remote Write Adapter （遠程寫入適配器）並非所有系統都直接支持遠程寫入。 Prometheus 和另一個系統之間有一個遠程寫入適配器，將遠程寫入的樣本轉換成其他系統可以識別的格式。

#### Remote Write Endpoint
Remote Write Endpoint （遠程寫入節點）是 Prometheus 在進行遠程寫入時所寫入的對象。

#### Silence
Silence （靜音）Alertmanager 中的 silence 防止通知中包含被靜音（屏蔽）的警報。

#### Target
Target （目標）是一個對象的定義。例如，要應用哪些標籤，連接所需的身份驗證或定義收集的對像等信息。