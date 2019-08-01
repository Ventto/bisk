#!/bin/sh

set -e

DEVICE="$(losetup -f 2>/dev/null)"

handler_exit()
{
    teardown
}

teardown()
{
    printf "\nTEARDOWN - [BEGIN]\n\n"

    printf "Detach logical volumes...\n\n"

    if lvs -a -o +devices 2>/dev/null | grep "$DEVICE" >/dev/null 2>&1; then
        lv_list="$(lvs -a -o +devices | \
                   grep "$DEVICE" | \
                   awk '{print $2 "/" $1}')"
        for lv in $lv_list; do
            echo "Unmap the '${lv}' logical volume..."
            dmsetup remove "$lv"
        done
    fi

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

    # Remove the block device if anything goes wrong or ctrl-c
    trap handler_exit EXIT

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

    printf "\nRun bisk...\n\n"
    ../bisk "$DEVICE" out
}

test_main
