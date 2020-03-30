# 程式架構＆基本元件認知(printf)
Published by Yuki on 2014/11/20

## 程式架構

```c
#include<stdio.h>　　//標頭檔；前端處理程式指令
#include<stdlib.h>
#define MAX 10
int square(int)　　//函式原型宣告
int main()　　//主程式
{
　...　　//程式敘述
　　　}
int square(int num)　　//函式
{
　...　　//函式敘述
　　　}
```

標頭檔依照撰寫人，來判斷程式需要那些功能，進而進行增減的動作！

而底下的只是舉幾個標頭檔當做例子！

```c
#include <iostream.h>　　//數據流輸出/入
#include <math.h>　　//定義數學函示
#include <stdio.h>　　//定義輸入/輸出函式
#include <stdlib.h>　　//定義雜項函數及內存分配函數
#include <string.h>　　//字符串處理
```
## 基本元件

小的是把程式，當作是積木的完成品。
構成完成品的是小積木，而小積木就是基本元件。
基本元件包含了：函式、資料型態、判斷式…等。
只是每一塊積木有大有小，有長有短，並不是隨便都可以組合起來的！！

### printf()函式

用法：

```c
printf("[String|%flags][width][precision][轉換格式]",[變數|算式|數值]);
```

- flags　旗標
- width　長度(整數+小數)
- precision　精準度(小數點取幾位)

範例：

```c
#include<stdio.h>　　
#include<stdlib.h>
main() {
    int num1 = 10;　　//int...等資料型態，之後介紹
    int num2 = 20;
    printf("num1的數值為：%d，num2的數值為：%d",num1,num2);
    //使用printf()螢幕會列出==>>num的數值為：10，num2的數值為：20
    system("PAUSE");
    return 0;
}
```

### 轉換格式

可以把轉換格式，當作是用來接數值用的！！

```c
%d　　==>整數，有正負　　//int
%hd　　==>短整數　　　　//short int
%ld　　==>長整數　　//long int
%lu　　==>無負數長整數　　//unsigend long short
%c　　==>單一字元　　//char
%e　　==>科學記號表示 e　//例：14 = 1.400000e+1
%E　　==>科學記號表示 E　
%f　　==>小數點形式　　//float,double
%lf　　==>強制轉double資料型態
%o　　==>無正負八進位數值
%u　　==>無正負號十進位數值　　
%x　　==>十六進制數值(小寫表示)
```

### 旗標

```c
+　　==>強加正負號
-　　==>靠左對齊
　　==>空白，在整數前加空白
#　　==>強加相關符號
```

### 長度及精準度

```c
//只打程式主要部分
double num = 123.456
printf("%2f",num);　　//輸出為123
printf("%10.2f",num);　　//輸出為00000123.45
//整數不足會補位數，而小數點則遮蔽，多的則補0
```