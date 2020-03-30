# thread 製作基礎的排票系統
Published by Yuki on 2015/11/01

最近因為在用專題的東西，所以一直都在撰寫 java，想說把手邊程式都打包起來，做成自己的工具包，以後想要使用就方便許多，只要拉出來改一改就可以以用

```java
package thread;
/* 
*創建 NumberIssue 物件
*使用建構方法傳入 iniNumber NumberIssue
*
*再創建 Thread_Passanger
*使用建構方法，將 NumberIssue 建構值傳入
*
*使用 Thread_Passanger 的 start() 
*開始執行，CPU分配資源
*使用 join() 讓物件開始參與排班
*
*當有一 Thread 要使用 iniNumber 
*synchronized 會凍結變數，直到 thread 執行、更動完畢
*其它的 Thread 才能在進入變更 
*
*Thread 執行完畢後
*輸出各 Thread_Passanger 物件的值
*/
public class Thread_Passanger extends Thread {
    int number;
    NumberIssue NI;

    public Thread_Passanger(NumberIssue NI) {
        this.NI = NI;
    }

    public void run() {
        number = NI.getNumber();
    }
}

class NumberIssue {
    int iniNumber, NumberIssue;
    public NumberIssue(int iniNumber, int NumberIssue) {
        this.iniNumber = iniNumber;
        this.NumberIssue = NumberIssue;
    }
    public synchronized int getNumber() {
        int num = iniNumber;

        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
        };
        
        iniNumber = iniNumber + NumberIssue;

        return (num);
    }
}
```

測試程式
```java
package thread;
import thread.Thread_Passanger;

public class test_thread {
    public static void main(String args[]) {

    NumberIssue NI = new NumberIssue(1, 2);
    Thread_Passanger p1, p2, p3, p4;

    p1 = new Thread_Passanger(NI);
    p1.start();
    p2 = new Thread_Passanger(NI);
    p2.start();
    p3 = new Thread_Passanger(NI);
    p3.start();
    p4 = new Thread_Passanger(NI);
    p4.start();
    
    try {
        p1.join();
        p2.join();
        p3.join();
        p4.join();
    } catch (InterruptedException e) {
    };
    
    System.out.println("Passanger 1: Number: " + p1.number);
    System.out.println("Passanger 2: Number: " + p2.number);
    System.out.println("Passanger 3: Number: " + p3.number);
    System.out.println("Passanger 4: Number: " + p4.number);
    }
}
```

最後感謝 ～老師教導～
～以及學長陪伴爆肝留實驗室～(*/ω＼*)