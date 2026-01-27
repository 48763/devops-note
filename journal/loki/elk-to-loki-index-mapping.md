# Loki 與 OTel Collector 標籤匹配與效能優化筆記

在日誌傳輸鏈路（App -> Event Hub -> Logstash -> OTel Collector -> Loki）中，發現 Loki 的索引標籤 `service_name` 無法與日誌內的 `es_index` 正確匹配，導致查詢困難。

下面是查詢標籤不匹配的語法: 

```
{log_type="appsvc"}
    | label_format flag=`{{ if ne .es_index .service_name }}true{{ else }}false{{ end }}` 
    | flag = `true`
```

## 問題根源

1. **屬性層級錯位**：`service.name` 屬於 Resource Attribute，而 `es_index` 從 Logstash 進入時屬於 Log Record Attribute。
2. **Loki 標籤機制**：Loki 的 OTLP 接收端主要將 Resource Attributes 映射為索引標籤（Labels），Record Attributes 則會被封裝在 JSON Body 中。
3. **批次處理導致的標籤覆蓋**：若一個批次（Batch）中包含多種 index 的日誌，若未進行分組，資源標籤會發生錯亂或僅取其一。


## 解決配置範例

```yaml
processors:
  groupbyattrs:
    keys:
      - es_index
  batch:
    send_batch_size: 500
    timeout: 5s
  transform:
    log_statements:
      - context: log
        statements:
          - set(resource.attributes["service.name"], resource.attributes["es_index"])
service:
  pipelines:
    logs:
      receivers:
        - otlp
      processors:
        - groupbyattrs
        - transform
        - batch
```

### 運作原理說明

1. **`groupbyattrs`**：
   - 根據 `es_index` 進行分組。
   - 關鍵特性：會自動將 `es_index` 從 Log Record 提升（Promote）到 Resource 層級。
   - 物理拆分：將不同 index 的日誌拆分到不同的 ResourceLogs 容器中。
2. **`batch`**：
   - 對已經分組後的數據進行打包，確保相同 index 的數據能更有效率地傳輸。
3. **`transform`**：
   - **核心改進**：使用 `resource_statements` 而非 `log_statements`。
   - **語法範例**：`set(resource.attributes["service.name"], resource.attributes["es_index"])`。
   - **效能優勢**：由於數據已分組，處理器只需針對「每一包資源」執行一次轉換，不需針對「每一條日誌」執行，大幅節省 CPU 開銷。
