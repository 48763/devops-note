# Metrics

## 啟用指標收集

### nginx 配置

```nginx
location /metrics {
  stub_status  on;
  access_log   off;
  allow 127.0.0.1; # Or the Remote IP of the Instana Host Agent
  deny  all;
}
```

###  檢查頁面

```bash
$ curl localhost/metrics
Active connections: 2 
server accepts handled requests
 103596 103596 533885 
Reading: 0 Writing: 1 Waiting: 0
```

## Nginx Prometheus Exporter

**Nginx** 利用其應用的 `stub_status on` 暴露的頁面，再使用該工具製作出 Prometheus 的能辨別的指標格式。

### 下載與解壓縮

```bash
$ wget https://github.com/nginxinc/nginx-prometheus-exporter/releases/download/v0.10.0/nginx-prometheus-exporter_0.10.0_linux_386.tar.gz
$ tar xvf nginx-prometheus-exporter_0.10.0_linux_386.tar.gz
```
> Nginx 官方發布工具 - [github](https://github.com/nginxinc/nginx-prometheus-exporter/releases)


### 運行指標暴露

```
$ ./nginx-prometheus-exporter -nginx.scrape-uri=http://localhost:80/metrics
```

<!--hyperlink-->

[1]: https://www.ibm.com/docs/en/instana-observability/current?topic=technologies-monitoring-nginx#metrics-for-nginx "IBM, Monitoring NGINX, English"
[2]: https://github.com/nginxinc/nginx-prometheus-exporter "Github, NGINX Prometheus Exporter, English"