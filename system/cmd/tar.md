# Tar

## 打包壓縮

#### 打包/壓縮

```bash
$ tar cvf <ARCHIVE_TAR_NAME> <FILE_OR_FOLDER_PATH>
$ tar Zcvf <ARCHIVE_TAR_NAME> <FILE_OR_FOLDER_PATH>
```

#### 解包/解壓縮

```bash
$ tar xvf <TAR_NAME>
$ tar zxvf <TAR_NAME>
```

## 遠端壓縮傳輸

#### 拉取至本地主機

```bash
$ ssh <HOST_NAME> "tar zcvf - <FILE_OR_FOLDER_PATH>" | cat > <OUTPUT_TAR_NAME>
```


#### 推送至目的地主機

```bash
$ tar czvf -  <FILE_OR_FOLDER_PATH> | ssh <HOST_NAME> "cat > <OUTPUT_TAR_NAME>"
```