# 可視化與查詢


## Aggregation
-  Metrics
    -  直接計算出結果 
    -  SQL sum()
-  Bucket
    -  創建一堆桶(可以看到每個桶有多少數量的文檔)，然後還可以再用 Sub-Aggregations 再聚合

[visualize 各功能](https://elkguide.elasticsearch.cn/kibana/v5/visualize/)
[官網](https://www.elastic.co/guide/en/kibana/6.3/createvis.html)

## Search
- Lucene [查詢語法](https://lucene.apache.org/core/2_9_4/queryparsersyntax.html)
- Elasticsearch [Query DSL](https://www.elastic.co/guide/en/elasticsearch/reference/6.2/query-filter-context.html) (JSON)
- Kuery (JSON)

## Lucene
### 全文搜索
直接寫搜索的單字
```shell
"400"
```

### 字段搜索
在搜索單字之前加上字段名和冒號

```shell=
field:"value"
nginx.access.response_code:404
```
從何處得知 field ? 如下圖：

![field](https://i.imgur.com/BxFyDck.png)

### 正規

| 符號 | 意義 |
| --- | --- |
| ? | 匹配 0 或 1 個字符 |
| * | 匹配 0 ~ n 個字符 |
| . | 用來表示任意字符 |
| + | 表示前面的字符重複一次或多次 |
| {n} | 表示重複 n 次 |
| {n,m} | 表示重複 n 到 m 次 |
| () | 表示 group, 組合其他使用|
| \| | 表示 or |
| \[\] | 中括號裡任一個 |


```shell
tags: b?codec_plain_applied
bcodec_plain_applied # match
bbcodec_plain_applied # match

tags: b*codec_plain_applied
bacodec_plain_applied # match
baasddawcodec_plain_applied # match

(http|https) 
http 或者 https 匹配
```
在 elasticsearch 中用這種方式搜索性能官方不建議

### 可選表達式
**Complement**
ab~cd 可以表示字符串以 ab 開始接著跟隨一個任意長度非 c 字符，以 d 結尾的字符串。
```shell=
"abcdef":

ab~df     # match
ab~cf     # match
ab~cdef   # no match
a~(cb)def # match
a~(bc)def # no match
```
**Interval**
選項允許使用數字範圍，用 <> 括起來
```shell=
"foo80":

foo<1-100>     # match
foo<01-100>    # match
foo<001-100>   # no match
```
**Intersection**
符號 & 用來連接兩個 patterns 兩個正則表達式都需要匹配
```shell=
"aaabbb":

aaa.+&.+bbb     # match
aaa&bbb         # no match
```
**Any string**
符號 @ 用來匹配所有，和 Intersection 聯合使用可以用來表示，匹配所有除了。
```shell=
@&~(foo.+)      # anything except string beginning with "foo"
```

### 近似搜索

"select where" ~5 隔著5個單詞，`select password from users where id=1`
```bash
"foo bar"~4
```

### 範圍搜索
- length:[100 TO 200]
- sip:["172.24.20.110" TO "172.24.20.140"]
- date:{"now-6h" TO "now"} 
- tag:{b TO e} 
    - 搜索 b 到 e 中間的字符 
- count:[10 TO *] 
    - \* 表示一端不限制範圍 
- count:[1 TO 5} [ ] 
    - 表示端點數值包含在範圍內，{ } 表示端點數值不包含在範圍內，可以混合使用，此語句為1到5，包括 1，不包括 5
    - count:(>=1 AND < 5)

### 多條件組合
必須大寫

- AND
- OR
- NOT
- \+
    - 搜索結果中必須包含此項 
- \- 
    - 不能含有此項
```shell=
user:("weily" OR "ethan") AND NOT message:pig
title:"foo bar" AND body:"quick fox"
(title:"foo bar" AND body:"quick fox") OR title:fox
title:foo -title:bar
```
### 提升權限
```shell=
(title:foo OR title:bar)^1.5 (body:foo OR body:bar)
```
須為正整數

### 轉義特殊字符
```shell=
+ - = && || > < ! ( ) { } [ ] ^ " ~ * ? : \ /
```

[regexp-syntax](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-regexp-query.html#regexp-syntax)
[kibana](https://logz.io/blog/kibana-tutorial/)
[Apache lucene](http://lucene.apache.org/core/3_5_0/queryparsersyntax.html)
## Query DSL
使用兩種結構化語句
- 結構化查詢（Query DSL）
- 結構化過濾（Filter DSL）

### 結構化查詢
判斷這個文檔是否匹配，同時它還需要判斷這個文檔匹配的有多準確。
- run 
    - 能匹配 runs 、 running 、 jog(跑步) 或者 sprint(短跑)
- 標籤越多，相關性越高
    -  lucene 、 search 或者 java 標籤越多，相關性越高
### 結構化過濾

這個查詢只是簡單的問一個問題："文檔是否匹配？"。回答也是非常的簡單，yes 或者 no ，二者其一。

- create
    - 2013 ? 2014 ?
- lat_lon
    - 位置在 500 公尺範圍內 ?
### Elasticsearch 查詢關鍵字
- match_all
- match
- multi_match
- range
- term
- terms
- exists

#### match_all
匹配所有文檔，默認模式
```bash
{ "match_all": {}}
```
#### match
字段上進行的是全文搜索還是精確查詢，match 查詢是可用標準查詢。
```bash
{ "match": { "tweet": "About Search" }}
```
```bash
GET filebeat-*/_search
{
  "query": {
     "match": { "nginx.access.response_code" : "200"}
  }
  
}
```
#### multi_match 
查詢可以在多個字段上執行相同的 match 查詢
```bash
GET filebeat-*/_search
{
  "query": {
    "multi_match": {
      "query": "(200 OR 400 OR 404) AND (GET)",
      "fields": ["nginx.access.response_code", "nginx.access.method"]
    }
  }
}
```

#### Range
查詢指定範圍內的資料
操作符號：
- gt 大於 
- gte 大於等於 
- lt  小於 
- lte 小於等於
```bash
GET filebeat-*/_search
{
  "query": {
    "range": {
      "nginx.access.user_agent.major": {
        "gte": 50,
        "lte": 70
      }
    }
  }
}
```
#### term
term 查詢被用於精確值"匹配"，有 時間、數字、布林
```bash
GET filebeat-*/_search
{
  "query": {
    "term": {
        "nginx.access.response_code": "499"
      }
  }
}
```
#### terms
terms 允許指定多值進行匹配。如果 `FILED` 包含了指定值中的任何一個值，那麼這個文檔滿足條件
```bash
GET filebeat-*/_search
{
  "query": {
    "terms": {
      "nginx.access.user_agent.major": [
        "67",
        "49"
      ]
    }
  }
}

```

#### bool
- must
    - 文檔必須匹配這些條件才可以被篩選出來。
- must_not
    - 文檔必須不匹配這些條件才可以被篩選出來。
- should
    - 如果滿足這些語句中的任意語句。否則，無任何影響。
- filter
    - 必須匹配，但它以過濾模式來進行。根據過濾標準來排除或包含文檔。
```bash
GET filebeat-*/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "FIELD": "TEXT"
          }
        }
      ]
      , "must_not": [
        {
          "match": {
            "FIELD": "TEXT"
          }
        }
      ]
      , "should": [
        {
          "match": {
            "FIELD": "TEXT"
          }
          , "range": {
            "FIELD": {
              "gte": 10,
              "lte": 20
            }
          }
        }
      ]
      , "filter": {
        "range": {
          "FIELD": {
            "gte": 10,
            "lte": 20
          }
        }
      }
    }
  }
}

```
### 驗證查詢
```bash
index_/_validate/query?[method]
```
#### \_validate
在不執行查詢的前提下，先驗證下這個查詢語句是否合法
```bash
GET filebeat-*/_validate/query?q=tags:!@#%^^&
{
  "valid": false,
  "_shards": {
    "total": 46,
    "successful": 46,
    "failed": 0
  }
}
```

#### explain
合法的查詢語句中，explain 可以解釋這個查詢是如何操作的
```bash
GET filebeat-*/_validate/query?q=tags:!&explain=true
{
  "valid": false,
  "_shards": {
    "total": 46,
    "successful": 46,
    "failed": 0
  },
  "explanations": [
    {
      "index": "filebeat-6.2.4-2018.06.25",
      "valid": false,
      "error": """
[filebeat-6.2.4-2018.06.25/jjHAnPjwQkqSxzt0JXN9xg] QueryShardException[Failed to parse query [tags:!]]; nested: ParseException[Cannot parse 'tags:!': Encountered " <NOT> "! "" at line 1, column 5.
Was expecting one of:
    <BAREOPER> ...
    "(" ...
    "*" ...
    <QUOTED> ...
    <TERM> ...
    <PREFIXTERM> ...
    <WILDTERM> ...
    <REGEXPTERM> ...
    "[" ...
    "{" ...
```

```bash
GET filebeat-*/_validate/query?q=tags:nginx&explain=true
{
  "valid": true,
  "_shards": {
    "total": 46,
    "successful": 46,
    "failed": 0
  },
  "explanations": [
    {
      "index": "filebeat-6.2.4-2018.06.25",
      "valid": true,
      "explanation": "tags:nginx"
    },
    {
      "index": "filebeat-6.2.4-2018.06.26",
      "valid": true,
      "explanation": "tags:nginx"
    },
    {
      "index": "filebeat-6.2.4-2018.06.27",
      "valid": true,
      "explanation": "tags:nginx"
    },
    ...
```
```bash
GET filebeat-*/_validate/query?explain=true
{
  "query": {
    "match": {
      "nginx.access.response_code" : "200"
    }
  }
}
{
  "valid": true,
  "_shards": {
    "total": 46,
    "successful": 46,
    "failed": 0
  },
  "explanations": [
    {
      "index": "filebeat-6.2.4-2018.06.25",
      "valid": true,
      "explanation": "nginx.access.response_code:200"
    },
...
```
假設沒此 filed 會出現 `unmapped field [nginx.access.response_code]` 提示

#### rewrite

較清楚的顯示查詢
```bash
GET filebeat-*/_validate/query?rewrite=true
{
  "query": {
    "range": {
      "nginx.access.user_agent.major": {
        "gte": 50,
        "lte": 70
      }
    }
  }
}
{
  "valid": true,
  "_shards": {
    "total": 46,
    "successful": 46,
    "failed": 0
  },
  "explanations": [
    {
      "index": "filebeat-6.2.4-2018.06.25",
      "valid": true,
      "explanation": "nginx.access.user_agent.major:[50 TO 70]"
    },
    ...
    
```
## 分頁
SQL limit
```bash
GET filebeat-*/_search
{
  "query": {
    "term": {
        "nginx.access.response_code": "200"
      }
  },
  "from": 0,
  "size": 2
}

```
[進階](https://blog.csdn.net/weixin_39800144/article/details/80499112)
## 刪除 index
```shell=
 curl -X DELETE "localhost:9200/_all"
```
```shell=
action.destructive_requires_name = true
```
[CRUD](https://ithelp.ithome.com.tw/articles/10187219)
[DSL](https://logz.io/blog/elasticsearch-queries/)



