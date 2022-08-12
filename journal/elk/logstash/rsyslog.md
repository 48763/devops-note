## Env
- ubuntu 14
  -  rsyslog-client
- Ubuntu 14
  - Docker ELK
  - Rsyslog Server
  
## Configuring Rsyslog Server

> rsyslog-server 配置為能夠從端口 514 與 Client 端系統 log 接收數據的集中式服務器。

將下面註解拿掉（預設是註解）
```bash
$ sudo vi /etc/rsyslog.conf
# provides UDP syslog reception
$ModLoad imudp
$UDPServerRun 514

# provides TCP syslog reception
$ModLoad imtcp
$InputTCPServerRun 514
```
>這些模塊監聽來自其他系統 log 服務器的傳入的數據
>514 是 Rsyslog 默認端口

**重啟服務**

```bash
$ sudo service rsyslog restart
```

## Configuring rsyslog Client

將 Client 的 log 發送至 Rsyslog Server。

**編輯配置檔**

rsyslog 預設兩個配置檔

```bash
$ ls /etc/rsyslog.d/
20-ufw.conf　50-default.conf
```

```bash
$ sudo vi /etc/rsyslog.d/50-default.conf
*.* @@rsyslog_server_IP:514
```

**重啟 rsyslog**

```bash
$ sudo service rsyslog restart
```

## Formatting the Log Data to JSON

>Elasticsearch 要求它接收的所有文檔都是 JSON 格式，而 rsyslog 提供了一種通過模板實現這一點的方法。

在 rsyslog-server 建立以下

```bash
$ sudo vi /etc/rsyslog.d/01-json-template.conf
template(name="json-template"
  type="list") {
    constant(value="{")
      constant(value="\"@timestamp\":\"")     property(name="timereported" dateFormat="rfc3339")
      constant(value="\",\"@version\":\"1")
      constant(value="\",\"message\":\"")     property(name="msg" format="json")
      constant(value="\",\"sysloghost\":\"")  property(name="hostname")
      constant(value="\",\"severity\":\"")    property(name="syslogseverity-text")
      constant(value="\",\"facility\":\"")    property(name="syslogfacility-text")
      constant(value="\",\"programname\":\"") property(name="programname")
      constant(value="\",\"procid\":\"")      property(name="procid")
    constant(value="\"}\n")
}
```

## Configuring the Rsyslog Server to Send to Logstash

在 rsyslog-server 上建立以下

```bash
$ sudo vi /etc/rsyslog.d/60-output.conf
*.*  @@logstash_IP:10514;json-template
```
10514 為定義 logstash 接收數據的端口

> json-template 為我們定義在 01-json-template.conf 的模板

## Configure Logstash to Receive JSON Messages


```bash
~/docker-elk/logstash/pipeline$ vi logstash-syslog.conf
input {
        tcp {
                host => "0.0.0.0"
                port => 10514
                codec => "json"
                type => "rsyslog"
        }
}

filter {
        if [type] == "rsyslog" {
                grok {
                        match => { "message" => "%{SYSLOGTIMESTAMP:syslog_timestamp} %{SYSLOGHOST:syslog_hostname} %{DATA:syslog_program}(?:\[%{POSINT:syslog_pid}\])?: %{GREEDYDATA:syslog_message}" }
                        add_field => [ "received_at", "%{@timestamp}" ]
                        add_field => [ "received_from", "%{host}" ]
        }
                date {
                        match => [ "syslog_timestamp", "MMM  d HH:mm:ss", "MMM dd HH:mm:ss" ]
                }
        }
}

output {
        elasticsearch {
                hosts => ["elasticsearch:9200"]
                index => "syslog-%{+YYYY.MM.dd}"
        }
}
```

**Configure Docker-compose**

將 logstah 的 port 多定義 `10514:10514`，讓 Docker 能夠轉發

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
      - "10514:10514"
    environment:
      LS_JAVA_OPTS: "-Xmx256m -Xms256m"
    networks:
      - elk
    depends_on:
      - elasticsearch
...
```
**驗證是否轉發**

```bash
$ sudo docker ps -a
CONTAINER ID        IMAGE                      COMMAND                  CREATED             STATUS              PORTS                                                                  NAMES
5f51435b6da0        docker-elk_logstash        "/usr/local/bin/dock…"   3 hours ago         Up 2 hours          5044/tcp, 0.0.0.0:5000->5000/tcp, 0.0.0.0:10514->10514/tcp, 9600/tcp   docker-elk_logstash_1
32c744cb0f10        docker-elk_kibana          "/bin/bash /usr/loca…"   6 days ago          Up 6 days           0.0.0.0:5601->5601/tcp                                                 docker-elk_kibana_1
452a5a7e4ef2        docker-elk_elasticsearch   "/usr/local/bin/dock…"   6 days ago          Up 6 days           0.0.0.0:9200->9200/tcp, 0.0.0.0:9300->9300/tcp                         docker-elk_elasticsearch_1
```

**驗證 Logstash 正在監聽端口 10514**

```bash
$ netstat -na | grep 10514
```
