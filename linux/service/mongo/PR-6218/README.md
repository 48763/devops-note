## Fix shell script in ulimit.txt 

### Fix `process_pids` empty

Command `ps -C $process -o pid --no-headers` output prefix has 4 spaces on ubuntu 20.04 (older version had only 1 spaces), so the argument `process_pids` will empty in shell script.

Modify `cut -d " " -f 2` to `grep -oP "[[:digit:]]*"`, can solve this problem, and makes both versions compatible.

### Fix operator expected

If using multiple arguments, will cause problem and shows following error message: 

```
$ return-limits mongod mongos
-bash: [: mongod: binary operator expected
-bash: [: mongod: binary operator expected
```

The argument `$@` should be changed to `process_pids` In the `if` conditional expressions, which can solve the problem and be more actual.