# Mac connect cisco thought console

### 安裝驅動

安裝[驅動](./PL2303.zip)，之後重新開機方能使用。

### 連線

Console 插入連接到交換機/路由器後，檢索 `tty.usb`：

```
$ ls /dev | grep tty.usb
```

連進 console：

```
$ screen /dev/tty.usbserial
```
