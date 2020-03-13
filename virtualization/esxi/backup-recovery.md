# 配置檔備份/還原

伺服器重建或遷移時使用。

## 備份

```bash
$ vim-cmd hostsvc/firmware/backup_config
Bundle can be downloaded at : http://*/downloads/5254689c-4e89-63c9-82c2-8643244d718b/configBundle-ZEUS.tgz
```

## 還原

```bash
$ vim-cmd hostsvc/maintenance_mode_enter
```

```bash
$ vim-cmd hostsvc/firmware/restore_config /tmp/configBundle.tgz
```