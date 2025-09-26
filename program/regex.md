# Shell 正則表達式

> 這是[網頁](http://man.linuxde.net/docs/shell_regex.html)的資料備份，以免需要時無法訪問。

正則表達式的分類：
- 基本的正則表達式（Basic Regular Expression 又叫Basic RegEx 簡稱BREs）
- 擴展的正則表達式（Extended Regular Expression 又叫Extended RegEx 簡稱EREs）
- Perl的正則表達式（Perl Regular Expression 又叫Perl RegEx 簡稱PREs）

> [案例](#案例)

## 基本組成部分

正則表達式的基本組成部分。

| 正則表達式 | 描述 | 示例 | Basic RegEx | Extended RegEx | Python RegEx | Perl regEx |
| - | - | - | - | - | - | - |
| \ | 轉義符，將特殊字符進行轉義，忽略其特殊意義 | a\.b匹配ab，但不能匹配ajb，.被轉義為特殊意義 | \ | \ | \ | \ |
| ^ | 匹配行首，awk中，^則是匹配字符串的開始 | ^tux匹配以tux開頭的行 | ^ | ^ | ^ | ^ |
| $ | 匹配行尾，awk中，$則是匹配字符串的結尾 | tux$匹配以tux結尾的行 | $ | $ | $ | $ |
| . | 匹配除換行符\n之外的任意單個字符，awk則中可以 | ab.匹配abc或bad，不可匹配abcd或abde，只能匹配單字符 | . | . | . | . | 
| [] | 匹配包含在[字符]之中的任意一個字符 | coo[kl]可以匹配cook或cool | [] | [] | [] | [] |
| [^] | 匹配[^字符]之外的任意一個字符 | 123[^45]不可以匹配1234或1235，1236、1237都可以 | [^] | [^] | [^] | [^] |
| [-] | 匹配[]中指定範圍內的任意一個字符，要寫成遞增 | [0-9]可以匹配1、2或3等其中任意一個數字 | [-] | [-] | [-] | [-] |
| ? | 匹配之前的項1次或者0次 | colou?r可以匹配color或者colour，不能匹配colouur | 不支持 | ? | ? | ? |
| + | 匹配之前的項1次或者多次 | sa-6+匹配sa-6、sa-666，不能匹配sa- | 不支持 | + | + | + |
| * | 匹配之前的項0次或者多次 | co*l匹配cl、col、cool、coool等 | * | * | * | * |
| () | 匹配表達式，創建一個用於匹配的子串 | ma(tri)?匹配max或maxtrix | 不支持 | () | () | () |
| {n} | 匹配之前的項n次，n是可以為0的正整數 | [0-9]{3}匹配任意一個三位數，可以擴展為[0-9][0-9][0-9] | 不支持 | {n} | {n} | {n} | 
| {n,} | 之前的項至少需要匹配n次 | [0-9]{2,}匹配任意一個兩位數或更多位數 | 不支持 | {n,} | {n,} | {n,} |
| {n,m} | 指定之前的項至少匹配n次，最多匹配m次，n<=m | [0-9]{2,5}匹配從兩位數到五位數之間的任意一個數字 | 不支持 | {n,m} | {n,m} | {n,m} | 
| \| | 交替匹配\|兩邊的任意一項 | ab(c\|d)匹配abc或abd | 不支持 | \| | \| | \| |

## POSIX字符類

POSIX字符類是一個形如[:...:]的特殊元序列（meta sequence），他可以用於匹配特定的字符範圍。

| 正則表達式 | 描述 | 示例 | Basic RegEx | Extended RegEx | Python RegEx | Perl regEx |
| - | - | - | - | - | - | - |
| [:alnum:] | 匹配任意一個字母或數字字符 | [[:alnum:]] | +[:alnum:] | [:alnum:] | [:alnum:] | [:alnum:] |
| [:alpha:] | 匹配任意一個字母字符（包括大小寫字母） | [[:alpha:]]{4} | [:alpha:] | [:alpha:] | [:alpha:] | [:alpha:] |
| [:blank:] | 空格與製表符（橫向和縱向） | [[:blank:]]* | [:blank:] | [:blank:] | [:blank:] | [:blank:] |
| [:digit:] | 匹配任意一個數字字符 | [[:digit:]]? | [:digit:] | [:digit:] | [:digit:] | [:digit:] |
| [:lower:] | 匹配小寫字母 | [[:lower:]]{5,} | [:lower:] | [:lower:] | [:lower:] | [:lower:] |
| [:upper:] | 匹配大寫字母 | ([[:upper:]]+)? | [:upper:] | [:upper:] | [:upper:] | [:upper:] |
| [:punct:] | 匹配標點符號 | [[:punct:]] | [:punct:] | [:punct:] | [:punct:] | [:punct:] |
| [:space:] | 匹配一個包括換行符、回車等在內的所有空白符 | [[:space:]]+ | [:space:] | [:space:] | [:space:] | [:space:] |
| [:graph:] | 匹配任何一個可以看得見的且可以打印的字符 | [[:graph:]] | [:graph:] | [:graph:] | [:graph:] | [:graph:] |
| [:xdigit:] | 任何一個十六進制數（即：0-9，af，AF） | [[:xdigit:]]+ | [:xdigit:] | [:xdigit:] | [:xdigit:] | [:xdigit:] |
| [:cntrl:] | 任何一個控製字符（ASCII字符集中的前32個字符) | [[:cntrl:]] | [:cntrl:] | [:cntrl:] | [:cntrl:] | [:cntrl:] |
| [:print:] | 任何一個可以打印的字符 | [[:print:]] | [:print:] | [:print:] | [:print:] | [:print:] |


## 元字符

元字符（meta character）是一種Perl風格的正則表達式，只有一部分文本處理工具支持它，並不是所有的文本處理工具都支持。

| 正則表達式 | 描述 | 示例 | Basic RegEx | Extended RegEx | Python RegEx | Perl regEx |
| - | - | - | - | - | - | - |
| \b | 單詞邊界 | \bcool\b 匹配cool，不匹配coolant | \b | \b | \b | \b |
| \B | 非單詞邊界 | cool\B 匹配coolant，不匹配cool | \B | \B | \B | \B |
| \d | 單個數字字符 | b\db 匹配b2b，不匹配bcb | 不支持 | 不支持 | \d | \d |
| \D | 單個非數字字符 | b\Db 匹配bcb，不匹配b2b | 不支持 | 不支持 | \D | \D |
| \w | 單個單詞字符（字母、數字與_） | \w 匹配1或a，不匹配& | \w | \w | \w | \w |
| \W | 單個非單詞字符 | \W 匹配&，不匹配1或a | \W | \W | \W | \W |
| \n | 換行符 | \n 匹配一個新行 | 不支持 | 不支持 | \n | \n |
| \s | 單個空白字符 | x\sx 匹配xx，不匹配xx | 不支持 | 不支持 | \s | \s |
| \S | 單個非空白字符 | x\S\x 匹配xkx，不匹配xx | 不支持 | 不支持 | \S | \S |
| \r | 回車 | \r 匹配回車 | 不支持 | 不支持 | \r | \r |
| \t | 橫向製表符 | \t 匹配一個橫向製表符 | 不支持 | 不支持 | \t | \t |
| \v | 垂直製表符 | \v 匹配一個垂直製表符 | 不支持 | 不支持 | \v | \v |
| \f | 換頁符 | \f 匹配一個換頁符 | 不支持 | 不支持 | \f | \f |

## 案例

```
$ echo "a.b#c[d]e" | sed 's/[]#.[]/X/g'
```

> 這樣子才能匹配 `[` 和 `]` 這兩字符。假如 `[` 與 `]` 之間有其它字符，將會結束集合。
