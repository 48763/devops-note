# User authentication
*Kibana* 從 5.5 開始不提供用戶認證，所以需要透過 *Nginx* 的反向代理，以及 *Apache* 套件，實現基本的用戶認證功能。

## 專案結構
```
.
├── docker-compose.yml
├── elasticsearch
│   ├── config
│   │   └── elasticsearch.yml
│   └── Dockerfile
├── extensions
│   ├── logspout
│   │   ├── build.sh
│   │   ├── Dockerfile
│   │   ├── logspout-compose.yml
│   │   ├── modules.go
│   │   └── README.md
│   └── README.md
├── kibana
│   ├── config
│   │   └── kibana.yml
│   └── Dockerfile
├── LICENSE
├── logstash
│   ├── config
│   │   └── logstash.yml
│   ├── Dockerfile
│   └── pipeline
│       ├── logstash.conf
│       └── logstash-filebeat-nginx.conf
├── nginx
│   ├── auth
│   └── conf
│       ├── elasticsearch.conf
│       └── kibana.conf
└── README.md
```

## Set authentication

### Install tool
```bash
$ sudo apt-get install apache2-utils
```

### Create `.htpasswd`

```bash
$ sudo htpasswd -c ./nginx/auth/.Ehtpasswd elasticsearch
$ sudo htpasswd -c ./nginx/auth/.Khtpasswd kibana
# -c 產出來的認證放置位址
```


### Create a virtual host configuration of nginx

#### Kibana
```bash
server {
        listen  8080 default_server;
        server_name  kibana;
        location / {
                auth_basic "Restricted Access";
                auth_basic_user_file /etc/nginx/auth/.Khtpasswd;
                autoindex on;
                proxy_pass http://kibana:5601;
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection 'upgrade';
                proxy_set_header Host $host;
                proxy_cache_bypass $http_upgrade;
        }
        access_log  /var/log/nginx/access.log  main;
}
```

#### Elasticsearch

```bash
server {
        listen  9090 default_server;
        server_name  elasticsearch;
        location / {
                auth_basic "Restricted Access";
                auth_basic_user_file /etc/nginx/auth/.Ehtpasswd;
                autoindex on;
                proxy_pass http://elasticsearch:9200;
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection 'upgrade';
                proxy_set_header Host $host;
                proxy_cache_bypass $http_upgrade;
        }
        access_log  /var/log/nginx/access.log  main;
}
```

### Modify docker compose

```bash
nginx:
    image: nginx
    restart: always
    container_name: elk_nginx
    volumes:
      - ./nginx/conf/:/etc/nginx/conf.d/:rw
      - ./nginx/auth/:/etc/nginx/auth/:ro
    networks:
      - elk
    depends_on:
      - kibana
    ports:
      - 8080:8080
      - 9090:9090
```