# 重新導向

```
$ :> file
```

`/dev/fd/63`
```
$ wc < <(echo string; echo or string)
```

```
$ find . | grep *.md > file
```

```
$ du -sx * 2>/dev/null
```

```
$ du -sx * 1>file 2>&1
```

```
$ nc -l 22 &> /dev/null
```

```
```

- [3 Basic Shell Features 3.6 Redirections](https://www.gnu.org/software/bash/manual/html_node/Redirections.html)

- [Simple explanation for how pipes work in Bash.](https://stackoverflow.com/a/32946581)

- [Pipe doesn't to write temporary file.](https://superuser.com/a/81681)

- [Redirecting Output from a Running Process.](https://stackoverflow.com/a/1323999)