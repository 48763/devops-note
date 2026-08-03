## Task 1



## Task 2 

### 1

Which of the following will output "Hello world!" to the standard output?

- a. ```cat "Hello world!"  ```
- b. ```echo "Hello world!" ```
- c. ```ls "Hello world!"   ```
- d. ```cp "Hello world!"   ```

### 2

Which of the following could be the entire body of a bash script that accepts two file names as its arguments and copies the contents of the first file into the second file?

- a. ```cp $#       ```
- b. ```cp $@       ```
- c. ```cp $@1 $@2  ```
- d. ```cp @1 @2    ```

### 3

Which of the following should be put instead of "...", so that the following script works as intended?

```bash
#!/bin/bash
read a
read b
if ...
then
    echo "a is greater than b"
fi
```

- a. ```[ $a -gt $b ]   ```
- b. ```($a > $b)       ```
- c. ```[$b -$a > 0]    ```
- d. ```[ -gt $a $b]    ```

### 4

Which of the following will remove the file "my1file.txt", but will leave the file "myimportantfile.txt"?

- a. ```rm my*file.txt              ```
- b. ```rm *\my_important_file.txt  ```
- c. ```rm my.file.*                ```
- d. ```rm my?file*                 ```

### 5

Which of the following shoild be put instead of "...", so that the following script runs all python files in the current directory and all of its nested subdirectories?

```bash
#!/bin/bash

for ...
do 
    python $1
done
```

- a. ```$i in `find . | grep .py$`  ```
- b. ```i in `find . | grep .py$`   ```
- c. ```i in [find . | grep .py$]   ```
- d. ```$i in [find . | grep .py$]  ```

### 6

Which of the following commands will help find you all the files in current directory, its subdirectory, their subdirectories (and so on...), that contain string "hide_and_seek"?

- a. ```find . | grep "hide_and_seek"                       ```
- b. ```grep -R "hide_and_seek" .                           ```
- c. ```cat -R --include-file-names | grep "hide_and_seek"  ```
- d. ```find . "hide_and_seek"                              ```

### 7

Which of the following will output "files are different" if (and only if) file1.txt and file2.txt are different?

- a. ```diff file1.txt file2.txt > /dev/null 2>&1 && echo "files are the same." ```
- b. ```diff file1.txt file2.txt > /dev/null 2>&1 & echo "files are the same."  ```
- c. ```diff file1.txt file2.txt > /dev/null 2>&1 || echo "files are the same." ```
- d. ```diff file1.txt file2.txt > /dev/null 2>&1 | echo "files are the same."  ```

### 8

You would like to have a convenient  alias *rm_latest* that removes the latest file in current directory. How should you define it?

- a. ```alias rm_latest="rm \"`ls -t | head -1`\" "         ```
- b. ```alias rm_latest="rm \"\`ls -t | head -1\`\" "       ```
- c. ```alias rm_latest="rm \"$PWD/`ls -t | head -1`\" "    ```
- d. ```alias rm_latest="rm \"$PWD/\`ls -t | head -1\`\" "  ```

### 9

When trying to execute the poweroff command you encountered problem displayed in the box to the right. How could you try to deal with this problem?

```bash
user@ubuntu:~$ poweroff 
Failed to set wall message, ignoring: Interactive authentication required.
Failed to power off system via logind: Interactive authentication required.
Failed to start poweroff.target: Interactive authentication required.
See system logs and 'systemctl status poweroff.target' for details.
Failed to open /dev/initctl: Permission denied
Failed to talk to init daemon.
```

- ```a. force ! ```
- ```b. force !!```
- ```c. sudo !  ```
- ```d. sudo !! ```

### 10

Which of the following commands will check how many words are there in the first 10 lines of the file "file.txt"?

- a. ```wc -w | top -n 10 file.txt  ```
- b. ```wc -w | head -n 10 file.txt ```
- c. ```top -n 10 file.txt | wc -w  ```
- d. ```head -n 10 file.txt | wc -w ```

## Task 3

### 1

Which shell command would you use if you wanted to display each command before they are actually executed?

- a. echo $?
- b. set -v
- c. sh -c 
- d. tail

