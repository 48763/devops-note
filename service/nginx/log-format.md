# log-format
Specifies log format.

## Config
```nginx

    log_format combined 'arg_name $arg_name '
        ', args $args '
        ', binary_remote_addr $binary_remote_addr '
        ', body_bytes_sent $body_bytes_sent '
        ', bytes_sent $bytes_sent '
        ', connection $connection '
        ', connection_requests $connection_requests '
        ', content_length $content_length '
        ', content_type $content_type '
        ', cookie_name $cookie_name '
        ', document_root $document_root '
        ', document_uri $document_uri '
        ', uri $uri '
        ', host $host '
        ', hostname $hostname '
        ', http_name $http_name '
        ', https $https '
        ', is_args $is_args '
        ', limit_rate $limit_rate '
        ', msec $msec '
        ', nginx_version $nginx_version '
        ', pid $pid '
        ', pipe $pipe '
        ', proxy_protocol_addr $proxy_protocol_addr '
        ', proxy_protocol_port $proxy_protocol_port '
        ', query_string $query_string '
        ', args $args '
        ', realpath_root $realpath_root '
        ', remote_addr $remote_addr '
        ', remote_port $remote_port '
        ', remote_user $remote_user '
        ', request $request '
        ', request_body $request_body '
        ', request_body_file $request_body_file '
        ', request_completion $request_completion '
        ', request_filename $request_filename '
        ', request_length $request_length '
        ', request_method $request_method '
        ', request_time $request_time '
        ', request_uri $request_uri '
        ', scheme $scheme '
        ', sent_http_name $sent_http_name '
        ', server_addr $server_addr '
        ', server_name $server_name '
        ', server_port $server_port '
        ', server_protocol $server_protocol '
        ', status $status '
        ', tcpinfo_rtt $tcpinfo_rtt '
        ', tcpinfo_rttvar $tcpinfo_rttvar '
        ', tcpinfo_snd_cwnd $tcpinfo_snd_cwnd '
        ', tcpinfo_rcv_space $tcpinfo_rcv_space '
        ', time_iso8601 $time_iso8601 '
        ', time_local $time_local ';

    access_log /var/log/nginx/host.log combined;

```

## Embedded variables

### arg_name

argument name in the request line
```log
 - 
```

### args

arguments in the request line
```log
 - 
```

### binary_remote_addr

client address in a binary form, value’s length is always 4 bytes for IPv4 addresses or 16 bytes for IPv6 addresses
```log
 \xC0\xA8d\xFD 
```

### body_bytes_sent

number of bytes sent to a client, not counting the response header; this variable is compatible with the "%B" parameter of the mod_log_config Apache module
```log
396 
```

### bytes_sent

number of bytes sent to a client (1.3.8, 1.2.5)
```log
629 
```

### connection

connection serial number (1.3.8, 1.2.5)
```log
1 
```

### connection_requests

current number of requests made through a connection (1.3.8, 1.2.5)
```log
1 
```

### content_length

Length of the content sent by the client. The number of bytes in the HTTP body, not including the header. This is not a measurement of the request total size.

"Content-Length" request header field
```log
- 
```

### content_type

Data type of the content sent by the client in the HTTP message body. Used with queries that have attached information such as POST and PUT. The mime type of the body of the request.

"Content-Type" request header field
```log
- 
```

### cookie_name

the name cookie
```log
- 
```

### document_root

root or alias directive’s value for the current request
```log
/usr/share/nginx/html 
```

### document_uri

same as $uri
```log
/index.html 
```

### uri

current URI in request, normalized

The value of $uri may change during request processing, e.g. when doing internal redirects, or when using index files.
```log
/index.html 
```

### host

in this order of precedence: host name from the request line, or host name from the "Host" request header field, or the server name matching a request
```log
192.168.200.130 
```

### hostname

host name
```log
lab 
```

### http_name

arbitrary request header field; the last part of a variable name is the field name converted to lower case with dashes replaced by underscores
```log
- 
```

### https

ON if the request came in through a secure channel (for example, SSL), OFF if the request came through an insecure channel.

"on" if connection operates in SSL mode, or an empty string otherwise
```log

```

### is_args

"?" if a request line has arguments, or an empty string otherwise
```log

```

### limit_rate

setting this variable enables response rate limiting; see limit_rate
```log
0 
```

### msec

current time in seconds with the milliseconds resolution (1.3.9, 1.2.6)
```log
1545729574.658 
```

### nginx_version

nginx version
```log
1.4.6 
```

### pid

PID of the worker process
```log
13090 
```

### pipe

"p" if request was pipelined, "." otherwise (1.3.12, 1.2.7)
```log
. 
```

### query_string

Query information stored in the string following the question mark (?) in the HTTP request.

same as $args
```lo
- 

customerId=12345&show=details&vertook=34957349521
```

### args
```log
- 
```

### realpath_root

an absolute pathname corresponding to the root or alias directive’s value for the current request, with all symbolic links resolved to real paths
```log
/usr/share/nginx/html 
```

