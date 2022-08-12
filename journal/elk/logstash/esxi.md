## 描述
所有 ESXi 主機都有一個 Syslog 服務（vmsyslogd），可將來自不同系統組件的消息寫入不同的 log 文件。

## ESXi 配置 syslog

**配置 Syslog**

[ESXi 主機組態] > [軟體] > [進階設定] > [Syslog]
```bash
Syslog.global.logHost：tcp：//logstash_IP：1514
Config.HostAgent.log.level：info
```
**防火牆**

開啟 syslog 服務
[ESXi 主機組態] > [軟體] > [安全性設定檔] > [防火牆]，然後開啟 [屬性]

**重啟**

重啟 syslog 服務

**ESXi Log File Locations**

**Component** | **Location** | **Purpose** |
--- | --- | --- |
VMkernel | /var/log/vmkernel.log | Records activities related to virtual machines and ESXi.
VMkernel warnings | /var/log/vmkwarning.log | Records activities related to virtual machines.
VMkernel summary | /var/log/vmksummary.log | Used to determine uptime and availability statistics for ESXi (comma separated).
ESXi host agent log | /var/log/hostd.log | Contains information about the agent that manages and configures the ESXi host and its virtual machines.
vCenter agent log | /var/log/vpxa.log |Contains information about the agent that communicates with vCenter Server (if the host is managed by vCenter Server).
Shell log | /var/log/vpxa.log | Contains a record of all commands typed into the ESXi Shell as well as shell events (for example, when the shell was enabled).
Authentication | /var/log/auth.log |Contains all events related to authentication for the local system.
System messages | /var/log/syslog.log | Contains all general log messages and can be used for troubleshooting. This information was formerly located in the messages log file.
Virtual machines | The same directory as the affected virtual machine's configuration files, named vmware.log and vmware*.log. For example, /vmfs/volumes/datastore/virtual machine/vwmare.log | Contains virtual machine power events, system failure information, tools status and activity, time sync, virtual hardware changes, vMotion migrations, machine clones, and so on.

## logstash 配置檔

```bash
~/docker-elk/logstash/pipeline$ vi logstash-vmware.conf
input {
        tcp {
                port => 1514
                type => "vmware"
        }
}

filter {
#       if [type] == "vmware" {
#                mutate {
#                        add_tag => "vmware"
#                }
#        }
#       if "VMware" in [tags] {
#               grok {
#                        match => { "message" => "%{SYSLOGTIMESTAMP:syslog_timestamp} %{SYSLOGHOST:syslog_hostname} %{DATA:syslog_program}(?:\[%{POSINT:syslog_pid}\])?: %{GREEDYDATA:syslog_message}" }
#                        add_field => [ "received_at", "%{@timestamp}" ]
#                        add_field => [ "received_from", "%{host}" ]
#        }
#                date {
#                        match => [ "syslog_timestamp", "MMM  d HH:mm:ss", "MMM dd HH:mm:ss" ]
#                }
#       }
}

output {
        elasticsearch {
                hosts => ["elasticsearch:9200"]
                index => "logstash-vsphere-syslog-esxi-%{+YYYY.MM.dd}"
        }
}
```
**Configure Docker-compose**

將 logstah 的 port 多定義 1514:1514，讓 Docker 能夠轉發
```bash
$ vi ~/docker-elk/docker-compose.yml
...
logstash:
    build:
      context: logstash/
    volumes:
      - ./logstash/config/logstash.yml:/usr/share/logstash/config/logstash.yml:ro
      - ./logstash/pipeline:/usr/share/logstash/pipeline:ro
    ports:
      - "5000:5000"
      - "1514:1514"
    environment:
      LS_JAVA_OPTS: "-Xmx256m -Xms256m"
    networks:
      - elk
    depends_on:
      - elasticsearch
...
```

**檢查數據接收**

`logstash-vsphere-syslog-esxi-2018.05.14` 是我們在 logstash-vmware 所定義的 `index`
```bash
$ curl -X GET "192.168.200.57:9200/_cat/indices?v"
health status index                                   uuid                   pri rep docs.count docs.deleted store.size pri.store.size
yellow open   logstash-vsphere-syslog-esxi-2018.05.14 E83DCSW0SvezHvLVqCyE0A   5   1        372            0    296.7kb        296.7kb
yellow open   logstash-2018.05.04                     cLe24X2LQaO3RkDroZ6lBw   5   1          4            0     16.1kb         16.1kb
green  open   .kibana                                 SNEnijPmSeegwUuVIpS14w   1   0          6            0       33kb           33kb
```

**驗證 Logstash 正在監聽端口 1514**

```bash
$ netstat -na | grep 1514
tcp6       0      0 :::1514                 :::*                    LISTEN
```

## Kibana

