# Git Page

## Docker 

```
$ docker run --rm \
  --volume="$PWD:/srv/jekyll:Z" \
  --publish 4000:4000 \
  jk \
  jekyll serve
```