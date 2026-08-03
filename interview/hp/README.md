# File

該應用透過訪問 `/file/` 加上 `/path/<filename>`，並且搭配 HTTP method，可以進行檔案的操作。

- GET: `uri` 結尾 `/` 確認***目錄***是否存在，如存在則輸出目錄下的檔案；反之則僅測試***檔案***是否存在。
- POST: 給予檔案路徑以***上傳***檔案。
- PATCH: 給予檔案路徑以***更新***檔案。
- DELETE: 給予檔案路徑以***刪除***檔案。

## 需求

- docker-ce
- docker-compose

## 建置與運行

使用下面指令建置鏡像與運行容器：

```
$ docker-compose up -d
```

## 測試

使用 `route.sh` 可以測試各路徑及 HTTP method：

```
$ cd tests
$ ./route.sh
```