此時 Kibana `Index Patterns` 可以建立 logstash-vsphere-syslog-esxi-2018.05.14 的 index。`Discover` 也可以看見 vmware ESXi 傳送進來的數據。
![VMware](https://github.com/CCH0124/Business/blob/master/ubuntu/ELK%20Stack/Docker/ELK%20Image/VMware.png "VMware")


## 定義過濾數據

Logstash [grok](https://www.elastic.co/guide/en/logstash/current/plugins-filters-grok.html)
1. 建立 patterns 資料夾或者其它
2. 切換至剛創建的資料夾，並建立 vmware-ESXi-patterns 檔案
3. 編輯 vmware-ESXi-patterns
```bash
$ vi vmware-ESXi-patterns
SYSLOGLEVEL ([Aa]lert|ALERT|[Vv]erbose|[Tt]rivia|[Tt]race|TRACE|[Dd]ebug|DEBUG|[Nn]otice|NOTICE|[Ii]nfo|INFO|[Ww]arn?(?:ing)?|WARN?(?:ING)?|[Ee]rr?(?:or)?|ERR?(?:OR)?|[Cc]rit?(?:ical)?|CRIT?(?:ICAL)?|[Ff]atal|FATAL|[Ss]evere|SEVERE|EMERG(?:ENCY)?|[Ee]merg(?:ency)?)
```
4. 切換至 logstash-vmware.conf 新增以下
```bash
filter {
        filter {
        grok {
                patterns_dir => ["~/docker-elk/logstash/pipeline/patterns/vmware-ESXi-patterns"]
                break_on_match => true
                match => [

            "message", "<%{POSINT:syslog_pri}>1 %{TIMESTAMP_ISO8601:message_timestamp} %{SYSLOGHOST:message_hostname} %{SYSLOGPROG:message_program} %{NUMBER:message_process_id} \- \- Event \[%{NUMBER:message_event_id}\] \[1-1\] \[%{TIMESTAMP_ISO8601:message_timestamp_2}\] \[%{DATA:message_event}\] \[%{LOGLEVEL:message_event_level}\] \[%{DOMAINUSER:message_domainuser}\] \[%{DATA:message_event_datacenter}\] \[%{NUMBER:message_event_id_2}\] \[%{GREEDYDATA:message_event_content}",
            "message", "<%{POSINT:syslog_pri}>1 %{TIMESTAMP_ISO8601:message_timestamp} %{SYSLOGHOST:message_hostname} %{SYSLOGPROG:message_program} %{NUMBER:message_process
_id} \- \-  Event \[%{NUMBER:message_event_id}\] \[1-1\] \[%{TIMESTAMP_ISO8601:message_timestamp_2}\] \[%{DATA:message_event}\] \[%{LOGLEVEL:message_event_level}\] \[%{DOMA
INUSER:message_domainuser}\] \[%{DATA:message_event_datacenter}\] \[%{NUMBER:message_event_id_2}\] %{GREEDYDATA:message_event_content}",
            "message", "<%{POSINT:syslog_pri}>1 %{TIMESTAMP_ISO8601:message_timestamp} %{SYSLOGHOST:message_hostname} %{SYSLOGPROG:message_program} %{NUMBER:message_process
_id} \- \- Event \[%{NUMBER:message_event_id}\] \[1-1\] \[%{TIMESTAMP_ISO8601:message_timestamp_2}\] \[%{DATA:message_event}\] \[%{LOGLEVEL:message_event_level}\] \[%{DOMAI
NUSER:message_domainuser}\] \[\] \[%{NUMBER:message_event_id_2}\] \[%{GREEDYDATA:message_event_content}",
            "message", "<%{POSINT:syslog_pri}>1 %{TIMESTAMP_ISO8601:message_timestamp} %{SYSLOGHOST:message_hostname} %{SYSLOGPROG:message_program} %{NUMBER:message_process
_id} \- \-  Event \[%{NUMBER:message_event_id}\] \[1-1\] \[%{TIMESTAMP_ISO8601:message_timestamp_2}\] \[%{DATA:message_event}\] \[%{LOGLEVEL:message_event_level}\] \[%{DOMA
INUSER:message_domainuser}\] \[\] \[%{NUMBER:message_event_id_2}\] \[%{GREEDYDATA:message_event_content}",
            "message", "<%{POSINT:syslog_pri}>1 %{TIMESTAMP_ISO8601:message_timestamp} %{SYSLOGHOST:message_hostname} %{SYSLOGPROG:message_program} %{NUMBER:message_process
_id} \- \-  %{TIMESTAMP_ISO8601:message_timestamp_2} %{LOGLEVEL:message_level} %{SYSLOGPROG:message_program_2}\[%{DATA:message_thread_id}\] \[%{DATA:message_originator}\] %
{GREEDYDATA:message_content}",
            "message", "<%{POSINT:syslog_pri}>1 %{TIMESTAMP_ISO8601:message_timestamp} %{SYSLOGHOST:message_hostname} %{SYSLOGPROG:message_program} %{NUMBER:message_process
_id} \- \- %{TIMESTAMP_ISO8601:message_timestamp_2} %{LOGLEVEL:message_level} %{SYSLOGPROG:message_program_2}\[%{DATA:message_thread_id}\] \[%{DATA:message_originator}\] %{
GREEDYDATA:message_content}",
            "message", "<%{POSINT:syslog_pri}>1 %{TIMESTAMP_ISO8601:message_timestamp} %{SYSLOGHOST:message_hostname} %{SYSLOGPROG:message_program} %{NUMBER:message_process
_id} \- \-  %{TIMESTAMP_ISO8601:message_timestamp_2} %{LOGLEVEL:message_level} %{GREEDYDATA:message_content}",
            "message", "%{GREEDYDATA:message_content}"
        ]
                tag_on_failure => [ "grok_not_match" ]
    }
}
```
