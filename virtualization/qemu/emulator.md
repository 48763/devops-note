https://github.com/tonistiigi/binfmt

安裝 CPU 架構模擬器：

```
$ docker run --privileged --rm tonistiigi/binfmt --install all
$ docker run --privileged --rm tonistiigi/binfmt --install amd64
```

移除 CPU 架構模擬器：

```
$ docker run --privileged --rm tonistiigi/binfmt --uninstall qemu-*
$ docker run --privileged --rm tonistiigi/binfmt --uninstall qemu-x86_64
```

