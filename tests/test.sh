#!/bin/sh

set -e

DEVICE="$(losetup -f 2>/dev/null)"

teardown()
{
    printf "\nTEARDOWN - [BEGIN]\n\n"

    printf "Detach logical volumes...\n\n"
    dmsetup remove TestDiskGroup-root
    dmsetup remove TestDiskGroup-home

    printf "Remove the disk image's block device...\n\n"
    losetup -d "$DEVICE"

    printf "TEARDOWN - [END]\n"
}

setup()
{
    echo "SETUP - [BEGIN]"

    printf "\nCheck for an available loop device...\n\n"
    if [ -z "$DEVICE" ]; then
        echo 'No loop device available'
        exit 1
    fi

    printf "Create the '${DEVICE}' block device from './test-disk.img'...\n\n"
    losetup -P "$DEVICE" ./test-disk.img

    # Remove the block device if anything wrong happens
    trap teardown EXIT

    printf "Scan for lvm volumes into '${DEVICE}'...\n\n"
    modprobe dm_mod
    vgscan
    vgchange -ay

    printf "\nSETUP - [END]\n"
}

test_main()
{
    setup

    printf "\nList all the block devices...\n\n"
    lsblk -f -p -n -l "$DEVICE"
    sleep 5

    ../bisk "$DEVICE" out
}

test_main
