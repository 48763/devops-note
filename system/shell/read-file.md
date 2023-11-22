# 確認檔案格式與終止符

> ISO/IEC 9899:2011 §7.19.2 Streams
>
>  Whether the last line requires a terminating new-line character is implementation-defined. Characters may have to be added, altered, or deleted on input and output to conform to differing conventions for representing text in the host environment.

```
$ od -t c <filename>
```

```
$ od -c <filename>
```

```
$ cat -e <filename>
```

```
$ vi <<filename>>
:set list
:set ff
```

```
$ echo ${IFS} | od -c
```

- [Programming languages — C（ISO/IEC 9899:TC2）](http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1124.pdf)

- [Shell script read missing last line](https://stackoverflow.com/a/3570051)

- [How to find out line-endings in a text file?](https://stackoverflow.com/a/12916758)
