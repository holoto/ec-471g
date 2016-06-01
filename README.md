# ec-471g 黑苹果配置文件 hackintosh 10.11.5
#mac osx version 10.11.5
 :smile:

#[english README](https://github.com/holoto/ec-471g/blob/master/README_EN.md)
 最新clover v3489
 
`git clone https://github.com/holoto/ec-471g.git`

# 本人提供黑苹果安装服务


[咸鱼链接](https://2.taobao.com/item.htm?spm=2007.1000622.0.0.iCkUXt&id=528507949582)


## 无法解决的问题

            缺陷
            
            
            
1.'原装的无线网卡ar9485无法驱动 国外也无解 建议购买其他网卡替换'

4.'英伟达gt630m 独显无法驱动使用 国外也无解'


# 亮点
  1. 显卡hd4000已经驱动 显存1536MB
  2. 声卡alc269已经使用万能声卡驱动
  3. 稳定关机断电休眠
  4. 亮度可以正常正常调节
  5. 摄像头已经正常识别使用
  6. USB驱动正常
  7. USB完美驱动
  8. 鼠标 键盘 使用AnyAppleUSBKeyboard.kext AnyAppleUSBMouse.kext 伪造id 已经识别为苹果设备
  9. 摄像完美驱动
  10. 也使用了AnyiSightCam.kext 伪造id 已经识别为苹果摄像头
  11. 其他功能正常
  12.  非常稳定
  13. 本人重启验证上百次

# clvoer prebootlog

[prebootlog](https://raw.githubusercontent.com/holoto/ec-471g/master/EFI/EFI/CLOVER/misc/preboot.log)




            电脑详细信息 


[京东商城链接](http://item.jd.com/849503.html)




![鲁大师配置图](https://raw.githubusercontent.com/holoto/ec-471g/master/pic/截屏图片.jpg "鲁大师配置图")





## 补充 
        1tb sshd 混合硬盘   分区GPT+Journaled HFS     OSX10.11.5 
       
        500GB    机械硬盘   分区MBR+NTFS              系统win10系统
            
            /dev/disk0 (internal, physical): 1tb sshd 混合硬盘 在笔记本硬盘位
               #:                       TYPE NAME                    SIZE       IDENTIFIER
               0:      GUID_partition_scheme                        *1.0 TB     disk0    
               1:                        EFI EFI                     209.7 MB   disk0s1  引导区
               2:                  Apple_HFS osx                     999.3 GB   disk0s2  0SX10.11.5
               3:                 Apple_Boot Recovery HD             650.0 MB   disk0s3  OSX恢复分区
            /dev/disk1 (internal, physical): 500GB    机械硬盘 在笔记本光驱位
               #:                       TYPE NAME                    SIZE       IDENTIFIER
               0:     FDisk_partition_scheme                        *500.1 GB   disk1   
               1:               Windows_NTFS 64WinXP                 161.1 GB   disk1s1  win10系统盘
               2:               Windows_NTFS soft                    161.1 GB   disk1s5  
               3:               Windows_NTFS word                    53.7 GB    disk1s6
               4:               Windows_NTFS gamepower               124.3 GB   disk1s7



# 和宏碁e1-471g 差不多 只不过ec-471g的usb接口阉割成2.0 其他一样




            osxd运行截图
![osx](https://raw.githubusercontent.com/holoto/ec-471g/master/pic/mac1.png "osx运行截图")
![osx3](https://raw.githubusercontent.com/holoto/ec-471g/master/pic/mac4.png "osx运行截图")
![osx5](https://raw.githubusercontent.com/holoto/ec-471g/master/pic/mac5.png "osx运行截图")
![osx1](https://raw.githubusercontent.com/holoto/ec-471g/master/pic/mac2.png "osx运行截图")
![osx2](https://raw.githubusercontent.com/holoto/ec-471g/master/pic/mac3.png "osx运行截图")

## osx software
![app](https://raw.githubusercontent.com/holoto/ec-471g/master/pic/app.png "osx运行截图")
![app2](https://raw.githubusercontent.com/holoto/ec-471g/master/pic/app2.png "osx运行截图")
![app3](https://raw.githubusercontent.com/holoto/ec-471g/master/pic/app3.png "osx运行截图")




                    目录


[EFI](https://github.com/holoto/ec-471g/tree/master/EFI) CLOVER(四叶草)引导目录


[pic](https://github.com/holoto/ec-471g/tree/master/pic) 黑苹果运行截图


[ssdtpregen](https://github.com/holoto/ec-471g/tree/master/ssdtprgen) osx下生成ssdt的小工具


[tool](https://github.com/holoto/ec-471g/tree/master/tool) 安装维护黑苹果的工具


[电脑底层信息检测结果](https://github.com/holoto/ec-471g/tree/master/Darwindumperreports)电脑底层信息检测结果


