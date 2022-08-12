# NFS
NFS（Network File System）是一種分散式檔案系統協定，其功能旨在允許用戶端主機可以像存取本地儲存一樣通過網路存取伺服器端檔案。

## Notable benefits
<!-- 
1. Local workstations use less disk space because commonly used data can be stored on a single machine and still remain accessible to others over the network.
-->
1. 減少工作站的硬碟空間使用，因為可以將常用的資料存放在單一機器上，並且其他人也能透過網路訪問。

<!-- 
2. There is no need for users to have separate home directories on every network machine. Home directories could be set up on the NFS server and made available throughout the network.
-->
2. 用戶不需要在每台網路主機上設置家目錄（`home`）。家目錄（`home`）可以設定在 *NFS* 伺服器上，並且透過網路都能存取。

<!-- 
3. Storage devices such as floppy disks, CDROM drives, and USB Thumb drives can be used by other machines on the network. This may reduce the number of removable media drives throughout the network.
-->
3. 儲存裝置（如：軟碟、光碟機和隨身碟）可以提供網路上的其它機器使用。可以減少整個網路中可移動的媒體裝置數量。

## Environment
- Hostname：server
  - OS：Ubuntu 14.04
  - IP：192.168.1.1
- Hostname：host
  - OS：Ubuntu 14.04
  - IP：192.168.1.2

## Set up *NFS* server on `server`

### Installation nfs server

在 `server` 上安裝 *nfs* 伺服器。
```bash
Yuki@server:~$ sudo apt-get update
Yuki@server:~$ sudo apt-get install nfs-kernel-server
```

### Make directory
新建欲分享給其他用戶的資料夾。
```bash
Yuki@server:~$ sudo mkdir /data
```

### Add share directory to config
在配置檔 *exports* 裡添加欲分享的資料夾以及其設定。
```
Yuki@server:~$ sudo vi /etc/exports
/data 192.168.1.0/24(rw,sync,no_root_squash,no_subtree_check)
```

## Mount *FNS* directory on `host`

### Installation nfs client
在 `host` 上安裝 *nfs* 用戶端。
```
Yuki@host:~$ sudo apt-get install nfs-common
```

### Create mount point
新增欲掛 *NFS* 資料夾的位置。
```
Yuki@host:~$ sudo mkdir /data
```

### Mount directory of *NFS*
掛載 *NFS* 資料夾到指定的位置。
```
Yuki@host:~$ sudo mount 192.168.1.1:/data /data
```
