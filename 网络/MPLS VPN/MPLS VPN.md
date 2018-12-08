# MPLS VPN

## VPN 概述

传统的基于路由的虚拟专用网  

站点和站点之间租用运营商的点到点专线进行连接  

优点  

* 线路专用  
* 带宽独享  
* 流量受保护  

缺点

* 贵  

虚拟专用网：  
站点之间通过运行商共享网络创建的点到点的“虚拟专网”进行连接  
常见的虚拟专网技术：framerelay、ATM  
优势，相比于专线价格低廉，适用于各种环境  

## GRE 隧道：

将真实的IP封装在隧道接口IP的后面进行传输，让隧道帮我们帮流量传过去  

```route
(config)#int tunnel 0
(config)#ip add 1.1.1.1 255.255.255.0
(config)#ip ospf 1 area0
(config)#tunnel source e0/0
(config)#tunnel destination 10.1.2.2
(config)#tunnel mode ip ip
(config)#no sh
```

## mpls vpn术语

* P：  
  * 运营商专用设备，和运营商内部其他设备连接或运行商边界设备  

* PE：  
  * 运行商边界设备，连接到客户边界设备和运行商内部设备  
* CE：  
  * 客户端边界设备，与客户内部设备和运行商边界设备连接  
* C：  
  * 客户内部设备，连接到其他客户设备或客户边界设备，运行客户内部IGP协议  
* VRF：  
  *虚拟路由及转发，它是一种VPN路由和转发实例。  
  * 由于PE设备可能连接不止一个VPN客户，这些客户之间的路由需要相互隔离，这时候就需要用到VRF技术。  
  * PE路由器上每个客户都有一个独立的VRF。PE路由器除了要维护全局路由表之外，还需要为每个VRF维护一个独立的路由表，这些路由表被称为VRF路由表。  
  * 由于每个VRF都有一个独立的路由表，所以每个VRF也会有一个独立的CEF表来转发这些报文，这就是VRF CEF表。  
  * 路由器创建了VRF之后，我们就客户把物理接口划入到VRF中，同一个物理接口只能属于一个VRF路由器，这个接口只为这个VRF工作。  
  * 一个VRF所关联的数据结构：  
    * 路由表  
    * CEF转发表  
    * 动态路由协议  
    * 属于该VRF的接口  
      * 一个VRF可以有多个接口  
      * 一个接口只能属于一个VRF  

### 与VRF关联的rd和rt

* rd
  * 64位的rd标签加上32位的ip前缀组成了96位的vpnv4的前缀
  。  
  * 防止和其他客户进入路由器的ip前缀冲突
  * rd值并不会告诉路由前缀应该进入哪个vrf，需要搭配rt来使用
  * rd并不是vpn的标识符，在复杂的网络环境中可能一个vpn存在多个rd值
  * rd的表示方式可以有两种，AS:nnh或者ipadd:nn，其中nn代表编号，最常用的格式就是as:nn。其中as是区域号，是IANA分配给服务提供商的AS号，nn是服务提供商分配给vrf的唯一号码，产生的vpnv4前缀通过MP-BGP在PE路由器之间进行传递。

* rt
  * 路由标签，用来区分vpn 客户的，是mp-bgp中的community的扩展属性。跟在vpnv4后面进行遗弃传递。一条路由可以附加多个rt值
  * export rts：通过在vrf中设置rt值，将使得输出的vpnv4路由携带上该rt值一起传递
  * import rts：PE路由器会从其他mp-bgp对等体的PE收到VPNv4的路由，这些前缀都是带有rt值的，默认情况下，路由器不会将vpnv4路由以ipv4的形式直接转存到vrf表里，除非在本地vrf中配置import rts值，如果某个vrf中import rts与收到的vpnv4前缀携带的rt相等的话，会将此条目以ipv4的形式转载到相应vrf的路由表中。

## mpls vpn 运行的过程

ce和pe成为ebgp邻居，ce将ipv4路由给pe路由器，pe路由器的vrf接收到ce来的路由后为这些路由加上rd值成为vpnv4的前缀，在离开vrf的时候会被mp-bgp的扩展属性加上rt值，rt是被遗弃传递的。
所有的p路由器需要运行mpls帮助传递来自于pe路由器的vpnv4前缀，当vpnv4到达mpbgp对等体的pe路由后，会检查rt值，是否是这台pe中某个vrf的，如果pe路有某个vrf中import rt值与pe路由器接收到的vpnv4的rt值相同，那么则将此vpnv4前缀的rt值丢弃且将此vpnv4的路由变为ipv4转入到此vrf中，然后再通过vrf中的路由表将路由传递给ce。

## mpls vpn中的一些配置

配置好ISP中的IGP路由和mpls后，设置PE路由器上的VRF

PE2

```route
(config)#ip vrf cisco
(config-vrf)#rd 100:1
(config-vrf)#route-target export 234:2
(config-vrf)#route-target import 234:4
(config-vrf)#exit
(config)#int e0/0
R2-PE1(config-if)#ip vrf forwarding cisco
```