# Location 

測試工具：[Nginx location match tester](https://nginx.viraptor.info/)

nginx 評估順序如下：

```nginx
server {
    listen 80;

    location = / {
        # exact match 
    } 

    location ^~ / {
        # priority prefix match
    } 

    location ~ / {
        # sensitive regex match
    } 

    location ~* / {
        # insensitive regex
    }

    location / {
        # prefix match
    }
}
```

> 0. `=` will speed up the processing of these requests, as search terminates right after the first comparison.
> 1. Among them, the location with the longest matching prefix is selected and remembered. 
> 2. Then regular expressions are checked, in the order of their appearance in the configuration file. 
> 3. The search of regular expressions terminates on the first match, and the corresponding configuration is used. 
> 4. If no match with a regular expression is found then the configuration of the prefix location remembered earlier is used.


