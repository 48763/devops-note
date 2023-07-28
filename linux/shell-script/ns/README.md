# ns 

- [Shell](#Shell)
- [Docker](#Docker)

## Shell

- [一般解析](#一般解析)
- [轉跳解析](#轉跳解析)
- [名稱伺服器](#名稱伺服器)

### 一般解析 

使用 `/bin/sh` 就能直接運行：

```
$ ./main https://github.com/48763 https://yayuyo.yt/
$ ./main "https://github.com/48763(test) https://yayuyo.yt(youtybe)"
```

> 如果有特殊字符，請用 `" "` 包住變量，或是加入跳脫字符 `\`

> 在 macOS 有些指令會有差異，但不影響主要功能

### 轉跳解析

添加 `-L`，就會返回轉跳後的網址解析：

```
$ ./main https://github.com/48763 https://yayuyo.yt/ -L
```

### 解析種類

添加 `-t <record_type>`，就會帶入解析種類：

```
$ ./main https://github.com/48763 https://yayuyo.yt/ -t ns
```

### 指定 DNS

添加 `-n <dns_ip_address>`，就能指定 DNS：

```
$ ./main https://github.com/48763 https://yayuyo.yt/ -n 8.8.8.8
```

## Docker

在 `.zshrc`, `.bash_profile` 或其它 shell 環境配置添加：

```
ns() {
    docker run --rm 48763/ns $@
}
```

上述添加完畢後，開新的 `tty`，就能像指令一樣直接使用：

```
$ ns https://github.com/48763
```
