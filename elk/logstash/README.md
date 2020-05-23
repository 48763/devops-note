# logstash
![](https://i.imgur.com/7KkPmlF.png)

伺服器端數據處裡的地方，能夠同時從多個用戶來源端接收或獲取數據，並轉換發送到 *Elasticsearch* 。

## Content
- [Logstash pipeline](#logstash-pipeline)
    - [input](./input.md)
    - [filter](./filter.md)
    - [output](./output.md)
- [Logging drivers](#logging-drivers)
- [Logging setting](#logging-setting)
    - [Docker](./docker.md)
    - [ESXi](./esxi.md)
    - [Nginx](./nginx/)

## Logstash pipeline

*Logstash* 流水線有兩個必要元素 - `input` 和 `output`，以及一個可選元素 - `filter`。

![](https://i.imgur.com/rl6C2hf.png)

預設配置檔：
```bash
input {
	tcp {
		port => 5000
	}
}

## Add your filters / logstash plugins configuration here

output {
	elasticsearch {
		hosts => "elasticsearch:9200"
	}
}
```

## logging drivers

|Driver	| Description |
| --- | --- |
|none | No logs are available for the container and docker logs does not return any output.|
|json-file | The logs are formatted as JSON. The default logging driver for Docker.|
|syslog | Writes logging messages to the syslog facility. The syslog daemon must be running on the host machine.|
|journald | Writes log messages to journald. The journald daemon must be running on the host machine.|
|gelf | Writes log messages to a Graylog Extended Log Format (GELF) endpoint such as Graylog or Logstash.|
|fluentd | Writes log messages to fluentd (forward input). The fluentd daemon must be running on the host machine.|
|awslogs | Writes log messages to Amazon CloudWatch Logs.|
|splunk | Writes log messages to splunk using the HTTP Event Collector.|
|etwlogs | Writes log messages as Event Tracing for Windows (ETW) events. Only available on Windows platforms.|
|gcplogs | Writes log messages to Google Cloud Platform (GCP) Logging.|
|logentries | Writes log messages to Rapid7 Logentries.|

## 參考資料
- [Logstash Introduction](https://www.elastic.co/guide/en/logstash/current/introduction.html)
- [How Logstash Works](https://www.elastic.co/guide/en/logstash/current/pipeline.html)
- [Logstash Filter Plugins](https://logz.io/blog/5-logstash-filter-plugins/)
- [Grok Debug](https://grokdebug.herokuapp.com)
