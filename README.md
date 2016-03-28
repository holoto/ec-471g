# ec-471g 黑苹果配置文件 hackintosh

 :smile: 
 
        git clone https://github.com/holoto/ec-471g.git

# 本人提供黑苹果安装服务


[咸鱼链接](https://2.taobao.com/item.htm?spm=2007.1000622.0.0.iCkUXt&id=528507949582)


## 本配置文件有少许缺陷 请谨慎使用!! 建议不要使用本配置文件的dsdt 

            缺陷
            
            
            
1.'原装的无线网卡ar9485无法驱动 国外也无解 建议购买其他网卡替换'

2.'摄像头无法识别 1.2M的像素超级渣'

3.'关机,重启有时候无法断电'

4.'英伟达gt630m 独显无法驱动使用 国外也无解'


            电脑详细信息 


[京东商城链接](http://item.jd.com/849503.html)




![鲁大师配置图](https://raw.githubusercontent.com/holoto/ec-471g/master/pic/截屏图片.jpg "鲁大师配置图")





## 补充 
        1tb sshd 混合硬盘   分区GPT+Journaled HFS     OSX10.11.3 
       
        500GB    机械硬盘   分区MBR+NTFS              系统win10系统
            
            /dev/disk0 (internal, physical): 1tb sshd 混合硬盘 在笔记本硬盘位
               #:                       TYPE NAME                    SIZE       IDENTIFIER
               0:      GUID_partition_scheme                        *1.0 TB     disk0    
               1:                        EFI EFI                     209.7 MB   disk0s1  引导区
               2:                  Apple_HFS osx                     999.3 GB   disk0s2  0SX10.11.3
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
![osx1](https://raw.githubusercontent.com/holoto/ec-471g/master/pic/mac2.png "osx运行截图")
![osx2](https://raw.githubusercontent.com/holoto/ec-471g/master/pic/mac3.png "osx运行截图")



                    目录


[EFI](https://github.com/holoto/ec-471g/tree/master/EFI) CLOVER(四叶草)引导目录


[pic](https://github.com/holoto/ec-471g/tree/master/pic) 黑苹果运行截图


[ssdtpregen](https://github.com/holoto/ec-471g/tree/master/ssdtprgen) osx下生成ssdt的小工具


[tool](https://github.com/holoto/ec-471g/tree/master/tool) 安装维护黑苹果的工具


[电脑底层信息检测结果](https://github.com/holoto/ec-471g/tree/master/Darwindumperreports)电脑底层信息检测结果


