# Loki


## 日誌與追蹤關聯

當 Loki 與 Tempo 同時運行時，透過以下設定可實現在 Grafana 中一鍵跳轉。

#### 效益

- 解決「日誌太多難以定位」的問題。
- 當發生 Error 時，能快速看到完整的微服務調用鏈。

#### 應用程式端

確保在輸出 Log 時，JSON 結構中包含 `trace_id` 欄位。

#### Grafana Derived Fields

在 Loki Data Source 設定頁面：
- **Name**: `TraceID`
- **Regex**: `"trace_id":"(\w+)"`
- **Internal Link**: 選取 Tempo 並設定 URL 為 `${__value.raw}`
