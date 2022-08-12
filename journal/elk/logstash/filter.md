# Filter

選擇對應的插件，過濾或修改指定的數據。

## Plugins list
- dissect
- drop
- grok
- geoip
- mutate
- useragent

## dissect

```bash
dissect {
    mapping => {
        'message' => '[%{time_iso8601}] %{remote_addr}:%{remote_port}'
    }
}
```

## geoip

```bash
geoip {
    source => "remote_addr"
    add_tag => ["geoip"]
}
```

## useragent

```bash
useragent {
                source => "http_user_agent"
                target => "machine"
}
```

## 參考資料

[Official filter plugins](https://www.elastic.co/guide/en/logstash/current/filter-plugins.html)

[ELKstack 中文指南 - 过滤器插件(Filter)](https://elkguide.elasticsearch.cn/logstash/plugins/filter/)