# DATA MODEL （數據模型）

*Prometheus* 從根本上將所有數據存儲為時間序列（ time series） ：屬於同一個 *metrics* 的時間戳值的數據流和相同的一組標記維度。除了存儲的時間序列之外， *Prometheus* 還可以生成臨時導出的時間序列作為查詢的結果。

## Metric names and labels （ metrics 名稱和標籤）
每個時間序列都由其 *metrics* 名稱和一組鍵值對（也稱為標籤）唯一標識。
*metrics*
### names
*Metric name* 指定被測量的系統的一般特徵（例如， `http_requests_total` - 接收到的 *HTTP* 請求的總數）。它可以包含 *ASCII* 字母和數字，以及下劃線和冒號，即必須匹配正則表達式 `[a-zA-Z_:][a-zA-Z0-9_:]*`
。
### labels
*labels* 使 *Prometheus* 的維度數據模型成為可能：相同 *metrics* 名稱的任何給定的標籤組合標識該 *metrics* 的特定維度實例（如：所有使用 `POST` 方法到 `/api/tracks` 處理程序的 *HTTP* 請求）。查詢語言允許基於這些維度進行篩选和聚合。更改任何標籤值（包括添加或刪除標籤）將創建新的時間序列。

標籤名稱可以包含 *ASCII* 字母，數字以及下劃線。它們必須匹配正則表達式 `[a-zA-Z_][a-zA-Z0-9_]*` 。以 `__` 開頭的標籤名稱保留供內部使用。

標籤值可能包含任何 *Unicode* 字符。

另請參閱命名 *metrics* 和標籤的[最佳實踐](https://prometheus.io/docs/practices/naming/)。

## Samples （樣本）
樣本形成實際的時間序列數據。每個樣品包括：
- 一個 float64 值
- 一個毫秒精度的時間戳

## Notation （符號）
給定一個 metrics 名稱和一組標籤，時間序列通常用這個標記來標識：
```
<metric name>{<label name>=<label value>, ...}
```

例如，metrics name 為 `api_http_requests_total` ，標籤 `method="POST"`，`handler="/ messages"` 的時間序列可以這樣寫：
```
api_http_requests_total{method="POST", handler="/messages"}
```

這與 OpenTSDB 使用的符號相同。