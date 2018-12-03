# Linux day1

## Linux系统安装后做的事情

*1* 关机打最初始的纯净快照  
*2* 用xshell、securecrt或putty等终端软件通过ssh远程连接管理linux  
**2.1** 在linux本地系统中通过root用户进入系统后，使用ip add命令查看ip地址  
*3* 学习Linux密码的破解，在忘记linux中用户密码的情况下修改Linux用户密码  
**3.1** 开机在grub引导界面，将光标定位到第一行的情况下（默认光标就在第一行）按下e键进去grub编辑界面，用方向键定位到linux16开头的行的行尾，一直删除到ro后面，ro和后面的空格要保留，在ro后的空格后面添加rd.break，按下键盘上的ctrl+x快捷键进入救援模式，进入救援模式后，用以下命令进行密码修改  

```shell
# mount -o remount,rw
# chroot /sysroot
# passwd root   # 在这行进行密码修改，救援模式的作用不仅仅是修改密码，如果linux出问题无法开机，也可以进入救援模式进行修复，只要把这一步替换掉即可，注意，其他步骤不能改变
# touch /.autorelabel
# exit
# exit
# 等待重启进入系统中，这时候，root用户或者指定用户的密码就已经被修改成功了
```
