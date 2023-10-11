# Setting up hashes

To quickly process static sets of data such as server names, map directive’s values, MIME types, names of request header strings, nginx uses hash tables. During the start and each re-configuration nginx selects the minimum possible sizes of hash tables such that the bucket size that stores keys with identical hash values does not exceed the configured parameter (hash bucket size). The size of a table is expressed in buckets.

## Directives

```
Syntax: server_names_hash_bucket_size 64;
Context: http
```
Sets the bucket size for the server names hash tables. The default value depends on the size of the processor’s cache line.

```
Syntax:	proxy_headers_hash_bucket_size 64;
Context: http, server, location
```

Sets the bucket size for hash tables used by the proxy_hide_header and proxy_set_header directives.

> 
>
> ```
> $ lscpu | grep L1
> L1d cache:           64K
> ```
>

```
Syntax: server_names_hash_max_size 512;
Context: http
```

Sets the maximum size of the server names hash tables.

```
Syntax:	proxy_headers_hash_max_size 512;
Context: http, server, location
```
Sets the maximum size of hash tables used by the proxy_hide_header and proxy_set_header directives.

## Calculate

```
64KB * 512
```