# 資料傳輸

## scp

```
$ scp -rpCl 8000
```

- r：目錄複製。
- p：保留權限/修改日期。
- C：傳輸壓縮。
- l：網路限制。

## rsync

```
$ rsync -avhz --bwlimit=1K --progress --delete --exclude
```

- a：等於 `rlptgoD`，遞迴所有目錄，並保持所有檔案的原資料。
- v：詳細輸出。
- h：可視化輸出。
- z：傳輸壓縮。
- bwlimit：限制頻寬。
- progress：顯示進度條。
- delete：同步移除檔案。
- exclude：排除特定檔案。
