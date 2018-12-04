# Linux新手必知必会的一些命令

## 常用系统工作命令

### echo

echo命令用于在终端输出字符串或变量提取后的值，格式为“echo [字符串 | $变量]”。  

```shell
[root@localhost ~]# echo "hello eagle"
hello eagle
[root@localhost ~]# echo hello eagle
hello eagle
输出环境变量SHELL的值
[root@localhost ~]# echo $SHELL
/bin/bash
[root@localhost ~]# i=10
输出自定义变量i的值
[root@localhost ~]# echo $i
10
```

### date

date命令用户显示和设置系统日期或者格式  

```shell
[root@localhost ~]# date
2018年 12月 04日 星期二 09:46:39 CST
按照“年-月-日 小时:分钟:秒”的格式查看当前系统时间的date命令：
[root@localhost ~]# date "+%Y-%m-%d %H:%M:%S"
将系统的当前时间设置为1996年10月1日1点1分的date命令：
[root@localhost ~]# date -s "19961001 1:01:00"
2018-12-04 09:48:46
```

将时间同步回来  

```shell
# yum install ntp
# ntpdate ntp.api.bz
```

### wget

wget命令用于在终端中下载网络文件，格式为“wget [参数] 下载地址”。  

参数 | 作用
--|--
-b | 后台下载模式
-P | 下载到指定的目录
-t | 最大尝试次数
-c | 断点续传
-p | 下载页面内所有资源，包括图片、视频等
-r | 递归下载
-O | 另存为  

```shell
将文件下载到当前目录下  
[root@localhost ~]# wget https://dldir1.qq.com/qqfile/qq/QQ9.0.8/24199/QQ9.0.8.24199.exe  
将文件下载到指定目录并且指定文件名  
例如将QQ下载到/tmp目录下并且重命名为QQ.exe  
[root@localhost ~]# wget   https://dldir1.qq.com/qqfile/qq/QQ9.0.8/24199/QQ9.0.8.24199.exe -O /tmp/QQ.exe  
```

### ps

ps命令用于查看系统中的进程状态，格式为“ps [参数]”。

参数|作用
-|-
-a|显示所有进程
-u|用户以及其他详细信息
-x|显示没有控制终端的进程

常用ps命令组合：

```shell
[root@localhost ~]# ps –aux
[root@localhost ~]# ps –ef
```

PS： 在Linux系统中，有5种常见的进程状态，分别为运行(R)、中断(S)、不可中断(D)、僵死(Z)与停止(T)

### top

top命令用于动态地监视进程活动与系统负载等信息，其格式为top。能够动态地查看系统运维状态，完全将它看作Linux中的“强化版的Windows任务管理器”。  

第1行：系统时间、运行时间、登录终端数、系统负载（三个数值分别为1分钟、5分钟、15分钟内的平均值，数值越小意味着负载越低）。  
第2行：进程总数、运行中的进程数、睡眠中的进程数、停止的进程数、僵死的进程数。  
第3行：用户占用资源百分比、系统内核占用资源百分比、改变过优先级的进程资源百分比、空闲的资源百分比等。  
第4行：物理内存总量、内存使用量、内存空闲量、作为内核缓存的内存量。  
第5行：虚拟内存总量、虚拟内存使用量、虚拟内存空闲量、已被提前加载的内存量。  

### pidof

pidof命令用于查询某个指定服务进程的PID值，格式为“pidof [参数] [服务名称]”。  

每个进程的进程号码值（PID）是唯一的，因此可以通过PID来区分不同的进程。例如，可以使用如下命令来查询本机上sshd服务程序的PID：  

```shell
[root@localhost ~]# pidof sshd
12170 12169
```

### kill
kill命令用于终止某个指定PID的服务进程，格式为“kill [参数] [进程PID]”。  

接下来，我们使用kill命令把上面用pidof命令查询到的PID所代表的进程终止掉，其命令如下所示。这种操作的效果等同于强制停止sshd服务。  

```shell
杀死一个进程
[root@localhost ~]# kill [pid]
[root@localhost ~]# kill 12170
杀死一个进程树
[root@localhost ~]# kill -9 [pid]
```

### killall

killall命令用于终止某个指定名称的服务所对应的全部进程，格式为：“killall [参数] [服务名称]”。  

