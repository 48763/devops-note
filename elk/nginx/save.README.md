# Nginx

## To ELK 

### Nginx configure
```nginx
server {
        listen 8080 default_server;

        root /usr/share/nginx/html;
        index index.html index.htm;

        log_format timed_combined '[$time_iso8601] '
                '$remote_addr:$remote_port $remote_user [$server_port] '
                '"$request" $request_length $status '
                '"$request_uri" "$request_filename" "$query_string" '
                '$http_referer "$http_user_agent" $cookie_name '
                '$request_time $upstream_response_time $pipe $request_completion '
                '$bytes_sent $body_bytes_sent';

        access_log /var/log/nginx/lab-host.log timed_combined;
}
```

[Nginx log format](../../../nginx/log-format.md)

### Logstash configure

logstash 讀檔並傳至 elasticsearch

```bash
~/docker-elk/logstash/pipeline$ sudo vi logstash-nginx.conf
input {
        file {
                path => ["/var/log/nginx/lab-host.log"]
                start_position => "beginning"
                exclude => ["*.gz"]
                codec => "json"
        }
}

filter {
                grok {
                        match => [ "message" , "%{COMBINEDAPACHELOG}+%{GREEDYDATA:extra_fields}"]
                        overwrite => [ "message" ]
                }

                mutate {
                        convert => ["status", "integer"]
                        convert => ["bytes", "integer"]
                        convert => ["respnsetime", "float"]
                }

                geoip {
                        source => "remote_ip"
                        target => "geoip"
                        add_tag => [ "nginx-geoip" ]
                }

                date {
                        match => [ "timestamp" , "dd/MMM/YYYY:HH:mm:ss Z" ]
                        remove_field => [ "timestamp" ]
                }
                useragent {
                        source => "agent"
                        target => "user_agent"
                }
}

output {
        elasticsearch {
                hosts => ["elasticsearch:9200"]
                index => "NginxLog-%{+YYYY.MM.dd}"
        }

        stdout { codec => rubydebug }
}

```

### Mount log

將 Nginx Log 掛載至 Docker

```bash
~/docker-elk/logstash/pipeline$ mkdir NginxLog
~/docker-elk/logstash/pipeline$ ln -s /var/log/nginx NginxLog
```
更改 compose
```bash
~/docker-elk/logstash/pipeline$ sudo vi ~/docker-elk/docker-compose.yml
...
 volumes:
      - ./logstash/config/logstash.yml:/usr/share/logstash/config/logstash.yml:ro
      - ./logstash/pipeline:/usr/share/logstash/pipeline:ro
      - ./logstash/pipeline/NginxLog/nginx:/usr/share/logstash/pipeline/NginxLog/nginx:ro # 新增此行
...
```
重新 build
```bash
~/docker-elk/logstash/pipeline$ sudo docker-compose stop && sudo docker-compose -f ~/docker-elk/docker-compose.yml up -d
Stopping docker-elk_logstash_1      ... done
Stopping docker-elk_kibana_1        ... done
Stopping docker-elk_elasticsearch_1 ... done
Starting docker-elk_elasticsearch_1 ... done
Starting docker-elk_kibana_1        ... done
Recreating docker-elk_logstash_1    ... done
```

## To rsyslog(未完待續)

將 Nginx Log 傳至 rsyslog 在輸出至 kibana。  
創建 nginx-log.conf 檔案，並寫入規則。
```bash
/etc/rsyslog.d$ sudo vi /etc/rsyslog.d/nginx-log.conf
$ModLoad imfile
# access log
$InputFileName /var/log/nginx/access.log # 讀取 log 文件
$InputFileTag nginx-access: # 附加標籤
$InputFileStateFile stat-nginx-access 
$InputFileSeverity notice
$InputFileFacility local6
$InputFilePollInterval 1
$InputRunFileMonitor # 進行讀取動作
```

[log-nginx-to-rsyslog](https://petermolnar.net/log-nginx-to-rsyslog/)

