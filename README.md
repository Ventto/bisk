Bisk
====

*"Shell script to backup MBR, GPT and data partitions (including logical ones)"*

# Usage

* There are the `/dev/sda` device's partitions:

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

You have at your disposal a `tests/test-disk.img` disk image file which is
partitioned as following (including the logical volumes into `test-disk.img4`):

```
$ fdisk -l test-disk.img
Disk test-disk.img: 64 MiB, 67108864 bytes, 131072 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: B2C22CCA-1713-42FA-8F0C-4D157F4F9AC1

Device          Start    End Sectors Size Type
test-disk.img1   2048  69631   67584  33M Microsoft basic data
test-disk.img2  69632  90111   20480  10M Linux filesystem
test-disk.img3  90112 110591   20480  10M Linux swap
test-disk.img4 110592 131038   20447  10M Linux filesystem
```

If you loop-mount the disk image file manualy, you could list the primary
partitions along with the logical volumes:

```
$ lsblk -f -p -n /dev/loop1
/dev/loop1
├─/dev/loop1p1            vfat         8774-44C7
├─/dev/loop1p2            ext4         f482e0d4-49e5-4321-8286-e4ff7f26983c
├─/dev/loop1p3            swap         e2f7568c-36a1-48f1-b525-4cca7e64729e
└─/dev/loop1p4            LVM2_m       Fpq4IB-mNyf-WzNF-ZWQL-Q9MH-NeMo-cULuIu
  ├─/dev/mapper/TestDiskGroup-home
  │                       ext4         a80d896e-72ff-44b9-b7f2-ae273436f50f
  └─/dev/mapper/TestDiskGroup-root
                          ext4         0fadeb4f-233b-40cd-ad95-35275129a490
```

Run the test script as following:

```bash
$ cd tests
$ sudo ./test.sh
```

