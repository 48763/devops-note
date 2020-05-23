## Env
- Docker
  - filebeat
  - ELK
## 資料夾
```bash
$ ls -Rl filebeat/
filebeat/:
total 4
-rw-r--r-- 1 beladmin beladmin 536 Jun 21 08:46 filebeat.yml
```
## Configuring Filebeat
要配置 Filebeat，請編輯配置文件。此地方，以 filebeat.yml 為檔名。
```bash
filebeat.modules:
- module: nginx
  access:
    enabled: true
    var.paths: ["/var/log/nginx/access.log*"]
  error:
    enabled: true
    var.paths: ["/var/log/nginx/error.log*"]
#filebeat.inputs:
#- type: log
#  enabled: true
#  paths:
#    - /var/log/nginx/access.log
output.logstash:
  enabled: true
  hosts: ["192.168.200.57:18081"]
  ssl.enabled: false
setup.dashboards:
  enabled: true
setup.kibana:
  host: "192.168.200.57:5601"
  ssl.enabled: false
```

在 Docker 裡將它掛載至 `/usr/share/filebeat/filebeat.yml`

## Run filebeat on Docker

```bash
$  sudo docker run -d  -v ~/filebeat/filebeat.yml:/usr/share/filebeat/filebeat.yml -v /var/log/nginx/:/var/log/nginx/ --name=filebeat  docker.elastic.co/beats/filebeat:6.2.4
```
[參考資料](https://logz.io/blog/filebeat-tutorial/)

> Log 權限須注意
```bash
$ sudo chmod o+r /var/log/nginx/access.log
```

## Filebeat configuration file on Docker

**prospectors**

負責管理收割機並找到所有要讀取的來源。

```bash
 cat /usr/share/filebeat/prospectors.d/default.yml
- input_type: log
  paths:
    - /mnt/log/*.log
```
Filebeat 目前支持兩種 prospector 類型
  - log
  - stdin
  
> Filebeat prospectors 只能讀取本地文件。沒有功能可以連接到遠程主機來讀取存儲的文件或日誌。
> 此語法在 6.0.0 版刪除，[官方](https://www.elastic.co/guide/en/beats/filebeat/master/filebeat-reference-yml.html)

## Nginx modules 啟用

```bash
~/docker-elk$ vi elasticsearch/Dockerfile
新增以下
RUN elasticsearch-plugin install ingest-user-agent && \
        elasticsearch-plugin install ingest-geoip

```
> 重 build elk compose。


http://localhost:5601/app/kibana#/dashboard  替換 localhost 為 Kibana 主機。即可看到 dashboards。

[filebeat-module-nginx](https://www.elastic.co/guide/en/beats/filebeat/6.2/filebeat-module-nginx.html)

## 新增 logstah 的 conf

因為我們是藉由 filebeat 傳到 logstah。但 filebeat 自帶 nginx 模組和 dashboard，所以得讓 logstash 的 filter 與 filebeat 的切割 Nginx 的 log 方式相同這樣才能吃 dashboard。

```bash
~/docker-elk/logstash/pipeline$ vi logstash-filebeat-nginx.conf
input {
        beats {
                port => "18081"
                host => "0.0.0.0"
                codec => "json"
        }
}

filter {
        if [fileset][module] == "nginx" {
                if [fileset][name] == "access" {
                        grok {
                                match => { "message" => ["%{IPORHOST:[nginx][access][remote_ip]} - %{DATA:[nginx][access][user_name]} \[%{HTTPDATE:[nginx][access][time]}\] \"%{WORD:[nginx][access][method]} %{DATA:[nginx][access][url]} HTTP/%{NUMBER:[nginx][access][http_version]}\" %{NUMBER:[nginx][access][response_code]} %{NUMBER:[nginx][access][body_sent][bytes]} \"%{DATA:[nginx][access][referrer]}\" \"%{DATA:[nginx][access][agent]}\""] }
                                remove_field => "message"
                        }
                        mutate {
                                add_field => { "read_timestamp" => "%{@timestamp}" }
                        }
                        date {
                                match => [ "[nginx][access][time]", "dd/MMM/YYYY:H:m:s Z" ]
                                remove_field => "[nginx][access][time]"
                        }
                        useragent {
                                source => "[nginx][access][agent]"
                                target => "[nginx][access][user_agent]"
                                remove_field => "[nginx][access][agent]"
                        }
                        geoip {
                                source => "[nginx][access][remote_ip]"
                                target => "[nginx][access][geoip]"
                        }
                } else if [fileset][name] == "error" {
                        grok {
                                match => { "message" => ["%{DATA:[nginx][error][time]} \[%{DATA:[nginx][error][level]}\] %{NUMBER:[nginx][error][pid]}#%{NUMBER:[nginx][error][tid]}: (\*%{NUMBER:[nginx][error][connection_id]} )?%{GREEDYDATA:[nginx][error][message]}"] }
                                remove_field => "message"
                        }
                        mutate {
                                rename => { "@timestamp" => "read_timestamp" }
                        }
                        date {
                                match => [ "[nginx][error][time]", "YYYY/MM/dd H:m:s" ]
                                remove_field => "[nginx][error][time]"
                        }
                }
        }
}

output {
        elasticsearch {
                hosts => ["elasticsearch:9200"]
                manage_template => false
                index => "%{[@metadata][beat]}-%{[@metadata][version]}-%{+YYYY.MM.dd}"
        }
        stdout { codec => rubydebug }
}
```
[nginx-fields](https://www.elastic.co/guide/en/beats/filebeat/current/exported-fields-nginx.html)
## index patterns
雖然設置完成但 Dashboard 出現 Could not locate that index-pattern (id: filebeat-*), \[click here to re-create it\]\(\#/management/kibana/index?id=filebeat-%252A&name=\) 錯誤

**解決**

它正在尋找索引模式 UUID 等於 filebeat-* 索引模式名稱而不是索引模式名稱。
再新增 index patterns 時在高級設置設定 filebeat-* 即可。如下圖：
![advanced options](https://github.com/CCH0124/Business/blob/master/ubuntu/ELK%20Stack/Docker/ELK%20Image/kibana%20advanced%20options.png)

## nginx log format
預設即可

```bash
log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                                '$status $body_bytes_sent "$http_referer" '
                                '"$http_user_agent" "$http_x_forwarded_for"'
                                '$server_addr $request_time $host $server_port';
```
## 問題解決

