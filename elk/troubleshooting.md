## elasticsearch

### health

```
$ curl -s localhost:9200/_cluster/health?pretty
```

```
$ curl -s localhost:9200/_cluster/health/level=indices?pretty
```

```
$ curl -s -X POST localhost:9200/_cluster/reroute?retry_failed
```

## logstash

### 硬碟空間不足

```bash
[2018-06-25T02:31:14,652][INFO][logstash.outputs.elasticsearch] retrying failed action with response code: 403 ({"type"=>"cluster_block_exception", "reason"=>"blocked by: [FORBIDDEN/12/index read-only / allow delete (api)];"})
```

刪除 elasticsearch 索引：

```bash
curl -X DELETE "192.168.200.57:9200/*?pretty"
```

[delete index](https://www.elastic.co/guide/cn/elasticsearch/guide/current/_deleting_an_index.html)

清除特定索引：

```
curl "http://localhost:9200/_cat/indices?v&h=i"
curl -XDELETE "localhost:9200/[indices-name]"
```

## kibana

```bash
Exiting: No modules or prospectors enabled and configuration reloading disabled. What files do you want me to watch?
```

全域的參數位配置：

```bash
filebeat.config:
  inputs:
    enabled: true
  modules:
    enabled: true
```

## filebeat

1. 

```shell=
Exiting: No modules or prospectors enabled and configuration reloading disabled. What files do you want me to watch?
```
filebeat.config 要配置

## metricbeat

```shell=
  "Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get http://%2Fvar%2Frun%2Fdocker.sock/v1.24/containers/json?limit=0: dial unix /var/run/docker.sock: connect: permission denied"
```

```shell=
Jul 18 11:18:33 kibana kernel: [434952.518724] audit: type=1400 audit(1531883913.444:10841): apparmor="DENIED" operation="ptrace" profile="docker-default" pid=5013 comm="metricbeat" requested_mask="trace" denied_mask="trace" peer="unconfined"
```
docker-compose 加入此
```shell=
privileged: true
```
