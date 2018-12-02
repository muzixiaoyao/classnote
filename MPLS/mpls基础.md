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
