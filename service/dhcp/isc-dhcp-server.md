# Isc-dhcp-server
[Official github](https://github.com/isc-projects/kea/blob/master/README)

## Foreword
一般使用 DHCP 伺服器的情況，是為了讓用戶連接至網路後，便能自動取得網路相關設定。

而在此案例中，則是使用 DHCP 伺服器中的 `IP reserve`，固定一臺設備的 IP 位置以及其相關設定。
看上去跟設定用戶的 *靜態 IP* 一樣，但試著想像，面對卅臺設備要變更 DNS 時，那將是個非常耗時耗工的事情。

雖然使用 DHCP 的 `IP reserve` 功能，事前需要寫其配置檔，但是對未來的管理會方便許多。

## Environment
- Hostname：dhcp
  - OS：Ubuntu 14.04
  - IP：192.168.7.20
  - RAM：1G
  - DISK：20G
- Hostname：server
  - OS：Ubuntu 14.04
  - IP：192.168.7.101 
  - MAC：00:0c:29:d5:6e:31
  - RAM：1G
  - DISK：20G

## Table of contents
- [Install isc-dhcp-server](#install-isc-dhcp-server)
- [Set config file](#set-config-file)
- [Client use dhcp](#client-use-dhcp)

## Install isc-dhcp-server
更新並安裝 `isc-dhcp-server`。

```bash
Yuki@dhcp:~$ sudo apt-get update
Yuki@dhcp:~$ sudo apt-get instal isc-dhcp-server
```

## Set config file
設定 DHCP 主要配置檔。並預先寫入 `include` ，稍後會新建此用戶配置檔。

```bash
Yuki@dhcp:~$ sudo vi /etc/dhcp/dhcpd.conf

ddns-update-style none;
log-facility local7;

# No service will be given on this subnet, but declaring it helps the
# DHCP server to understand the network topology.
authoritative;

# Service
subnet 192.168.7.0 netmask 255.255.255.0 {
        range 192.168.7.200 192.168.7.250;

        option subnet-mask 255.255.255.0;
        option routers 192.168.7.254;
        option domain-name-servers 8.8.4.4;
        option broadcast-address 192.168.7.255;

        default-lease-time 90000; # 25hr
        max-lease-time 108000; # 30hr

        include "/etc/dhcp/server.conf";
}
```

新建需固定 `IP` 的用戶配置檔。
```bash
Yuki@dhcp:~$ sudo vi /etc/dhcp/server.conf

host server {
        hardware ethernet 00:0c:29:d5:6e:31;
        fixed-address 192.168.7.41;
}
```

## Client use dhcp

### Verify
在這先放上 `server` 網卡相關資訊。

```bash
Yuki@server:~$ ifconfig 
eth0      Link encap:Ethernet  HWaddr 00:0c:29:d5:6e:31  
          inet addr:192.168.7.101  Bcast:192.168.7.255  Mask:255.255.255.0
...   
Yuki@server:~$ cat /etc/network/interfaces
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

# The loopback network interface
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp 
```

### Set
重新取得 DHCP 資訊設定，並驗證取得的內容用正確。

```bash
Yuki@server:~$ sudo dhclient -nw 
Yuki@server:~$ cat /var/lib/dhcp/dhclient.leases
lease {
  interface "eth0";
  fixed-address 192.168.7.41;
  option subnet-mask 255.255.255.0;
  option routers 192.168.7.254;
  option dhcp-lease-time 90000;
  option dhcp-message-type 5;
  option domain-name-servers 8.8.4.4;
  option dhcp-server-identifier 192.168.7.20;
  option broadcast-address 192.168.7.255;
  renew 3 2018/01/03 18:56:43;
  rebind 4 2018/01/04 06:54:49;
  expire 4 2018/01/04 10:02:19;
}
```

