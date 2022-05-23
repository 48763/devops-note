# Binlog to S3

## 密碼存放

```
$ echo "PASSWORD" > .pass.txt
```

## Crontab

```bash
$ crontab -e
*/5 * * * * /opt/binlog-to-s3/main 2>&1 | grep --line-buffered -v "password" >> /var/log/binlog-to-s3.log
```