通常来讲，复杂软件的服务程序会有多个进程协同为用户提供服务，如果逐个去结束这些进程会比较麻烦，此时可以使用killall命令来批量结束某个服务程序带有的全部进程。  

```shell
最小化安装的centos中默认没有这个组件，要手动安装
[root@localhost ~]# yum install psmisc
杀死sshd
[root@localhost ~]# killall sshd
```

## 系统状态检测命令

### ifconfig

ifconfig命令用于获取网卡配置与网络状态等信息，格式为“ifconfig [网络设备] [参数]”。  

```shell
不加任何参数默认输出所有网卡的状态信息  
查看指定网卡信息，将网卡设备名作用参书写在后面
[root@localhost ~]# ifconfig ens33
ifconfig命令还可以用来临时修改网卡的ip地址
[root@localhost ~]# ifconfig ens33 192.168.225.101 netmask 255.255.255.0
```

### uname

uname命令用于查看系统内核与系统版本等信息，格式为“uname [-a]”。  

```shell
[root@localhost ~]# uname -a
Linux localhost.localdomain 3.10.0-693.el7.x86_64 #1 SMP Tue Aug 22 21:09:27 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
```

### free

free用于显示当前系统中内存的使用量信息，格式为“free [-h]”。  

```shell
[root@localhost ~]# free -h
              total        used        free      shared  buff/cache   available
Mem:           1.8G        118M        1.1G        8.7M        611M        1.5G
Swap:          1.0G          0B        1.0G
```

### who

who用于查看当前登入主机的用户终端信息，格式为“who [参数]”。  

```shell
[root@localhost ~]# who
root     tty1         2018-12-04 09:15
root     pts/1        2018-12-04 10:58 (192.168.225.1)
[root@localhost ~]#  
```

### last

last命令用于查看所有系统的登录记录，格式为“last [参数]”。  

```shell
[root@localhost ~]# last
root     pts/1        192.168.225.1    Tue Dec  4 10:58   still logged in   
root     pts/0        192.168.225.1    Tue Dec  4 10:36 - 11:01  (00:25)    
root     pts/0        192.168.225.1    Tue Dec  4 10:35 - 10:36  (00:00)    
root     pts/0        192.168.225.1    Tue Dec  4 10:35 - 10:35  (00:00)    
root     pts/0        192.168.225.1    Tue Dec  4 10:33 - 10:35  (00:02)    
root     pts/0        192.168.225.1    Tue Dec  4 10:30 - 10:33  (00:02)    
root     pts/0        192.168.225.1    Tue Dec  4 10:30 - 10:30  (00:00)    
root     pts/2        192.168.225.1    Tue Dec  4 10:29 - 10:33  (00:03)    
root     pts/1        192.168.225.1    Tue Dec  4 10:29 - 10:33  (00:03)    
root     pts/2        192.168.225.1    Tue Dec  4 10:28 - 10:29  (00:01)    
root     pts/1        192.168.225.1    Tue Dec  4 10:28 - 10:29  (00:01)    
root     pts/0        192.168.225.1    Tue Dec  4 10:24 - 10:30  (00:05)    
root     pts/1        192.168.225.1    Tue Dec  4 10:18 - 10:28  (00:10)    
root     pts/0        192.168.225.1    Tue Dec  4 09:43 - 10:23  (00:39)    
root     pts/2        192.168.225.1    Tue Dec  4 09:23 - 09:41  (00:17)    
root     pts/2        192.168.225.1    Tue Dec  4 09:22 - 09:23  (00:00)    
root     pts/3        192.168.225.1    Tue Dec  4 09:17 - 09:17  (00:00)    
root     pts/2        192.168.225.1    Tue Dec  4 09:17 - 09:22  (00:05)    
root     pts/1        192.168.225.1    Tue Dec  4 09:16 - 09:41  (00:24)    
root     pts/0        192.168.225.1    Tue Dec  4 09:15 - 09:41  (00:25)    
root     tty1                          Tue Dec  4 09:15   still logged in   
reboot   system boot  3.10.0-693.el7.x Tue Dec  4 09:15 - 11:04  (01:49)    
root     tty1                          Mon Dec  3 10:36 - crash  (22:38)    
reboot   system boot  3.10.0-693.el7.x Mon Dec  3 10:36 - 11:04 (1+00:28)   

wtmp begins Mon Dec  3 10:36:08 2018
```

