#Translation by Google translation
#If you think this article is good, you can star
#acer-ec-471g  hackintosh clover config
#mac osx version 10.11.5
 :smile:
#[Chinese README](https://github.com/holoto/ec-471g/blob/master/README.md)
#The latest version of Clover version V3489

`git clone https://github.com/holoto/ec-471g.git`

#  provide installation services (in china)


[installation services link](https://2.taobao.com/item.htm?spm=2007.1000622.0.0.iCkUXt&id=528507949582)


## Can not solve the problem


1. 'original ar9485 wireless network card can not be driven abroad no solution is recommended to buy other cards to replace'

4. 'NVIDIA gt630m alone was unable to drive the use of foreign also no solution'


# driver
1. hd4000 graphics card has 1536MB memory and drive
2. Sound alc269 has a universal sound card driver
3. Stable shut off Sleep
4. Normal Normal brightness can be adjusted
5. The camera has been recognized properly use
6. USB drive normal
7. USB drive perfect
8. mouse and keyboard use AnyAppleUSBKeyboard.kext AnyAppleUSBMouse.kext fake id has been identified as Apple devices
9. Camera perfect drive
10. also used AnyiSightCam.kext fake id has been identified as the Apple Camera
11. Additional functioning
12. Very stable
13. restart verified hundreds of times
14. win10 + osx10.11.5 boot menu

# clvoer prebootlog

[prebootlog](https://raw.githubusercontent.com/holoto/ec-471g/master/EFI/EFI/CLOVER/misc/preboot.log)




#Computer details


[jd mall link](http://item.jd.com/849503.html)




![Master Lu configuration diagram](https://raw.githubusercontent.com/holoto/ec-471g/master/pic/截屏图片.jpg "鲁大师配置图")





##  Supplement
         1tb sshd hybrid hard disk partition GPT + Journaled HFS OSX10.11.5

                500GB mechanical hard disk partition MBR + NTFS system win10 system


            /dev/disk0 (internal, physical): 1tb sshd notebook hybrid hard drive bays
               #:                       TYPE NAME                    SIZE       IDENTIFIER
               0:      GUID_partition_scheme                        *1.0 TB     disk0
               1:                        EFI EFI                     209.7 MB   disk0s1  efi boot partition
               2:                  Apple_HFS osx                     999.3 GB   disk0s2  0SX10.11.5
               3:                 Apple_Boot Recovery HD             650.0 MB   disk0s3   OSX recovery partition
            /dev/disk1 (internal, physical): 500GB  hard drive in a notebook optical drive
               #:                       TYPE NAME                    SIZE       IDENTIFIER
               0:     FDisk_partition_scheme                        *500.1 GB   disk1
               1:               Windows_NTFS 64WinXP                 161.1 GB   disk1s1   win10 system disk
               2:               Windows_NTFS soft                    161.1 GB   disk1s5
               3:               Windows_NTFS word                    53.7 GB    disk1s6
               4:               Windows_NTFS gamepower               124.3 GB   disk1s7



# Acer e1-471g almost just ec-471g usb interface castration as a 2.0 Other




             osx run shot
![osx](https://raw.githubusercontent.com/holoto/ec-471g/master/pic/mac1.png "osx运行截图")
![osx3](https://raw.githubusercontent.com/holoto/ec-471g/master/pic/mac4.png "osx运行截图")
![osx5](https://raw.githubusercontent.com/holoto/ec-471g/master/pic/mac5.png "osx运行截图")
![osx1](https://raw.githubusercontent.com/holoto/ec-471g/master/pic/mac2.png "osx运行截图")
![osx2](https://raw.githubusercontent.com/holoto/ec-471g/master/pic/mac3.png "osx运行截图")
## osx software
![app](https://raw.githubusercontent.com/holoto/ec-471g/master/pic/app.png "osx运行截图")
![app2](https://raw.githubusercontent.com/holoto/ec-471g/master/pic/app2.png "osx运行截图")
![app3](https://raw.githubusercontent.com/holoto/ec-471g/master/pic/app3.png "osx运行截图")



                    table of Contents


[EFI](https://github.com/holoto/ec-471g/tree/master/EFI) CLOVER (Clover) boot directory


[Pic](https://github.com/holoto/ec-471g/tree/master/pic) Black Apple run shot


Ssdt generated under [ssdtpregen](https://github.com/holoto/ec-471g/tree/master/ssdtprgen) osx gadgets


[Tool](https://github.com/holoto/ec-471g/tree/master/tool)  hackintosh installation and maintenance tools


[Computer underlying information test results](https://github.com/holoto/ec-471g/tree/master/Darwindumperreports) computer test results underlying information
