# nlp_server
### Network Printer Server(ODROID-C4)
* Linux OS Image https://dn.odroid.com/S905X3/ODROID-C4/Ubuntu/ubuntu-20.04-4.9-minimal-odroid-c4-hc4-20220228.img.xz
* Available printer : Zebra GC420d(Discontinued product), Zebra ZD230D
* Printer connect : Direct USB Port connection.
* Printer control : Zebra EPL2 protocol with Python zebra library.
* Find nlp server : nmap 192.168.xxx.* -p T:8888 --open

### Install package
* apt update && apt upgrade -y
* apt install build-essential vim ssh git python3 python3-pip cups cups-bsd overlayroot
* python3 -m pip install zebra cups psutil asyncio

### Label Printer setup & test
* Print device info
```
root@odroid: lpinfo -v
network http
file cups-brf:/
network beh
network https
network lpd
network ipps
network socket
network ipp
direct usb://Zebra%20Technologies/ZTC%20GC420d%20\(EPL\)
direct usb://Zebra%20Technologies/ZTC%20ZD230-203dpi%20ZPL?serial=D4J222603053
network socket://192.168.20.36
```
* Printer setting state
```
root@odroid: lpstat -v
lpstat: No destinations added.
```
* Label printer setup (GC420d)
```
root@odroid: lpadmin -p zebra -E -v usb://Zebra%20Technologies/ZTC%20GC420d%20\(EPL\)
root@odroid: lpstat -v
device for zebra: usb://Zebra%20Technologies/ZTC%20GC420d%20\(EPL\)
```
* Label printer setup (ZD230D)
```
root@odroid: lpadmin -p zebra -E -v usb://Zebra%20Technologies/ZTC%20ZD230-203dpi%20ZPL?serial=D4J222603053
root@odroid: lpstat -v
device for zebra: usb://Zebra%20Technologies/ZTC%20ZD230-203dpi%20ZPL?serial=D4J222603053
```
* Label printer test (web site & mac address print)
```
root@odroid:~/nlp_server# python3 label_printer.py
```

### Install iperf package for odroid board iperf test. (In "install" folder)
* dpkg -i libiperf0_3.1.3-1_arm64.deb
* dpkg -i iperf3_3.1.3-1_arm64.deb

### Install nlp and iperf server service
```
root@odroid:~/nlp_server/install# ./install.sh
root@odroid:~/nlp_server/install# systemctl status nlp_server.service 
● nlp_server.service - Label Printer Server for ODROID
     Loaded: loaded (/etc/systemd/system/nlp_server.service; enabled; vendor pr>
     Active: active (running) since Mon 2022-11-21 08:40:42 UTC; 15s ago
    Process: 3792 ExecStartPre=/bin/sleep 10 (code=exited, status=0/SUCCESS)
   Main PID: 3802 (python3)
      Tasks: 1 (limit: 3838)
     Memory: 10.2M
     CGroup: /system.slice/nlp_server.service
             └─3802 /usr/bin/python3 nlp_server.py

Nov 21 08:40:32 odroid systemd[1]: Starting Label Printer Server for ODROID...
Nov 21 08:40:42 odroid systemd[1]: Started Label Printer Server for ODROID.
root@odroid:~/nlp_server/install# reboot

```
### OverlayFS Enable
* initrd.img update for overlayroot.
```
root@odroid:~# update-initramfs -c -k $(uname -r)
update-initramfs: Generating /boot/initrd.img-4.9.277-75
root@odroid:~#
root@odroid:~# mkimage -A arm64 -O linux -T ramdisk -C none -a 0 -e 0 -n uInitrd -d /boot/initrd.img-$(uname -r) /media/boot/uInitrd 
Image Name:   uInitrd
Created:      Wed Feb 23 09:31:01 2022
Image Type:   AArch64 Linux RAMDisk Image (uncompressed)
Data Size:    13210577 Bytes = 12900.95 KiB = 12.60 MiB
Load Address: 00000000
Entry Point:  00000000
root@odroid:~#
```
* Enable overlayroot (change value overlayroot="" to overlayroot="tmpfs" in /etc/overlayroot.conf file.)
```
root@odroid:~# vi /etc/overlayroot.conf
overlayroot_cfgdisk="disabled"
overlayroot="tmpfs"
```
### Modified/Disable overlayroot
* Get write permission for modify in overlayroot .
```
root@odroid:~# overlayroot-chroot 
INFO: Chrooting into [/media/root-ro]
root@odroid:~# 
```
* Disable overlayroot (change value overlayroot="tmpfs" to overlayroot="" in /etc/overlayroot.conf file.)
```
root@odroid:~# vi /etc/overlayroot.conf
overlayroot_cfgdisk="disabled"
overlayroot=""
```
