# Harbor
<!--
Project Harbor is an enterprise-class registry server that stores and distributes Docker images. 
-->
**Harbor** 專案是一個能夠儲存與發佈 Docker 鏡像的企業級倉庫（registry）伺服器。

<!--
Harbor extends the open source Docker Distribution by adding the functionalities usually required by an enterprise, such as security, identity and management.
-->
**Harbor** 擴展了開源軟體 - **Docker Distribution**，添加企業經常需要的功能，如：安全性、身份驗證和鏡像管理。

## Table of contents
  - [Environment](#environment)
  - [Structure](#structure)
  - [Downloading installer](#downloading-installer)
  - [Configuring Harbor](#configuring-harbor)
  - [Installation](#installation)

## Environment
  - Hostname：swarm-registry
    - OS：Ubuntu 14.04
    - DISK：20G
    - RAM：2G
    - IP：10.211.55.20
    - Software：Docker, Docker Compose
## Structure
<img src="./001.png" alt="docker" height="50%" width="50%">


## Downloading installer
安裝器的二進檔可以從發布頁面下載。可選擇線上或離線安裝器。
- Open-source Harbor project:
  - [Harbor offline installer](https://storage.googleapis.com/harbor-releases/release-1.5.0/harbor-offline-installer-v1.5.0-rc1.tgz)
  - [Harbor online installer](https://storage.googleapis.com/harbor-releases/release-1.5.0/harbor-online-installer-v1.5.0-rc1.tgz)

下載解壓縮。
```
beladmin@swarm-registry:~$ wget https://storage.googleapis.com/harbor-releases/release-1.5.0/harbor-online-installer-v1.5.0-rc1.tgz
beladmin@swarm-registry:~$ tar xvf harbor-online-installer-v1.5.0-rc1.tgz 
```

## Configuring Harbor
修改 `harbor.cfg` 裡的參數。

```
beladmin@swarm-registry:~$ cd harbor/
beladmin@swarm-registry:~$ vi harbor.cfg 
...
#The IP address or hostname to access admin UI and registry service.
#DO NOT use localhost or 127.0.0.1, because Harbor needs to be accessed by external clients.
hostname = 192.168.200.49
...
##The initial password of Harbor admin, only works for the first time when Harbor starts. 
#It has no effect after the first launch of Harbor.
#Change the admin password from UI after launching Harbor.
harbor_admin_password = beladmin
...
beladmin@swarm-registry:~$ 
```

## Installation
安裝過程需要等待數分鐘。
```
sudo ./install.sh 
```

安裝完畢後連接網頁即可使用。
```
http://192.168.200.49/
```
