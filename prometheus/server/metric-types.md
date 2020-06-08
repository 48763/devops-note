# 指標（metrics）類型

*Prometheus* 客戶端函式庫提供四種核心指標。目前這些功能僅在客戶端函式庫（使 API 能量身定制以使用特定類型）和有線協議（wire protocol）中有所不同。*Prometheus* 服務端尚未使用指標類型資訊，而是將所有數據展開成無類型的時間序列。這在未來可能會有所改變。

## 計數器（Counter）

**計數器**是一個**累計指標**，意味著它單一且單調的累加計數器，其值只能增加或重新啟動時重置為零。**計數器**通常使用來計數服務的請求、完成的任務、發生的錯誤等等。

> 計數器不應該被用來顯示其數目也可以減少的項目的當前計數，如：當前正在運行的進程的數量，這個用例適合使用[**測量儀**](#測量儀gauge)。

**計數器**的客戶端函式庫使用文檔：
- Go
- Java
- Python
- Ruby

## 測量儀（Gauge）

**測量儀**代表一個可以任意上下的單個數值。**測量儀**通常用於測量值，如：溫度或當前的內存使用情況，但也可以上下計數，如正在運行的進程的數量。

**測量儀**的客戶端函式庫使用文檔：
- Go
- Java
- Python
- Ruby

## 直方圖（Histogram）

**直方圖**對觀察結果進行採樣（通常是請求持續時間或響應大小），並將其計入可配置的**桶子（buckets）** 中。它也提供了所有觀測值的總和。指標名稱為` <basename>` 的直方圖在收集期間公開多個時間序列：
- 觀察桶子的累計計數器顯示為 `<basename>_bucket {le="<upper inclusive bound>"}`
- the total sum of all observed values, exposed as `<basename>_sum`
- the count of events that have been observed, exposed as `<basename>_count` (identical to `<basename>_bucket{le="+Inf"}` above)

Use the `histogram_quantile()` function to calculate quantiles from histograms or even aggregations of histograms. A histogram is also suitable to calculate an Apdex score. When operating on buckets, remember that the histogram is cumulative. See histograms and summaries for details of histogram usage and differences to summaries.

**直方圖**的客戶端函式庫使用文檔：
- Go
- Java
- Python
- Ruby

## Summary

Similar to a histogram, a summary samples observations (usually things like request durations and response sizes). While it also provides a total count of observations and a sum of all observed values, it calculates configurable quantiles over a sliding time window.

A summary with a base metric name of `<basename>` exposes multiple time series during a scrape:

- streaming *φ-quantiles* (0 ≤ φ ≤ 1) of observed events, exposed as `<basename>{quantile="<φ>"}`
- the *total sum* of all observed values, exposed as `<basename>_sum`
- the *count* of events that have been observed, exposed as `<basename>_count`

See histograms and summaries for detailed explanations of φ-quantiles, summary usage, and differences to histograms.

Client library usage documentation for summaries:

- Go
- Java
- Python
- Ruby