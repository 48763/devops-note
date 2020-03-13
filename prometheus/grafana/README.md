# Grafana

## Install

```
wget https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana_5.2.4_amd64.deb 
sudo dpkg -i grafana_5.2.4_amd64.deb 
```

### Using Docker

```
$ docker run -d --name=grafana -p 3000:3000 grafana/grafana
```

#### Setting configuration

```
$ docker run \
    -d \
    -p 3000:3000 \
    --name=grafana \
    -e "GF_SERVER_ROOT_URL=http://grafana.server.name" \
    -e "GF_SECURITY_ADMIN_PASSWORD=secret" \
    grafana/grafana
```