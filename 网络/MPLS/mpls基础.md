# mpls基础

## 数据交换方式

### Process Switching（进程交换）

一个数据流中的第一个包被放入系统缓存中，拆包后查看目的IP，将目的IP拿到路由表中查询，如果未查询到目的IP则丢弃，如果查询正确，则路由器对此数据包进行CRC校验，改写此数据包二层帧头中的目的mac地址，重新将改写过的二层帧头压在三层数据包的前面转发出去，这样的过程会对这个数据流中的其他数据包持续作用。

转发效率低，会造成高延迟，对路由器性能损耗很大

### Fast Switching（快速交换）

只对一个数据流中的第一个包做进程交换，将信息存入cache，这个数据流中所有后续的包直接从cache中提取目的接口、目的mac等信息进行转发，效率比进程交换高很多

优化了进程交换，提升数据包转发的性能

### 优化和分布式交换

optimum switching（优化交换）

distributed switching（分布式交换）

这两种交换方式在原理上和快速交换基本相同，只不过使用的是一种经过优化的缓存（system buffer）速度比平常的cache快很多

### cisco express switching 思科超快交换

CEF不仅仅是将数据都存入system buffer，而是将整个路由表、拓扑表、以及所有下一跳地址、mac地址全部都进行“预存”。

开启路由器cef功能

    R1(config)#ip cef

关闭路由器cef功能

    R1(config)#no ip cef

查看路由器cef表

    R1#show ip cef

查看路由目的出口

    R1#show ip cef [dst.ip]
    R1#show ip cef 3.3.3.3

查看cef转发路径

    R1#show ip cef exact-route [src.ip] [dst.ip]
    R1#show ip cef exact-route 1.1.1.1 3.3.3.3

查看邻接表(只能看到邻居的信息)

    R1#show adjacency detail

## MPLS介绍

*1.* mutil-Protocal label switching 多协议标签交换
**1.1.**  mutil protocal ：支持三层协议
**1.2.** label switching：在所承载的报文前面加上标签栈，基于标签来做转发
*2.* mpls是一种新的转发机制，数据在mpls网络中是根据标签进行转发数据的
*3.* 一般情况下，mpls的标签对应目的地址的路由前缀
*4.* mpls依赖IP路由以及CEF交换
*5.* mpls能够承载多重三层协议

### mpls机制

*1.* 路由器运行IGP路由协议，维护RIB(路由表)和CEF表
*2.* 路由器运行标签分发协议(LDP),维护LIB表
*3.* 路由器更新CEF表，同时维护LFIB表

### 三张表

- FIB表：就是cef表
- LIB表：就是标签信息表
  - 路由器为每一个IGP前缀在本地路由器上生成一个标签并分发给LDP邻居，同时也从LDP邻居接收到为特定前缀分发的标签，路由器将本地标签和远程标签存储在LIB表中
- LFIB表（标签转发信息库）
  - LSR路由可能收到某个特定前缀的多个标签（多个LDP邻居分发的），但他只需要使用其中一个，IP路由表用来确定这个IPV4.google.com前缀的下一跳。LSR用这样的信息来创建他的LFIB。在LFIB中本地捆绑的标签为入站标签，从LDP邻居学习过来的标签作为入站流量的出站标签。

### 基本名词

- A Label Switching Route（LSR）
  - 一台支持并激活了MPLS的设备
  - 三种LSR
    - 入站LSR
    - 出站LSR
    - 中间LSR
- A Lalel Switching Path（LSP）
  - LSP是报文在穿越mpls网络或部分mpls网络时的LSR序列
  
## 简单mpls部署

```route cmd
R1
R1(config)#ip cef
R1(config)#mpls ldp route-id lo0
R1(config)#mpls label range 100 199
R1(config)#int e0/0
R1(config-if)#mpls ip

R1
R1(config)#ip cef
R1(config)#mpls ldp route-id lo0
R1(config)#mpls label range 200 299
R1(config)#int ra e0/0 -1
R1(config-if)#mpls ip
```

查看标签数据库

```route cmd
R1#show mpls ldp bindings
```

查看LFIB表

```route cmd
R1#show mpls forwarding-table
```

查看邻居发现情况

```route cmd
R1#show mpls ldp discovery
```

## MPLS解决BGP路由黑洞问题探讨：
mpls不会为bgp的路由前缀分发标签，但会为bgp路由递归查询的下一跳分发标签