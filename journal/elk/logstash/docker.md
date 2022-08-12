# Docker 

## docker容器如何產生日誌
`docker logs` 顯示 *STDOUT* *STDERR*

如果使用將 log 發送到日誌驅動程序，則外部主機、數據庫或另一個日誌後端 docker logs 可能不會顯示有用的訊息

## logstash 
```bash
:~/docker-elk$ cat logstash/pipeline/logstash-filebeat-docker.conf
input {
        gelf { # Graylog Extended Log Format 
                type => docker
                port => 12201
        }

}

## Add your filters / logstash plugins configuration here

output {
        elasticsearch {
                hosts => "elasticsearch:9200"
                manage_template => false
                index => "filebeat-gelf-docker-%{+YYYY.MM.dd}"
        }
}
```
## docker-compose Nginx add logging
```bash
...
  nginx:
    image: nginx
    restart: always
    container_name: elk_nginx
    volumes:
      - ./nginx/conf/kibana.conf:/etc/nginx/conf.d/kibana.conf
      #- ./nginx/conf/elasticsearch.conf:/etc/nginx/conf.d/elasticsearch.conf
      - ./nginx/auth/.kibana:/etc/nginx/conf.d/.kibana
      #- ./nginx/auth/.elasticsearch:/etc/nginx/conf.d/.elasticsearch

    networks:
      - elk
    logging:
      driver: gelf
      options:
        gelf-address: "udp://0.0.0.0:12201"
        tag: nginx
    depends_on:
      - kibana
      - elasticsearch
    ports:
      - 8080:8080
      - 9090:9090
...
```

>logstash 也要將 12201 的 TCP、UDP port 做 mapping

## test
```bash
$ sudo docker run -it --log-driver gelf --log-opt gelf-address=udp://192.168.200.57:12201 alpine ping 127.0.0.1
```

## 參考資料
[gelf](https://docs.docker.com/config/containers/logging/gelf/#usage)