### history

history命令用于显示历史执行过的命令，最多一千条，格式为“history [-c]”。

```shell
[root@localhost ~]# history  
    1  cd /mnt/
    2  ls
    3  cd /dev
    4  ls
	.
	.
	.
```

我们可以用感叹号后面跟一个数字的方式去执行历史命令中的某一条执行过的命令,例如!9,我们就可以去执行历史命令中索引为9的命令。  

还有一种方式，比如我们最近敲过"systemctl restart sshd"这条命令，如果这条命令之后没有s开头的命令那我们就可以用"!s"去执行这条命令，如果有"s"开头的但不是"sy"开头的，那我们可以用"!sy"去执行这条命令。

### sosreport

sosreport命令用于收集系统配置及架构信息并输出诊断文档，格式为sosreport。  

```shell
最小化安装centos中默认没有这个组件，用yum安装
[root@localhost ~]# yum install sos -y
[root@localhost ~]# sosreport
注意，敲过这条命令还会提示让你把报告保存到指定位置，如果不指定位置，那默认位置就是/var/tmp/中  
```

## 工作目录切换命令

linux系统目录
![linux系统目录](https://s1.ax1x.com/2018/12/04/FQYXtg.jpg)  

### pwd

pwd命令用于显示用户当前所处的工作目录，格式为“pwd [选项]”。  

```shell
[root@localhost ~]# pwd
/root
```

### cd

cd命令用于切换工作路径，格式为“cd [目录名称]”。  

```shell
回到家目录的两种方法：  
[root@localhost ~]# cd
[root@localhost ~]# cd ~

回到切换目录之前的目录  
[root@localhost ~]# cd -
```

在路径中，一个英文句号代表当前目录，两个英文句号代表上级目录
绝对路径：能详细描述一个目录的位置，无论当前工作目录在哪里都能通过绝对路径切换到指定目录
相对路径：相对于当前工作目录所在的路径，切换了当前所在目录后，相对路径也会改变

```shell
进入当前目录
[root@localhost ~]# cd .

进入上级目录
[root@localhost ~]# cd ..

进入上上级目录
[root@localhost ~]# cd ../..

英文句号在切换相对路径中的应用
从"/usr/share/locale"目录切换到"/usr/local/bin"目录，使用相对路径切换
[root@localhost ~]# cd /usr/share/locale/
[root@localhost locale]# pwd
/usr/share/locale
[root@localhost locale]# cd ../../local/bin/
[root@localhost bin]# pwd
/usr/local/bin
[root@localhost bin]# cd ../../local/bin/../../local/bin/
[root@localhost bin]# pwd
/usr/local/bin
```

### ls

ls命令用于显示目录中的文件信息，格式为“ls [选项] [文件] ”。  
我们通常会使用ls -l查看目录中文件的详细信息，centos默认帮我们设置好了"ls -l"的别名"ll"，我们一般会加上-h的参数自动改变文件大小的单位  

```shell
[root@localhost ~]# ls
anaconda-ks.cfg  QQ9.0.8.24199.exe  wget-log

[root@localhost ~]# ll -h
总用量 73M
-rw-------. 1 root root 1.5K 12月  3 10:35 anaconda-ks.cfg
-rw-r--r--. 1 root root  73M 11月 29 11:16 QQ9.0.8.24199.exe
-rw-r--r--. 1 root root 111K 12月  4 10:01 wget-log

查看当前目录下的隐藏文件
[root@localhost ~]# ls -a
.   anaconda-ks.cfg  .bash_logout   .bashrc  hello.txt          .tcshrc   wget-log
..  .bash_history    .bash_profile  .cshrc   QQ9.0.8.24199.exe  .viminfo

```

## 文本编辑命令

### cat

cat命令用于查看纯文本文件（内容较少的），格式为“cat [选项] [文件]”。

```shell
[root@localhost ~]# echo "helloworld" > hello.txt
[root@localhost ~]# cat hello.txt
helloworld
```

### more

more命令用于查看纯文本文件（内容较多的），格式为“more [选项]文件”。

用法和cat一样，空格翻页，回车换行，q退出

