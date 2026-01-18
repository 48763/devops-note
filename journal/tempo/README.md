# Tempo


## 檢查運行配置 (Runtime Config)

Tempo 會將最終合併後的配置（包含手動設定與系統硬編碼的預設值）暴露在特定的 API 端點。

### 取得完整配置
```bash
# 查看當前運行的所有 YAML 配置
curl http://localhost:3200/config?format=yaml

# 取得 JSON 格式並使用 jq 篩選
curl http://localhost:3200/config?format=json | jq '.storage_config'
```