### 2

You wnat to stop the local machine from replying to ping requests from outside, but still be able to ping other. Which iptables command should be used?

- a. iptables -I INPUT -p icmp -j DROP
- b. iptables -I OUTPUT -p icmp -j DROP
- c. iptables -F INPUT -p icmp --icmp-type 8 -j DROP
- d. iptables -A OUTPUT -p icmp --icmp-type 8 -j DROP
- e. iptables -A INPUT -p icmp --icmp-type 0 -j DROP
- f. iptables -A OUTPUT -p icmp --icmp-type 0 -j DROP

### 3

Which command would be the best pick to monitor disk writes/reads?

- a. top
- b. iotop
- c. htop
- d. iftop

### 4

You have a new Software Engineer Jhon Doe in your company. As a system administrator, you would like to grant access to your testing server for his developer. The developer has sent you thier builc RSA key. Where should this key be put, to grant remote access using pubilc key authentication method?

- a. ~jdoe/.ssh/config
- b. ~jdoe/.ssh/id_rsa
- c. ~jdoe/.ssh/id_rsa.pub
- d. ~jdoe/.ssh/authorized_keys
- e. ~jdoe/.ssh/known_keys

### 5

Running the attached traffic monitoring command on host A shows the following line of output. What does it mean?

> Command: tcpdump -tnni <interface_name>  
> Host A IP address: 172.17.0.1  
> Output:  
> IP 172.17.0.1.41027 > 172.17.0.4.53: 8784+ [1au] A? www.google.com. (43...)

- a. host A sent a name resolution query, asking about www.google.com
- b. host A is trying to access www.google.com via http
- c. host A is trying to ping www.google.com
- d. host A is trying to access www.google.com via https

### 6

You webserver is under a much heavier load usual and you suspect a malicious single client or a small group of client being the cause. Assuming daiily log rotation and webserver logs stored in /var/log/http/access.log using Common Log Format(see attached exemple). Which command would help you identify the top client IP addresses that have made the largest number of HTTP requests today?

> Sample log line:  
> 192.168.1.1 - www [11/Jan/21012:11:22:34 - 0700] "GRT /favico.ico HTTP/1...

- a. cat /var/log/http/access.log | grep www | wc -l | sort
- b. awk '{print $1}' /var/log/http/access.log | sort | uniq -c | sort -rn | head
- c. cut -d ' ' -f 1 /var/log/http/access.log | uniq -c | sort -n | tail

### 7

Which of these files stores user passwords on modern Linux?

- a. /etc/profile
- b. /etc/passwd
- c. /etc/passwords
- d. /etc/shadow

### 8

Assuming default sshd configuration, after running the attached command, you get the output shown below. Does this mean that your local machine is ready to accept incoming ssh connections?

> Command: netstat -atp | egrep "PID|ssh"  
> Output:  
```bash
 Proto REC-Q Send-Q Local Address       Foreign Address     State       PID/Program name
 tcp   1     0      172.17.0.4:55006    172.17.0.1:22       ESTABLISHED 2114/ssh
```

- a. Yes
- b. No
- c. Cannot say based on the command that was run

### 9

You need to create a large dummy file for testing cleanup script you wrote. Which of these command would be a best solution for the task?

- a. dd if=/dev/null of=large_file bs=1024 count=10000000
- b. truncate -s 10000000 large_file
- c. touch -d 10000000 large_file
- d. cat /dev/null | wc -c 10000000 > large_file

### 10

You want to ping 2 hosts and save the ping results in a file. Which set of commands would be best to do the job?

> File name: file1  
> host A IP address: 10.0.0.1  
> host B IP address: 10.0.0.2

- a. for i in 1 2; do ping 10.0.0.$i -c 1 > file1; done
- b. for i in 1,2; do ping 10.0.0.$i -c 1 > file1; done
- c. for i in 1 2; do ping 10.0.0.$i -c 1 >> file1; done
- d. for i in [ 1-2 ]; do ping 10.0.0.${i} -c 1 >> file1; done
- e. for i in 1 2; do ping 10.0.0.$i -c 1 << file1; done