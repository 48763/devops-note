# LIMA

- 官方虛擬機配置範例：

```console
$ /usr/local/Cellar/lima/0.7.2/share/doc/lima/examples
```

- `ssh` 的連線配置：

```console
Host lima*
	StrictHostKeyChecking no
	HostName 127.0.0.1
	IdentityFile ~/.ssh/id_rsa
	Port 48763
```
