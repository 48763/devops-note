# OTP

## 環境配置

安裝相依套件：

```
$ brew install zbar
```

將腳本移至 `PATH` 會引入的目錄中：

```
$ PATH="${PATH}:~/tools"
$ mv otp totp ~/tools
```

創建存放 qrcode 目錄：

```
$ mkdir ~/.qrcode
```

### 使用方式

```
$ otp [qr_name]
```

使用時，會輸出 `~/.qrcode` 下的檔案，並詢問要選擇的檔案，輸入的名稱只要是唯一匹配，都能正常執行：

```
$ otp
qr_file-1.png
qr_file-2.jpeg

Please input qrcode file name: file-1
qr_file-1 code: 123456
```

> 在 OS X 的系統上，最後會使用 `pbcopy` 將驗證碼存到剪貼簿，所以直接貼上將會是驗證碼。

> 如果非 OS X 用戶，可以將代碼的 `pbcopy` 刪除即可。

帶檔案的部分名稱時，只要名稱是唯一匹配，就會直接輸出驗證碼：

```
$ otp file-2
qr_file-2 code: 654321
```