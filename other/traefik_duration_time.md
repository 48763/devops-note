# Traefik 請求時長

## 1. 核心指標對比

| 指標名稱 | 監測範圍 (Scope) | 包含網路延遲？ | 主要用途 |
| :--- | :--- | :--- | :--- |
| **traefik_service_...** | Traefik ↔ 後端服務 (Upstream) | 不包含 | 診斷後端程式效能、資料庫瓶頸。 |
| **traefik_entrypoint_...** | 用戶端 (Client) ↔ Traefik | 包含 (部分) | 監控用戶實際感受到的延遲 (E2E)。 |

## 2. `traefik_service_request_duration_seconds`

主要追蹤 Traefik 與後端服務之間的互動：

* 包含：
    1. Traefik 決定路由後的轉發延遲。
    2. 後端服務 (Service) 處理請求的運算時間。
    3. 後端將 Response 回傳給 Traefik 的時間。
* 不包含：
    * 外部網路延遲：不受用戶端（如手機、瀏覽器）網路環境好壞影響。
    * TCP FIN 揮手：屬於 L4 層級的連線關閉，不計入 L7 的 Request Duration。
> 如果此數值很高，問題出在內部服務；如果此數值低但用戶覺得慢，問題出在外部網路。

## 3. 全鏈路 (End-to-End) 觀察方案

若要追蹤完整鏈路，除了指標外，建議參考以下資源：

### A. Access Log (最精確的數據)

開啟 Traefik JSON 格式日誌，觀察這三個關鍵欄位：
* BackendDuration: 後端處理時間（對應 Service 指標）。
* Overhead: Traefik 處理路由與 Middleware 的開銷。
* Duration: 整個請求從進來到出去的總時間。

### B. Distributed Tracing (可視化鏈路)

* 工具：OpenTelemetry (OTel), Jaeger, Tempo。
* 作用：當請求經過多個微服務（Service A -> Service B）時，能以瀑布圖形式展現每一跳的耗時。

### C. PromQL 範例 (計算平均響應時間)

```promql
sum(rate(traefik_service_request_duration_seconds_sum[5m])) by (service) 
/ 
sum(rate(traefik_service_request_duration_seconds_count[5m])) by (service)
```