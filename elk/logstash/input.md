# Input

選擇對應的插件，獲取來源端的數據。

## Plugins list
- beat
- file
- syslog
- TCP
- UDP

## tcp 

```bash
tcp {
    port => 2005
    type => nginx
}
```

## file

```bash
file {
    path => "/var/log/nginx/lab-host.log"
    type => "lab-host"
    start_position => "beginning"
}
```

## 參考資料

- [Official input plugins](https://www.elastic.co/guide/en/logstash/current/input-plugins.html#input-plugins)

[ELKstack 中文指南 - 输入插件(Input)](https://elkguide.elasticsearch.cn/logstash/plugins/input/)