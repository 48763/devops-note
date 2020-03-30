# 基本元件認知(資料型態、scanf)
Published by Yuki on 2014/11/22

## 資料型態

### 資料大小認知

1bit = (0,1) 這也是俗稱的二進制
1byte = 8bit
1word = 2byte or 4byte

### 資料型態

```c
char　　//1byte　　
int 　//4byte　　
short int　　//2byte　　
unsigned shar //1byte　　
unsigned int 　//4byte　　
unsigned short int 　//2byte　　
unsigned long int　　//4byte　　
float　　//4byte　　
double　　//8byte　　
long double　　//8byte　　
```

### 資料範圍

資料範圍的部分，就是屬於數位邏輯了！
- 1bit 有 0 和 1 ，也就是兩種可能，十進制範圍是 0 ~ 1
- 2bit有 00 , 01 , 10 , 11 四種可能，十進制範圍是 0 ~ 3
- 8bit 一共有 256 種可能，十進制範圍是 0 ~ 255
到這裡，大多的人都會亂掉！
因為在一般數學上的數字，代表著數量，而 0 是沒有的意思。
但是在數位邏輯，任何一個數，都代表著一種可能，而 0 也是其中一種可能！ 

(2) 認識 unsigned

- sign bit ：正負控制符號
- unsigned 就是不要有正負控制符號

所以從原本的正負範圍，變成只有正數
但資料大小個數是不變的！
也就是說正數的地方變得更寬！

```c
short int = -32768 ~ 32767
unsigned short int = 0 ~ 65535
```

### scanf()函式

scanf() 是標準輸入函式
用法：

```c
scanf(“%(轉換格式)”,&(變數));
```

所使用的東西，與 printf() 相同

```c
//只打程式主要部分
int i;
char str[5] = input;
scnaf("%d %3s", &num, &str);
printf("輸出結果：%s", str);　　//我只選擇我要的輸出而已!
```

#### 注意事項

&是一定要加的東西
算是 scnaf() 在接收東西時，需要判斷誰來”接”資料

另外在scanf()裡，沒辦法在 `" "` 裡面中，輸入字串表示
因為這是一個標準輸入函式，而不是輸出函式！！

#### 資料長度

這和printf有點類似
差別就在一個是只輸出所指定的長度
而另一個是只接收所指定的長度！！

以上面的例子,再輸入字串時，輸入test1的話
```
輸出結果：tes
```

而多餘 字是不會被 scanf() 給接收！