# Server

## 目錄
- [啟用服務](./#啟用服務)
- [數據模型](./data-model.md#數據模型)
- [指標類型](./metric-types.md#指標metrics類型)
    - [收集 Docker 指標](./collect-docker-metrics.md)
- [配置檔](./config)

## 啟用服務

```bash
$ docker run -p 9090:9090 --name prometheus \
    -v $(pwd)/config/prometheus.yml:/etc/prometheus/prometheus.yml \
    -v $(pwd)/config/rules.yml:/etc/prometheus/rules.yml \
    -d prom/prometheus
```

訪問頁面：

```
http://127.0.0.1:9090
```

<img src="../../img/prometheus/prometheus-02.png" alt="prometheus" height="100%" width="100%">