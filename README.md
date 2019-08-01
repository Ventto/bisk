Bisk
====

*"Shell script to backup MBR, GPT and data partitions (including logical ones)"*

# Getting Started

```bash
$ lsblk /dev/sda
NAME          MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINT
sda           259:0    0 238.5G  0 disk
├─sda1        259:1    0   199M  0 part  /boot/efi
└─sda2        259:2    0 237.7G  0 part
```

* Backup the `/dev/sda` device:

```bash
$ mkdir out
$ sudo bisk /dev/sda out
$ tree out/
out/
├── sda1.gz
├── sda2.gz
├── sda_gpt.bsc
└── sda_mbr.img
```

# Test

* There is at your disposal a `tests/test-disk.img` disk image file which is
partitioned as following (including the logical volumes into `test-disk.img4`):

```
$ fdisk -l test-disk.img
[...]
Device          Start    End Sectors Size Type
test-disk.img1   2048  69631   67584  33M Microsoft basic data
test-disk.img2  69632  90111   20480  10M Linux filesystem
test-disk.img3  90112 110591   20480  10M Linux swap
test-disk.img4 110592 131038   20447  10M Linux filesystem
```

* After mounting the disk image file, you will obtain:

```
# lsblk -f -p -o NAME,FSTYPE /dev/loop1
NAME                            FSTYPE
/dev/loop1
├─/dev/loop1p1                  vfat
├─/dev/loop1p2                  ext4
├─/dev/loop1p3                  swap
└─/dev/loop1p4                  LVM2_m
  ├─/dev/mapper/test-disk-home  ext4
  └─/dev/mapper/test-disk-root  ext4
```

* Run the test script as following:

```bash
$ cd tests
$ sudo ./test.sh
```

* Results:

```
$ tree
out
├── logs
│   ├── loop0p1-partclone.log
│   ├── loop0p2-partclone.log
│   ├── test--disk-home-partclone.log
│   └── test--disk-root-partclone.log
├── loop0_gpt.pcl
├── loop0_mbr.img
├── loop0p1.gz
├── loop0p2.gz
├── test--disk-home.gz
└── test--disk-root.gz
```