### remote_addr

The IP address (shown to the internet) of the remote host that is making the request to the web server.

client address
```log
192.168.100.253 
```

### remote_port

The client port number of the TCP connection.

client port
```log
50143 
```

### remote_user

The name of the user as it is derived from the authorization header sent by the client, before the user name is mapped to a Windows account. This variable is no different from AUTH_USER. If you have an authentication filter installed on your Web server that maps incoming users to accounts, use LOGON_USER to view the mapped user name.

user name supplied with the Basic authentication
```log
- 
```

### request

full original request line
```log
GET / HTTP/1.1 
```

### request_body

request body

The variable’s value is made available in locations processed by the proxy_pass, fastcgi_pass, uwsgi_pass, and scgi_pass directives when the request body was read to a memory buffer.
```log
- 
```

### request_body_file

name of a temporary file with the request body

At the end of processing, the file needs to be removed. To always write the request body to a file, client_body_in_file_only needs to be enabled. When the name of a temporary file is passed in a proxied request or in a request to a FastCGI/uwsgi/SCGI server, passing the request body should be disabled by the proxy_pass_request_body off, fastcgi_pass_request_body off, uwsgi_pass_request_body off, or scgi_pass_request_body off directives, respectively.
```log
- 
```

### request_completion

"OK" if a request has completed, or an empty string otherwise
```log
OK 
```

### request_filename

file path for the current request, based on the root or alias directives, and the request URI
```log
/usr/share/nginx/html/index.html 
```

### request_length

request length (including request line, header, and request body) (1.3.12, 1.2.7)
```log
430 
```

### request_method

The method used to make the request (GET, POST etc).

request method, usually "GET" or "POST"
```log
GET 

GET, HEAD, POST, PUT, DELETE, TRACE, OPTIONS, CONNECT or PATCH (for HTTP requests)
```

### request_time

request processing time in seconds with a milliseconds resolution (1.3.9, 1.2.6); time elapsed since the first bytes were read from the client
```log
0.000 
```

### request_uri

full original request URI (with arguments)
```log
/ 
```

### scheme

request scheme, "http" or "https"
```log
http 
```

### sent_http_name

arbitrary response header field; the last part of a variable name is the field name converted to lower case with dashes replaced by underscores
```log
- 
```

### server_addr

an address of the server which accepted a request

Computing a value of this variable usually requires one system call. To avoid a system call, the listen directives must specify addresses and use the bind parameter.
```log
192.168.200.130 
```

### server_name

Host name, DNS alias or IP address of the web server. This is not necesarily the computer name of the web server and it has nothing to do with the address that the request used. It is the configured name of the website.

name of the server which accepted a request
```log
localhost 

www.website.com or localhost or 192.168.0.45
```

### server_port

The server port number to which the request was sent.

port of the server which accepted a request
```log
80 
```

### server_protocol

The name and revision of the request information protocol. The format is protocol/revision. (The canonicalized form of HTTP_VERSION.)

request protocol, usually "HTTP/1.0", "HTTP/1.1", or "HTTP/2.0"
```log
HTTP/1.1 
```

### status

response status (1.3.2, 1.2.2)
```log
200 
```

### tcpinfo_rtt

information about the client TCP connection; available on systems that support the TCP_INFO socket option
```log
2299 
```

### tcpinfo_rttvar

information about the client TCP connection; available on systems that support the TCP_INFO socket option
```log
1149 
```

### tcpinfo_snd_cwnd

information about the client TCP connection; available on systems that support the TCP_INFO socket option
```log
10 
```

### tcpinfo_rcv_space

information about the client TCP connection; available on systems that support the TCP_INFO socket option
```log
28960 
```

### time_iso8601

local time in the ISO 8601 standard format (1.3.12, 1.2.7)
```log
2018-12-25T17:19:34+08:00 
```

### time_local

local time in the Common Log Format (1.3.12, 1.2.7)
```log
25/Dec/2018:17:19:34 +0800 
```

### http_referer

Returns a string that contains the URL of the page that referred the request to the current page using an HTML `<A>` tag. Note that the URL is the one that the user typed into the browser address bar, which may not include the name of a default document. If the page is redirected, HTTP_REFERER is empty. HTTP_REFERER is not a mandatory member of the HTTP specification.
```log
-
```

### http_user_agent

Returns a string describing the browser, and it's features, that sent the request.
```log
Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.110 Safari/537.36
```


### http_x_forwarded_for

the "X-Forwarded-For" client request header field with the $remote_addr variable appended to it, separated by a comma. If the "X-Forwarded-For" field is not present in the client request header, the $proxy_add_x_forwarded_for variable is equal to the $remote_addr variable.
```log
-
```

### upstream_response_time

keeps time spent on receiving the response from the upstream server; the time is kept in seconds with millisecond resolution. Times of several responses are separated by commas and colons like addresses in the $upstream_addr variable.
```log
0.055
```

http://nginx.org/en/docs/http/ngx_http_upstream_module.html#variables