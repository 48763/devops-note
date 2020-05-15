# 安裝

- [Docker](#docker) 
- [Linux](#linux)

## Docker

```bash
$ sudo docker run -d --name Jenkins \
    -p 8080:8080 -p 50000:50000 \
    -v jenkins_home:/var/jenkins_home \
    jenkins/jenkins:lts
```

## Linux

***系統使用 ubuntu 16.04.6 LTS***

### 版本需求

| **Jenkins 版本＼Java版本** | **Java 7** | **Java 8** | **Java 9** | **Java 10** | **Java 11** |  
| -- | :--: | :--: | :--: | :--: | :--: |
|2.164（2019-02）|✕|✓|✕|✕|✓|  
|2.54 （2017-04）|✕|✓|✕|✕|✕|  
|1.612（2015-05）|✓|✕|✕|✕|✕|  

- ***Java 8 運行環境支援 32-bit 和 64-bit 版本。***
- ***更舊版 Java 版本不支援。***

### Java 安裝

#### JDK 下載：

- [Oracle JDK](https://www.oracle.com/technetwork/java/javase/downloads/index.html)
- [OpenJDK](https://jdk.java.net/archive/)

*兩者都是由 Oracle 維護*

> Starting with JDK 11 accessing the long time support Oracle JDK/Java SE will now require a commercial license. You should now pay attention to which JDK you're installing as Oracle JDK without subscription could stop working.

第一次安裝，請參考下面指令下載、安裝及設定：

```bash
$ wget https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz
$ sudo mkdir /usr/lib/jdk
$ sudo tar xvf openjdk-11.0.2_linux-x64_bin.tar.gz -C /usr/lib/jdk
$ sudo vi /etc/environment
    /usr/lib/jdk/jdk-11/bin
    JAVA_HOME="/usr/lib/jdk/jdk-11"
$ source /etc/environment
```

系統上有多個版本，請參考下面指令管理 Java 版本。

```
$ sudo update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jdk/jdk-11/bin/java" 0
$ sudo update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jdk/jdk-11/bin/javac" 0
$ sudo update-alternatives --set java /usr/lib/jdk/jdk-11/bin/java
$ sudo update-alternatives --set javac /usr/lib/jdk/jdk-11/bin/javac
```

檢查目前系統的 Java 預設版本。

```
$ update-alternatives --list java
$ update-alternatives --list javac
```

### Jenkins 安裝

#### apt-get 安裝

下面指令為穩定版安裝，如果要安裝最新版，將網址的 `-stable` 拿掉即可。

```
$ wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins-ci.org.key | sudo apt-key add -
$ sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
$ sudo apt-get update
$ sudo apt-get install jenkins
```

#### Jenkins 下載：

- [最新版](https://pkg.jenkins.io/debian/)
- [穩定版](https://pkg.jenkins-ci.org/debian-stable/)

#### deb 安裝

```
$ wget http://pkg.jenkins-ci.org/debian-stable/binary/jenkins_2.176.1_all.deb
$ sudo dpkg -i jenkins_2.176.1_all.deb
```

## Jenkins 基本設置

### 配置檔位置

```bash
$ sudo vi /etc/default/jenkins
```

### 系統啟用檔案

```bash
$ sudo vi /etc/init.d/jenkins
```

### 密碼重置

按照下面指令，將 `/var/lib/jenkins/config.xml` 裡面的 `true` 更改成 `false`。

```bash
$ sudo vi /var/lib/jenkins/config.xml
  <useSecurity>false</useSecurity>

$ sudo service jenkins restart
```

重啟後，只要網頁進到 *Jenkins* 頁面，就可以修改用戶密碼。

最後到*設定全域安全性*或是 *`config.xml`* 內重新啟用安全性即可。

### 訪問紀錄

更進一步的管控人員使用，可以修改啟用。

```
$ sudo vi /etc/default/jenkins
# Whether to enable web access logging or not.
# Set to "yes" to enable logging to /var/log/$NAME/access_log
JENKINS_ENABLE_ACCESS_LOG="yes"

$ sudo service jenkins restart
```
