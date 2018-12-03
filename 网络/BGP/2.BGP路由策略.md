# BGP路由策略

## AS-PATH

R4
![](https://t1.picb.cc/uploads/2018/11/18/JXUTqF.png)

    ip as-path access-list 1 deny _200$
    ip as-path access-list 1 permit .*
    ip as-path access-list 2 permit _200_

    route-map as-path1 permit 10
    match as-path 2
    set weight 100
    !
    route-map as-path1 permit 20

    router bgp 400
    bgp log-neighbor-changes
    neighbor 192.168.34.3 remote-as 300
    neighbor 192.168.34.3 route-map as-path1 in
    neighbor 192.168.34.3 filter-list 1 in

## community

![](https://t1.picb.cc/uploads/2018/11/18/JXUTqF.png)

在R1上为100.100.100.0的路由打上community标记100:1，前面的100是as号，后面的是自定义的路由器编号

    R1#show run | sec ip acc  
    R1#show run | sec acc   
    access-list 1 permit 100.100.100.0
    R1#sh run | sec route-map
    neighbor 192.168.12.2 route-map comm out
    route-map comm permit 10
    match ip address 1
    set community 6553601
    route-map comm permit 20
    R1#sh run | sec router bgp
    router bgp 100
    network 100.100.100.0 mask 255.255.255.0
    neighbor 192.168.12.2 route-map comm out        #将community传递给R2
    neighbor 192.168.12.2 send-community            #将community的更新发送过去，不发送的话R2看不到R1传过来路由100.100.100.-的community属性

在R2上查看关于100.100.100.0路由的community属性

    R2
    show ip bgp 100.100.100.0
        Community: 6553601          #我们发现看见的这个属性是我们看不懂的
    ip bgp new-format       #使用新的格式显示community属性
    show ip bgp 100.100.100.0
        Community: 100:1
    router bgp 200
        neighbor 192.168.23.3 send-community

在R3上收到来自有关community 100:1的路由的时候改变他的权重为1001

    R3#show run | sec ip com
    ip community-list 1 permit 100:1
    R3#show run | sec route-map
    neighbor 192.168.23.2 route-map wei1 in
    neighbor 192.168.34.4 route-map wei1 out
    route-map wei1 permit 10
        match community 1
        set weight 1001
    route-map wei1 permit 20
    R3#sh run | sec router bgp
        router bgp 300
    bgp log-neighbor-changes
        neighbor 192.168.23.2 remote-as 200
        neighbor 192.168.23.2 route-map wei1 in
        neighbor 192.168.34.4 remote-as 400
        neighbor 192.168.34.4 route-map wei1 out

在R2上设置策略让R4学不到关于100.100.100.0的路由

    R2:
    access-list 1 permit 100.100.100.0
    route-map comm permit
    match ip address 1
    match community 100:1
    set community local-AS additive
    exit
    route-map comm permit 20
    router bgp 200
    nei 192.168.23.3 route-map comm out
    clear ip bgp * so

但是R3偏偏要告诉R4关于100.100.100.0的路由

    R3：
    access-list 2 permit 100.100.100.0
    ip community-list 2 permit local-as 
    route-map wei1 per 10
    match ip add 2
    set comm-list 2 delete