Bisk
====

*"Shell script to backup MBR, GPT and data partitions"*

# Usage

* There are the `/dev/sda` device's partitions:

```
$ lsblk /dev/sda
NAME          MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINT
sda           259:0    0 238.5G  0 disk
├─sda1        259:1    0   199M  0 part  /boot/efi
└─sda2        259:2    0 237.7G  0 part
```

* Backup the `/dev/sda` device:

```
$ mkdir out
$ sudo bisk /dev/sda out
$ tree out/
out/
├── sda1.gz
├── sda2.gz
├── sda_gpt.bsc
└── sda_mbr.img
```
